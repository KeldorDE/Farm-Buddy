-- **************************************************************************
-- * FarmBuddyDataBroker.lua
-- *
-- * By: Keldor
-- **************************************************************************

---@class FarmBuddy : AceConsole, AceEvent, AceHook, AceTimer
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID)
local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true)
local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
local DATA_BROKER
local DATA_BROKER_ITEMS = {}


---Inits the data broker items.
function FarmBuddy:InitDataBroker()

    DATA_BROKER = ldb:NewDataObject('FarmBuddyBroker', {
        label = FARM_BUDDY_ADDON_NAME,
        type = 'data source',
        text = '',
        icon = C_AddOns.GetAddOnMetadata(FARM_BUDDY_FOLDER, 'IconTexture'),
    })

    DATA_BROKER.OnClick = function(_, button)
        if button == 'LeftButton' then
            self:ToggleShowFrame()
        elseif button == 'RightButton' then
            self:OpenSettings('tab_data_broker')
        end
    end

    DATA_BROKER.OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end

        tooltip:AddLine(self:GetColoredText(FARM_BUDDY_ADDON_NAME, FARM_BUDDY_COLOR_WHITE))
        tooltip:AddLine(self:GetColoredText(L['FARM_BUDDY_BROKER_TOOLTIP_LINE_1'], FARM_BUDDY_COLOR_GREEN))
        tooltip:AddLine(self:GetColoredText(L['FARM_BUDDY_BROKER_TOOLTIP_LINE_2'], FARM_BUDDY_COLOR_GREEN))
    end
end

---Resets the data broker item table.
function FarmBuddy:ClearDataBrokerData()
    DATA_BROKER_ITEMS = {}
end

---Adds an item to the data broker list.
---@param itemInfo table
---@param itemStorage table
function FarmBuddy:AddItemToDataBroker(itemInfo, itemStorage)
    tinsert(DATA_BROKER_ITEMS, {
        itemInfo = itemInfo,
        itemStorage = itemStorage,
    })
end

---Updates the data broker text and icon.
function FarmBuddy:UpdateDataBroker()
    local parts = {}
    local count = 0

    for _, v in ipairs(DATA_BROKER_ITEMS) do
        if count >= self.db.profile.settings.dataBrokerNumItems then
            break
        end

        local segment = ''
        local itemName

        if self.db.profile.settings.showDataBrokerItemIcon then
            segment = self:GetIconString(v.itemInfo.IconFileDataID, false)
        end

        if self.db.profile.settings.showDataBrokerItemName then
            if self.db.profile.settings.showDataBrokerItemIcon then
                segment = segment .. ' '
            end

            if self.db.profile.settings.showDataBrokerItemNameColor then
                itemName = self:GetNameFromItemLink(v.itemInfo.Link)
            else
                itemName = v.itemInfo.Name
            end

            segment = segment .. itemName
        end

        segment = segment .. ' ' .. self:GetCount(v.itemInfo, v.itemStorage.quantity, true)
        tinsert(parts, segment)

        count = count + 1
    end

    DATA_BROKER.text = #parts > 0 and table.concat(parts, '  ') or FARM_BUDDY_ADDON_NAME
end
