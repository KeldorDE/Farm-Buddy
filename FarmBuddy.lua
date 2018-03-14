-- **************************************************************************
-- * FarmBuddy.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FARM_BUDDY_ID = 'FarmBuddyStandalone';
local ADDON_NAME = 'Farm Buddy';
local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true);
local FarmBuddy = LibStub('AceAddon-3.0'):NewAddon(FARM_BUDDY_ID, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0');
local ldb = LibStub:GetLibrary('LibDataBroker-1.1');
local NOTIFICATION_QUEUE = {};
local NOTIFICATION_TRIGGERED = {};
local ITEM_STORAGE = {};
local ITEM_FRAMES = {};
local PLAYER_IN_COMBAT = false;
local DATA_BROKER;
local DEFAULTS = {
  profile = {
    items = {},
    settings = {
      showFrame = true,
      showTitle = true,
      showQuantity = true,
      includeBank = false,
      goalNotification = true,
      notificationDisplayDuration = 5,
      notificationGlow = true,
      notificationShine = true,
      playNotificationSound = true,
      notificationSound = SOUNDKIT.UI_WORLDQUEST_COMPLETE,
      frameLocked = false,
      showButtons = true,
      showGoalIndicator = true,
      showProgressBar = true,
      progressStyle = 'CountPercentage',
      progressBarNoGoalColor = { r = 1, g = .8, b = 0, a = 1 },
      progressBarGoalColor = { r = 0, g = .6, b = 0, a = 1 },
      progressBarNoQuantityColor = { r = 0, g = .5, b = 1, a = 1 },
      backgroundTransparency = 0.3,
      fastTrackingMouseButton = 'LeftButton',
      fastTrackingKeys = {
        ctrl = false,
        shift = false,
        alt = true,
      },
      showGoalBonus = false,
      goalBonusDisplay = 'percent',
      hideFrameInCombat = false,
      hideNotificationsInCombat = false,
      sortBy = 'name',
      sortOrder = 'asc',
      enableDataBrokerSupport = false,
      showDataBrokerItemName = true,
    }
  }
}

-- **************************************************************************
-- NAME : FarmBuddy:OnInitialize()
-- DESC : Is called by AceAddon when the addon is first loaded.
-- **************************************************************************
function FarmBuddy:OnInitialize()

  -- Init SavedVariables
  self.db = LibStub('AceDB-3.0'):New(FARM_BUDDY_ID .. 'DB', DEFAULTS);

  -- Register events
  self:RegisterEvent('BAG_UPDATE', 'BagUpdate');
  self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'ItemInfoRecived');
  self:RegisterEvent('PLAYER_REGEN_DISABLED', 'PlayerRegenDisabled');
  self:RegisterEvent('PLAYER_REGEN_ENABLED', 'PlayerRegenEnabled');

  DATA_BROKER = ldb:NewDataObject('FarmBuddyBroker', {
    type = 'data source',
    icon = 'Interface\\AddOns\\FarmBuddy\\FarmBuddy.tga',
    text = '',
  });

  -- Init addon stuff
  self:InitSettings();
  self:InitItems();
  self:SetTitleDisplay();
  self:SetButtonDisplay();
  self:SetFrameLockStatus();
  self:SetBackgroundTransparency();
  self:InitChatCommands();
  self:SetShowFrame();

  -- Set add item click event
  FarmBuddyFrame.AddItemButton:SetScript('OnClick', function(handle, button) self:AddItemClick(button) end);
end

-- **************************************************************************
-- NAME : FarmBuddy:InitItems()
-- DESC : Init all items including counts.
-- **************************************************************************
function FarmBuddy:InitItems()
  -- Copy saved items to temp storage to track counts
  if (self.db.profile.items ~= nil) then
    ITEM_STORAGE = self.db.profile.items;
    for index, itemStorage in pairs(ITEM_STORAGE) do
      if (itemStorage.itemID ~= nil and itemStorage.itemID > 0) then
        local itemInfo = self:GetItemInfo(itemStorage.itemID, itemStorage.id);
        if itemInfo ~= nil then
          ITEM_STORAGE[index].count = self:GetCount(itemInfo);
          ITEM_STORAGE[index].rarity = itemInfo.Rarity;
        else
          ITEM_STORAGE[index].count = 0;
          ITEM_STORAGE[index].rarity = 0;
        end
      else
        -- Fetch unknown items
        self:AddItemToQueue(itemStorage.id, itemStorage.name);
      end
    end

    self:SortItems();
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:SortItems()
-- DESC : Sort items by the given setting.
-- **************************************************************************
function FarmBuddy:SortItems()
  table.sort(ITEM_STORAGE, function(a, b)
    return self:SortItemsByKey(a, b, self.db.profile.settings.sortBy);
  end);
