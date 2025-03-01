-- **************************************************************************
-- * FarmBuddy.lua
-- *
-- * By: Keldor
-- **************************************************************************

local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true);
local FarmBuddy = LibStub('AceAddon-3.0'):NewAddon(FARM_BUDDY_ID, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0');
local NOTIFICATION_QUEUE = {};
local NOTIFICATION_TRIGGERED = {};
local ITEM_STORAGE = {};
local ITEM_FRAMES = {};
local PLAYER_IN_COMBAT = false;
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
      notificationSound = SOUNDKIT.ALARM_CLOCK_WARNING_3,
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
      dataBrokerNumItems = 2,
      frameScale = 1.0,
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
  self:RegisterEvent('PET_BATTLE_OPENING_START', 'PlayerRegenDisabled');
  self:RegisterEvent('PET_BATTLE_CLOSE', 'PlayerRegenEnabled');

  self.db.RegisterCallback(self, 'OnProfileChanged', 'OnProfileChanged');
  self.db.RegisterCallback(self, 'OnProfileCopied', 'OnProfileChanged');
  self.db.RegisterCallback(self, 'OnProfileReset', 'OnProfileChanged');
  self.db.RegisterCallback(self, 'OnProfileShutdown', 'OnProfileShutdown');

  Mixin(FarmBuddyFrame, BackdropTemplateMixin)

  -- Init addon stuff
  self:InitSettings();
  self:InitItems();
  self:InitDataBroker();
  self:SetTitleDisplay();
  self:SetButtonDisplay();
  self:SetFrameLockStatus();
  self:SetBackgroundTransparency();
  self:InitChatCommands();
  self:SetShowFrame();
  self:SetScale();

  -- Set add item click event
  FarmBuddyFrame.AddItemButton:SetScript('OnClick', function(handle, button) self:AddItemClick(button) end);
end

-- **************************************************************************
-- NAME : FarmBuddy:OnEnable()
-- DESC : Is called when the Plugin gets enabled.
-- **************************************************************************
function FarmBuddy:OnEnable()
  self:SecureHook('HandleModifiedItemClick', 'ModifiedClick');
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
  if (self.db.profile.settings.showFrame == true) then
    FarmBuddyFrame:Show();
  end
  PLAYER_IN_COMBAT = false;
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
-- NAME : FarmBuddy:ModifiedClick()
-- DESC : Is called when an item is clicked with modifier key.
-- **************************************************************************
function FarmBuddy:ModifiedClick(itemLink, itemLocation)

  -- item location can be nil for bags/bank/mail and is not nil for inventory slots, make an explicit check
  if itemLocation and itemLocation.IsBagAndSlot and (not itemLocation:IsBagAndSlot()) then
    return;
  end

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

  if GetMouseButtonClicked() == db.fastTrackingMouseButton and not CursorHasItem() and conditions == true then

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
-- NAME : FarmBuddy:UpdateGUI()
-- DESC : Updates the GUI elements.
-- **************************************************************************
function FarmBuddy:UpdateGUI()

  local curFrame;
  local lastFrame = FarmBuddyFrame;
  local totalHeight = 0;
  local count = 0;
  local showIcon = false;

  self:ClearDataBrokerData();

  for _, itemStorage in pairs(ITEM_STORAGE) do

    local itemInfo = self:GetItemInfo(itemStorage.itemID);
    local hidden = itemStorage.hidden and (itemStorage.hidden == 1) or false
    if itemInfo then
      local frameName = FARM_BUDDY_ID .. 'Item' .. itemStorage.id;
      local itemCount = self:GetCount(itemInfo);
      local goalReached;
      local progressBarFrame;

      if (_G[frameName .. 'ProgressBar'] ~= nil) then
        progressBarFrame = _G[frameName .. 'ProgressBar'];
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

      if hidden then
        if curFrame then curFrame:Hide(); end
      else
        -- Handle notifications
        if(itemStorage.quantity > 0 and itemCount >= itemStorage.quantity) then
          self:QueueNotification(itemInfo.ItemID, itemInfo.Name, itemStorage.quantity);
          goalReached = true;
        else
          NOTIFICATION_QUEUE[itemInfo.ItemID] = nil;
          NOTIFICATION_TRIGGERED[itemInfo.ItemID] = false;
          goalReached = false;
        end
        curFrame:Show();
        curFrame:ClearAllPoints();
        -- Set frame position
        if (count > 0) then
          curFrame:SetPoint('TOPLEFT', lastFrame, 0, -(curFrame:GetHeight() + 3));
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

        self:AddItemToDataBroker(itemInfo, itemStorage);
      end
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

  self:UpdateDataBroker(showIcon);
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
-- NAME : FarmBuddy:SetScale()
-- DESC : Removes the item frame with the given ID.
-- **************************************************************************
function FarmBuddy:SetScale()
  if(self.db.profile.settings.frameScale) then
    FarmBuddyFrame:SetScale(self.db.profile.settings.frameScale);
  end
end
