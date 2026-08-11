---@diagnostic disable: undefined-global
-- **************************************************************************
-- * FarmBuddyItem.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID)
local ITEM_QUEUE = {}
local ITEM_INFO_CACHE = {}

---Gets information for the given item name.
---@param item number|string Item ID, name or item link.
---@param uniqueID? string Unique storage ID used to queue the item if not yet cached.
---@return table? itemInfo Item information, or nil if the item data is not available yet.
function FarmBuddy:GetItemInfo(item, uniqueID)
    if not item then
        return nil
    end

    local static = ITEM_INFO_CACHE[item]
    if not static then
        local itemName, itemLink, itemRarity = C_Item.GetItemInfo(item)
        if not itemLink then
            if uniqueID then
                self:AddItemToQueue(uniqueID, item)
            end
            return nil
        end

        local itemID, _, _, _, itemIcon = C_Item.GetItemInfoInstant(item)
        local r, g, b = C_Item.GetItemQualityColor(itemRarity)
        static = {
            ItemID = itemID,
            Name = itemName,
            Link = itemLink,
            Rarity = {r = r, g = g, b = b},
            IconFileDataID = itemIcon,
        }
        ITEM_INFO_CACHE[item] = static
    end

    local countWarbandBank = 0
    local countBags = C_Item.GetItemCount(static.ItemID)
    local countBank = 0

    if self.db.profile.settings.includeBank then
        countBank = C_Item.GetItemCount(static.ItemID, true)
        countBank = (countBank - countBags)
    end

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and self.db.profile.settings.includeWarbandBank then
        countWarbandBank = C_Item.GetItemCount(static.ItemID, false, false, false, true)
        countWarbandBank = (countWarbandBank - countBags)
    end

    local countTotal = (countBags + countBank + countWarbandBank)

    return {
        ItemID = static.ItemID,
        Name = static.Name,
        Link = static.Link,
        IconFileDataID = static.IconFileDataID,
        Rarity = static.Rarity,
        CountBags = countBags,
        CountBank = countBank,
        CountWarbandBank = countWarbandBank,
        CountTotal = countTotal,
    }
end

---Adds the item to the receive queue.
---@param uniqueID string Unique storage ID of the item.
---@param item number|string Item ID, name or item link.
function FarmBuddy:AddItemToQueue(uniqueID, item)
    for _, v in pairs(ITEM_QUEUE) do
        if v.uniqueID == uniqueID then return end
    end

    tinsert(ITEM_QUEUE, {
        uniqueID = uniqueID,
        itemValue = item
    })

    -- The WoW cache only returns data for items the client has already seen, so
    -- polling GetItemInfo never resolves unknown items on its own. Actively
    -- request the data from the server via the item mixin and re-check the queue
    -- once it has loaded.
    local itemID = self:GetInputItemID(item)
    if itemID then
        local mixin = Item:CreateFromItemID(itemID)
        if not mixin:IsItemEmpty() then
            mixin:ContinueOnItemLoad(function()
                self:ItemInfoReceived()
            end)
        end
    end
end

---Returns the numeric item ID for the given input when it is a bare item ID or
---an item link. Item names return nil because they cannot be requested by ID.
---@param item number|string Item ID, name or item link.
---@return number? itemID
function FarmBuddy:GetInputItemID(item)
    if type(item) == 'number' then
        return item
    end

    if type(item) == 'string' then
        local linkID = item:match('item:(%d+)')
        if linkID then
            return tonumber(linkID)
        end

        return tonumber(item)
    end

    return nil
end

---Called when the item info has received.
function FarmBuddy:ItemInfoReceived()
    local queue = {}
    for k, v in pairs(ITEM_QUEUE) do
        queue[k] = v
    end

    for k, v in pairs(queue) do
        local itemInfo = self:GetItemInfo(v.itemValue)
        if itemInfo then
            ITEM_QUEUE[k] = nil
            self:SetReceivedItemInfo(v.uniqueID, itemInfo)
        end
    end
end

---Gets an icon string.
---@param icon number|string Icon file data ID or texture path.
---@param space? boolean Append a trailing space when true.
---@return string
function FarmBuddy:GetIconString(icon, space)
    return string.format('|T%s:%d|t%s', icon, 16, space and ' ' or '')
end

---Gets the item link without the brackets.
---@param itemLink string
---@return string
function FarmBuddy:GetNameFromItemLink(itemLink)
    return (itemLink:gsub("%[(.-)%]", "%1"))
end
