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
            if uniqueID ~= nil then
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

    local countBags = C_Item.GetItemCount(static.ItemID)
    local countTotal = countBags
    if self.db.profile.settings.includeBank then
        countTotal = C_Item.GetItemCount(static.ItemID, true)
    end

    return {
        ItemID = static.ItemID,
        Name = static.Name,
        Link = static.Link,
        IconFileDataID = static.IconFileDataID,
        Rarity = static.Rarity,
        CountBags = countBags,
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
end

---Called when the item info has received.
function FarmBuddy:ItemInfoReceived()
    local queue = {}
    for k, v in pairs(ITEM_QUEUE) do
        queue[k] = v
    end

    for k, v in pairs(queue) do
        local itemInfo = self:GetItemInfo(v.itemValue)
        if itemInfo ~= nil then
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