end

-- **************************************************************************
-- NAME : FarmBuddy:SortItemsByKey()
-- DESC : Sort items by the given key.
-- **************************************************************************
function FarmBuddy:SortItemsByKey(a, b, key)
  if (self.db.profile.settings.sortOrder == 'asc') then
    return a[key] < b[key];
  else
    return a[key] > b[key];
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:OnEnable()
-- DESC : Is called when the Plugin gets enabled.
-- **************************************************************************
function FarmBuddy:OnEnable()
  self:SecureHook('ContainerFrameItemButton_OnModifiedClick', 'ModifiedClick');
  self:ScheduleRepeatingTimer('NotificationTask', 1);
  self:ScheduleRepeatingTimer('ItemInfoRecived', 5);
end

-- **************************************************************************
-- NAME : FarmBuddy:OnDisable()
-- DESC : Is called when the Plugin gets disabled.
-- **************************************************************************
function FarmBuddy:OnDisable()
  self:CancelAllTimers();
end

-- **************************************************************************
-- NAME : FarmBuddy:BagUpdate()
-- DESC : Parse events registered to plugin and act on them.
-- **************************************************************************
function FarmBuddy:BagUpdate()
  self:InitItems();
  self:UpdateGUI();
end

-- **************************************************************************
-- NAME : FarmBuddy:ModifiedClick()
-- DESC : Is called when an item is clicked with modifier key.
-- **************************************************************************
function FarmBuddy:ModifiedClick(handle, button)

  local db = self.db.profile.settings;
  local conditions = false;

  -- Check modifier keys
  for key, state in pairs(db.fastTrackingKeys) do
    if (key == 'alt') then
      if (state == true) then
        conditions = IsAltKeyDown();
      else
        conditions = not IsAltKeyDown();
      end;

      if (conditions == false) then
        break;
      end;

    elseif (key == 'ctrl') then
      if (state == true) then
        conditions = IsControlKeyDown();
      else
        conditions = not IsControlKeyDown();
      end;

      if (conditions == false) then
        break;
      end

    elseif (key == 'shift') then
      if (state == true) then
        conditions = IsShiftKeyDown();
      else
        conditions = not IsShiftKeyDown();
      end;

      if (conditions == false) then
        break;
      end
    end
  end

  if button == db.fastTrackingMouseButton and not CursorHasItem() and conditions == true then

    local bagID = handle:GetParent():GetID();
    local bagSlot = handle:GetID();
    local itemLink = GetContainerItemLink(bagID, bagSlot);

    if itemLink ~= nil then
      local itemInfo = self:GetItemInfo(itemLink);
      if (itemInfo ~= nil) then

        local chatText;

        -- Add the item
        self:AddConfigItem(nil, itemInfo.ItemID, itemInfo.Name);
        self:InitItems();
        self:UpdateGUI();

        local text = L['FARM_BUDDY_ITEM_SET_MSG']:gsub('!itemName!', itemLink);
        self:Print(text);
      end
    end
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:GetItemIDByName()
-- DESC : Get the unique item ID by item name.
-- **************************************************************************
function FarmBuddy:GetItemIDByName(name)

  local id;

  for _, item in pairs(ITEM_STORAGE) do
    if (item.name == name) then
      id = item.id;
      break;
    end
  end

  return id;
end

-- **************************************************************************
-- NAME : FarmBuddy:QueueNotification()
-- DESC : Queues a notification.
-- **************************************************************************
function FarmBuddy:QueueNotification(index, item, quantity)
  NOTIFICATION_QUEUE[index] = {
    Index = index,
    Item = item,
    Quantity = quantity,
  };
