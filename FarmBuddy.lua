-- **************************************************************************
-- * FarmBuddy.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FARM_BUDDY_ID = 'FarmBuddyStandalone';
local ADDON_NAME = 'Farm Buddy';
local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true);
local FarmBuddy = LibStub('AceAddon-3.0'):NewAddon(FARM_BUDDY_ID, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0');
local NOTIFICATION_COUNT = 0;
local NOTIFICATION_QUEUE = {};
local NOTIFICATION_TRIGGERED = {};
local ITEM_STORAGE = {};
local ITEM_FRAMES = {};
local DEFAULTS = {
  profile = {
    items = {},
    settings = {
      showTitle = true,
      showQuantity = true,
      includeBank = false,
      goalNotification = true,
      notificationDisplayDuration = 5,
      notificationGlow = true,
      notificationShine = true,
      playNotificationSound = true,
      notificationSound = SOUNDKIT.UI_WORLDQUEST_COMPLETE,
    }
  }
}

-- **************************************************************************
-- NAME : FarmBuddy:OnInitialize()
-- DESC : Is called by AceAddon when the addon is first loaded.
-- **************************************************************************
function FarmBuddy:OnInitialize()

  self.db = LibStub("AceDB-3.0"):New(FARM_BUDDY_ID .. 'DB', DEFAULTS);
  self:RegisterEvent('BAG_UPDATE', 'BagUpdate');
  self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'BagUpdate');
  self:InitSettings();
  self:InitItems();
  self:SetTitleDisplay();
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
      local itemInfo = self:GetItemInfo(itemStorage.name);
      if itemInfo ~= nil then
        ITEM_STORAGE[index].count = FarmBuddy:GetCount(itemInfo);
      else
        ITEM_STORAGE[index].count = 0;
      end
    end
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:OnEnable()
-- DESC : Is called when the Plugin gets enabled.
-- **************************************************************************
function FarmBuddy:OnEnable()
  --self:SecureHook('ContainerFrameItemButton_OnModifiedClick');
  self:ScheduleRepeatingTimer('NotificationTask', 1);
end

-- **************************************************************************
-- NAME : FarmBuddy:OnDisable()
-- DESC : Is called when the Plugin gets disabled.
-- **************************************************************************
function FarmBuddy:OnDisable()
  self:CancelAllTimers();
end

-- **************************************************************************
-- NAME : TitanFarmBuddy:BagUpdate()
-- DESC : Parse events registered to plugin and act on them.
-- **************************************************************************
function FarmBuddy:BagUpdate()
  for index, itemStorage in pairs(ITEM_STORAGE) do
    local itemInfo = self:GetItemInfo(itemStorage.name);
    if itemInfo ~= nil then
      local count = FarmBuddy:GetCount(itemInfo);
      if(itemStorage.quantity > 0 and count >= itemStorage.quantity) then
        FarmBuddy:QueueNotification(itemStorage.name, itemStorage.name, itemStorage.quantity);
      else
        NOTIFICATION_TRIGGERED[itemStorage.name] = false;
      end
    end
  end

  self:UpdateGUI();
end

-- **************************************************************************
-- NAME : FarmBuddy:QueueNotification()
-- DESC : Queues a notification.
-- **************************************************************************
function FarmBuddy:QueueNotification(index, item, quantity)
  NOTIFICATION_COUNT = NOTIFICATION_COUNT + 1;
  NOTIFICATION_QUEUE[NOTIFICATION_COUNT] = {
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
    for index, notification in pairs(NOTIFICATION_QUEUE) do
      FarmBuddy:ShowNotification(notification.Index, notification.Item, notification.Quantity, false);
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

  local notificationEnabled = self.db.profile.settings.goalNotification;
  if (notificationEnabled == true and NOTIFICATION_TRIGGERED[index] == false) or demo == true then

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
-- NAME : FarmBuddy:GetItemInfo()
-- DESC : Gets information for the given item name.
-- **************************************************************************
function FarmBuddy:GetItemInfo(name)

  if name then

    local itemName, itemLink, itemRarity = GetItemInfo(name);

    if itemLink == nil then
      return nil;
    else

      local countBags = GetItemCount(itemLink);
      local countTotal = GetItemCount(itemLink, true);
      local _, itemID = strsplit(':', itemLink);
      local info = {
        ItemID = itemID,
        Name = itemName,
        Link = itemLink,
        Rarity = itemRarity,
        IconFileDataID = GetItemIcon(itemLink),
        CountBags = countBags,
        CountTotal = countTotal,
        CountBank = (countTotal - countBags),
      };

      return info;
    end
  end

  return nil;
end

-- **************************************************************************
-- NAME : FarmBuddy:GetCount()
-- DESC : Gets the item count.
-- **************************************************************************
function FarmBuddy:GetCount(itemInfo, quantity)

  local includeBank = FarmBuddy.db.profile.settings.includeBank;
  local count = itemInfo.CountBags;

  if includeBank == 1 or includeBank == true then
    count = itemInfo.CountTotal;
  end

  if(self.db.profile.settings.showQuantity == true and quantity ~= nil and quantity > 0) then
    count = count .. ' / ' .. quantity;
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

  for index, itemStorage in pairs(ITEM_STORAGE) do
    local itemInfo = self:GetItemInfo(itemStorage.name);
    if itemInfo ~= nil then
      local frameName = FARM_BUDDY_ID .. 'Item' .. itemStorage.id;

      -- Only add new frame if the frame does not already exists
      if (ITEM_FRAMES[frameName] == nil) then
        local r, g, b = GetItemQualityColor(itemInfo.Rarity);

        curFrame = CreateFrame('Frame', frameName, FarmBuddyFrame, 'FarmBuddyItemTemplate');
        curFrame.Title:SetText(itemInfo.Name);
        curFrame.Title:SetTextColor(r, g, b, 1);
        curFrame.Texture:SetTexture(itemInfo.IconFileDataID);
        curFrame.Subline:SetText(FarmBuddy:GetCount(itemInfo, itemStorage.quantity));

        -- Set frame position
        if (index > 1) then
          curFrame:SetPoint('TOPLEFT', lastFrame, 0, -curFrame:GetHeight());
        else
          curFrame:SetPoint('TOPLEFT', FarmBuddyFrame, 0, 0);
        end

        ITEM_FRAMES[frameName] = curFrame;
      else
        curFrame = ITEM_FRAMES[frameName];
        curFrame.Subline:SetText(FarmBuddy:GetCount(itemInfo, itemStorage.quantity));
      end

      lastFrame = curFrame;
      totalHeight = (totalHeight + curFrame:GetHeight());
      count = count + 1;
    end
  end

  -- Set parent main frame height
  totalHeight = totalHeight + 4; -- Add footer spacing
  if (totalHeight > 0) then
    FarmBuddyFrame:SetHeight(totalHeight);
  end

  if (count == 0) then
    FarmBuddyFrame.EmptyText:SetText('- ' .. L['FARM_BUDDY_NO_TRACKED_ITEMS'] .. ' -');
    FarmBuddyFrame.EmptyText:Show();
  else
    FarmBuddyFrame.EmptyText:Hide();
  end
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
