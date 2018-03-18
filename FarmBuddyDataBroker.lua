-- **************************************************************************
-- * FarmBuddyDataBroker.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FARM_BUDDY_ID = FarmBuddy_GetID();
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID);
local ldb = LibStub:GetLibrary('LibDataBroker-1.1');
local DATA_BROKER;
local DATA_BROKER_ITEMS;
local DATA_BROKER_ICON = 'Interface\\AddOns\\FarmBuddy\\FarmBuddy.tga';


-- **************************************************************************
-- NAME : FarmBuddy:InitDataBroker()
-- DESC : Inits the data broker items.
-- **************************************************************************
function FarmBuddy:InitDataBroker()

  DATA_BROKER = ldb:NewDataObject('FarmBuddyBroker', {
    type = 'data source',
    icon = DATA_BROKER_ICON,
    text = '',
  });
end

-- **************************************************************************
-- NAME : FarmBuddy:ClearDataBrokerData()
-- DESC : Resets the data broker item table.
-- **************************************************************************
function FarmBuddy:ClearDataBrokerData()
  DATA_BROKER_ITEMS = {};
end

-- **************************************************************************
-- NAME : FarmBuddy:AddItemToDataBroker()
-- DESC : Adds an item to the data broker list.
-- **************************************************************************
function FarmBuddy:AddItemToDataBroker(itemInfo, itemStorage)
  if (self.db.profile.settings.enableDataBrokerSupport == true) then
    tinsert(DATA_BROKER_ITEMS, {
      itemInfo = itemInfo,
      itemStorage = itemStorage,
    });
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:UpdateDataBroker()
-- DESC : Updates the data broker text and icon.
-- **************************************************************************
function FarmBuddy:UpdateDataBroker(showIcon)

  if (self.db.profile.settings.enableDataBrokerSupport == true) then
    local dataList = {};

    for _, v in pairs(DATA_BROKER_ITEMS) do

      tinsert(dataList, self:GetIconString(v.itemInfo.IconFileDataID, false));

      if (self.db.profile.settings.showDataBrokerItemName == true) then
        tinsert(dataList, v.itemInfo.Name);
      end

      tinsert(dataList, self:GetCount(v.itemInfo, v.itemStorage.quantity, true) .. '  ');
    end

    local icon = '';
    local text = table.concat(dataList, ' ');

    if (showIcon == true) then
      icon = DATA_BROKER_ICON;
    end

    if (text == '') then
      text = 'Farm Buddy'
    end

    DATA_BROKER.text = text;
    DATA_BROKER.icon = icon;
  end
end