end

-- **************************************************************************
-- NAME : FarmBuddy:NotificationTask()
-- DESC : Is called by the timer to handle the next notification.
-- **************************************************************************
function FarmBuddy:NotificationTask()
  if FarmBuddyNotification_Shown() == false then
    local hideInCombat = self.db.profile.settings.hideNotificationsInCombat;
    for index, notification in pairs(NOTIFICATION_QUEUE) do
      if (hideInCombat == false or (hideInCombat == true and PLAYER_IN_COMBAT == false)) then
        self:ShowNotification(notification.Index, notification.Item, notification.Quantity, false);
      else
        NOTIFICATION_TRIGGERED[notification.Index] = true;
      end
      NOTIFICATION_QUEUE[index] = nil;
      break;
    end
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:ShowNotification()
-- DESC : Raises a notification.
-- **************************************************************************
function FarmBuddy:ShowNotification(index, item, quantity, demo)

  local triggerStatus = true;
  if (NOTIFICATION_TRIGGERED[index] == nil or NOTIFICATION_TRIGGERED[index] == false) then
    triggerStatus = false;
  end

  local notificationEnabled = self.db.profile.settings.goalNotification;
  if (notificationEnabled == true and triggerStatus == false) or demo == true then
    local playSound = self.db.profile.settings.playNotificationSound;
    local notificationDisplayDuration = tonumber(self.db.profile.settings.notificationDisplayDuration);
    local notificationGlow = self.db.profile.settings.notificationGlow;
    local notificationShine = self.db.profile.settings.notificationShine;
    local sound = nil;

    if demo == true then
      item = L['FARM_BUDDY_NOTIFICATION_DEMO_ITEM_NAME'];
    end

    if playSound == true then
      sound = self.db.profile.settings.notificationSound;
    end

    if demo == false then
      NOTIFICATION_TRIGGERED[index] = true;
    end

    FarmBuddyNotification_Show(item, quantity, sound, notificationDisplayDuration, notificationGlow, notificationShine);
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:GetCount()
-- DESC : Gets the item count.
-- **************************************************************************
function FarmBuddy:GetCount(itemInfo, quantity, showIndicator)

  local includeBank = self.db.profile.settings.includeBank;
  local count = itemInfo.CountBags;
  local displayStyle = self.db.profile.settings.progressStyle;

  if includeBank == 1 or includeBank == true then
    count = itemInfo.CountTotal;
  end

  if(self.db.profile.settings.showQuantity == true and quantity ~= nil and quantity > 0) then

    -- Handle bonus display
    local bonus = '';
    if (self.db.profile.settings.showGoalBonus == true) then
      local bonusInPercent = true;
      local bonusUnit = '%';
      if (self.db.profile.settings.goalBonusDisplay == 'count') then
        bonusInPercent = false;
        bonusUnit = '';
      end

      local bonusValue = self:GetBonus(count, quantity, bonusInPercent);
      if (bonusValue > 0) then
        bonus = ' ' .. self:GetColoredText('+' .. bonusValue .. bonusUnit, 'FF00FF00');
      end
    end

    if (displayStyle == 'CountPercentage') then
      count = count .. ' / ' .. quantity .. ' (' .. self:GetPercent(count, quantity, true) .. '%)';
    elseif (displayStyle == 'Percentage') then
      count = self:GetPercent(count, quantity, true) .. '%';
    else
      count = count .. ' / ' .. quantity;
    end

    count = count .. bonus;

  elseif (showIndicator == true) then
    count = count .. 'x';
  end

  return count;
end

-- **************************************************************************
-- NAME : FarmBuddy:UpdateGUI()
-- DESC : Updates the GUI elements.
-- **************************************************************************
function FarmBuddy:UpdateGUI()

  local curFrame;
  local lastFrame = FarmBuddyFrame;
  local totalHeight = 0;
  local count = 0;
  local showIcon = false;
  local brokerStr = '';

  for _, itemStorage in pairs(ITEM_STORAGE) do

    local itemInfo = self:GetItemInfo(itemStorage.itemID);
    if itemInfo ~= nil then
      local frameName = FARM_BUDDY_ID .. 'Item' .. itemStorage.id;
      local itemCount = self:GetCount(itemInfo);
      local goalReached;
      local progressBarFrame;

      if (_G[frameName .. 'ProgressBar'] ~= nil) then
        progressBarFrame = _G[frameName .. 'ProgressBar'];
      end

      -- Handle notifications
      if(itemStorage.quantity > 0 and itemCount >= itemStorage.quantity) then
        self:QueueNotification(itemInfo.ItemID, itemInfo.Name, itemStorage.quantity);
        goalReached = true;
      else
        NOTIFICATION_QUEUE[itemInfo.ItemID] = nil;
        NOTIFICATION_TRIGGERED[itemInfo.ItemID] = false;
        goalReached = false;
      end

      -- Only add new frame if the frame does not already exists
      if (ITEM_FRAMES[frameName] == nil) then
        local r, g, b = GetItemQualityColor(itemInfo.Rarity);

        curFrame = CreateFrame('Frame', frameName, FarmBuddyFrame, 'FarmBuddyItemTemplate');
        curFrame.Title:SetText(itemInfo.Name);
        curFrame.Title:SetTextColor(r, g, b, 1);
        curFrame.Texture:SetTexture(itemInfo.IconFileDataID);

        progressBarFrame = CreateFrame('STATUSBAR', frameName .. 'ProgressBar', curFrame, 'FarmBuddyProgressBarTemplate');
        progressBarFrame:SetPoint('TOPLEFT', curFrame, (curFrame.Texture:GetWidth() + 7), -(curFrame.Title:GetHeight() + 9));

        ITEM_FRAMES[frameName] = curFrame;
      else
        curFrame = ITEM_FRAMES[frameName];
      end

      -- Set frame position
      if (count > 0) then
        curFrame:SetPoint('TOPLEFT', lastFrame, 0, -curFrame:GetHeight());
      else
        curFrame:SetPoint('TOPLEFT', FarmBuddyFrame, 0, 0);
      end

      if (self.db.profile.settings.showProgressBar == true) then
        progressBarFrame:Show();
        curFrame.Subline:Hide();
        self:SetupProgressBar(frameName, itemInfo, itemStorage);
      else
        progressBarFrame:Hide();
        curFrame.Subline:Show();
        self:SetSubline(curFrame, itemInfo, itemStorage, goalReached);
      end

      lastFrame = curFrame;
      totalHeight = (totalHeight + curFrame:GetHeight());
      count = count + 1;

      -- Build broker string
      brokerStr = brokerStr .. self:GetIconString(itemInfo.IconFileDataID, true);
      if (self.db.profile.settings.showDataBrokerItemName == true) then
        brokerStr = brokerStr .. itemInfo.Name .. ' ';
      end
      brokerStr = brokerStr .. self:GetCount(itemInfo, itemStorage.quantity, true) .. '   ';
    end
  end

  -- Show no tracked item text
  if (count == 0) then
    FarmBuddyFrame.EmptyText:SetText('- ' .. L['FARM_BUDDY_NO_TRACKED_ITEMS'] .. ' -');
    FarmBuddyFrame.EmptyText:Show();
    totalHeight = totalHeight + FarmBuddyFrame.EmptyText:GetHeight();
    showIcon = true;
  else
    FarmBuddyFrame.EmptyText:Hide();
  end

  -- Set parent main frame height
  totalHeight = totalHeight + 4; -- Add footer spacing
  if (totalHeight > 0) then
    FarmBuddyFrame:SetHeight(totalHeight);
  end

  self:UpdateDataBroker(brokerStr, showIcon);
end

-- **************************************************************************
-- NAME : FarmBuddy:SetSubline()
-- DESC : Sets the item subline based on the user settings.
-- **************************************************************************
function FarmBuddy:SetSubline(frame, itemInfo, itemStorage, goalReached)

  local point, _, _, _, yOfs = frame.Subline:GetPoint();

  frame.Subline:SetText(self:GetCount(itemInfo, itemStorage.quantity, true));

  if (goalReached == true and self.db.profile.settings.showGoalIndicator == true) then
    frame.Subline:SetPoint(point, 54, yOfs);
    frame.Complete:Show();
    frame.Subline:SetTextColor(0, 0.9, 0, 1.0);
  else
    frame.Subline:SetPoint(point, 40, yOfs);
    frame.Complete:Hide();
    frame.Subline:SetTextColor(1, 0.8, 0, 1.0);
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:SetupProgressBar()
-- DESC : Sets the values for the progress bar.
-- **************************************************************************
function FarmBuddy:SetupProgressBar(frameName, itemInfo, itemStorage)

  local frame = _G[frameName .. 'ProgressBar'];
  local itemCount = self:GetCount(itemInfo);
  local color;
  local goalCount;
  local noGoal = false;

  if (self.db.profile.settings.showQuantity == true and itemStorage.quantity > 0) then
    goalCount = itemStorage.quantity;
  else
    noGoal = true;
  end

  if (noGoal == true) then
    color = self.db.profile.settings.progressBarNoQuantityColor;
  elseif (itemCount >= goalCount) then
    color = self.db.profile.settings.progressBarGoalColor;
  else
    color = self.db.profile.settings.progressBarNoGoalColor;
  end

  if (noGoal == true) then
    frame:SetMinMaxValues(1, 10);
    frame:SetValue(10);
  else
    frame:SetMinMaxValues(0, goalCount);
    frame:SetValue(itemCount);
  end

  frame.text:SetText(self:GetCount(itemInfo, itemStorage.quantity, true));
  frame:SetStatusBarColor(color.r, color.g, color.b, color.a);
end

-- **************************************************************************
-- NAME : FarmBuddy:SetTitleDisplay()
-- DESC : Shows or hides the addon title bases on the showTitle setting.
-- **************************************************************************
function FarmBuddy:SetTitleDisplay()
  if (self.db.profile.settings.showTitle == true) then
    FarmBuddyFrame.Title:Show();
  else
    FarmBuddyFrame.Title:Hide();
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:SetButtonDisplay()
-- DESC : Shows or hides the addon buttons bases on the showButtons setting.
-- **************************************************************************
function FarmBuddy:SetButtonDisplay()
  if (self.db.profile.settings.showButtons == true) then
    FarmBuddyFrame.AddItemButton:Show();
  else
    FarmBuddyFrame.AddItemButton:Hide();
  end

end

-- **************************************************************************
-- NAME : FarmBuddy:SetFrameLockStatus()
-- DESC : Set or unset the frame is locked setting.
-- **************************************************************************
function FarmBuddy:SetFrameLockStatus()
  FarmBuddyFrame.FrameLock = self.db.profile.settings.frameLocked;
end

-- **************************************************************************
-- NAME : FarmBuddy:SetBackgroundTransparency()
-- DESC : Set the background transprency based on the user setting.
-- **************************************************************************
function FarmBuddy:SetBackgroundTransparency()
  FarmBuddyFrame:SetBackdropColor(0, 0, 0, self.db.profile.settings.backgroundTransparency);
end

-- **************************************************************************
-- NAME : FarmBuddy:RemoveItemFrame()
-- DESC : Removes the item frame with the given ID.
-- **************************************************************************
function FarmBuddy:RemoveItemFrame(id)

  local frameName = FARM_BUDDY_ID .. 'Item' .. id;
  if (ITEM_FRAMES[frameName] ~= nil) then
    ITEM_FRAMES[frameName]:Hide();
    ITEM_FRAMES[frameName] = nil;
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:AddItemClick()
-- DESC : Opens the FarmBuddy Settings GUI with focus on the items tab.
-- **************************************************************************
function FarmBuddy:AddItemClick(button)
  if (button == 'LeftButton') then
    self:OpenSettings('tab_items');
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:OpenSettings()
-- DESC : Opens the FarmBuddy settings GUI.
-- **************************************************************************
function FarmBuddy:OpenSettings(tab)

  -- Workarround for opening controls instead of AddOn options
  -- Call it two times to ensure the AddOn panel is opened
  InterfaceOptionsFrame_OpenToCategory(ADDON_NAME);
  InterfaceOptionsFrame_OpenToCategory(ADDON_NAME);

  if (tab ~= nil) then
    LibStub('AceConfigDialog-3.0'):SelectGroup(ADDON_NAME, tab)
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:GetColoredText()
-- DESC : Gets a colored string.
-- **************************************************************************
function FarmBuddy:GetColoredText(text, color)
  return '|c' .. color .. text .. '|r';
end

-- **************************************************************************
-- NAME : FarmBuddy:TableLength()
-- DESC : Gets the table item count.
-- **************************************************************************
function FarmBuddy:TableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

-- **************************************************************************
-- NAME : FarmBuddy:GetPercent()
-- DESC : Gets the percent value.
-- **************************************************************************
function FarmBuddy:GetPercent(p, g, capCheck)

  local percent = 0;

  if (capCheck == true and p > g) then
    percent = 100;
  else
    percent = tonumber(string.format("%." .. 0 .. 'f', ((p * 100) / g)));
  end

  if (capCheck == true) then
    if (percent < 0) then
      percent = 0;
    elseif (percent > 100) then
      percent = 100;
    end
  end

  return percent;
end

-- **************************************************************************
-- NAME : FarmBuddy:GetBonus()
-- DESC : Gets the bonus based on the given quantity value in percent or as item count.
-- **************************************************************************
function FarmBuddy:GetBonus(p, g, inPercent)

  local bonus = 0;
  local percent = self:GetPercent(p, g, false);

  if (percent > 100) then
    if (inPercent == true) then
      bonus = percent - 100;
    else
      bonus = p - g;
    end
  end

  return bonus;
end

-- **************************************************************************
-- NAME : FarmBuddy:PlayerRegenDisabled()
-- DESC : Fires when the player enters combat.
-- **************************************************************************
function FarmBuddy:PlayerRegenDisabled()

  if (self.db.profile.settings.hideFrameInCombat == true) then
    FarmBuddyFrame:Hide();
  end

  PLAYER_IN_COMBAT = true;
end

-- **************************************************************************
-- NAME : FarmBuddy:PlayerRegenDisabled()
-- DESC : Fires if the player leaves combat.
-- **************************************************************************
function FarmBuddy:PlayerRegenEnabled()
  FarmBuddyFrame:Show();
  PLAYER_IN_COMBAT = false;
end

-- **************************************************************************
-- NAME : FarmBuddy:SetShowFrame()
-- DESC : Toggles frame display.
-- **************************************************************************
function FarmBuddy:SetShowFrame()
  if (self.db.profile.settings.showFrame == true) then
    FarmBuddyFrame:Show();
  else
    FarmBuddyFrame:Hide();
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:ResetFramePosition()
-- DESC : Resets the main frame to the center of the screen.
-- **************************************************************************
function FarmBuddy:ResetFramePosition()
  FarmBuddyFrame:ClearAllPoints();
  FarmBuddyFrame:SetPoint('CENTER');
end

-- **************************************************************************
-- NAME : FarmBuddy:SetupDataBroker()
-- DESC : Shows or hides the data broker.
-- **************************************************************************
function FarmBuddy:UpdateDataBroker(text, showIcon)

  if (self.db.profile.settings.enableDataBrokerSupport == true) then

    local icon = '';
    if (showIcon == true) then
        icon = 'Interface\\AddOns\\FarmBuddy\\FarmBuddy.tga';
    end

    if (text == '') then
      text = 'Farm Buddy'
    end

    DATA_BROKER.text = text;
    DATA_BROKER.icon = icon;
  else
    DATA_BROKER.text = '';
    DATA_BROKER.icon = '';
  end
end

-- **************************************************************************
-- NAME : FarmBuddy_GetAddOnName()
-- DESC : Gets the Plugin AdOn name.
-- **************************************************************************
function FarmBuddy_GetAddOnName()
  return ADDON_NAME;
end

-- **************************************************************************
-- NAME : FarmBuddy_GetID()
-- DESC : Gets the Plugin ID.
-- **************************************************************************
function FarmBuddy_GetID()
  return FARM_BUDDY_ID;
end
