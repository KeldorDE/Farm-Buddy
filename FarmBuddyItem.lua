-- **************************************************************************
-- * FarmBuddyItem.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID)
local ITEM_QUEUE = {}

-- **************************************************************************
-- NAME : FarmBuddy:GetItemInfo()
-- DESC : Gets information for the given item name.
-- **************************************************************************
function FarmBuddy:GetItemInfo(item, uniqueID)
    if item then
        local itemName, itemLink, itemRarity = GetItemInfo(item)

        if itemLink == nil then
            if (uniqueID ~= nil) then
                self:AddItemToQueue(uniqueID, item)
            end
            return nil
        else
            local itemID = GetItemInfoInstant(item)
            local countBags = GetItemCount(itemLink)
            local countTotal = GetItemCount(itemLink, true)

            local info = {
                ItemID = itemID,
                Name = itemName,
                Link = itemLink,
                Rarity = itemRarity,
                IconFileDataID = GetItemIcon(itemLink),
                CountBags = countBags,
                CountTotal = countTotal,
                CountBank = (countTotal - countBags)
            }

            return info
        end
    end

    return nil
end

-- **************************************************************************
-- NAME : FarmBuddy:AddItemToQueue()
-- DESC : Adds the item to the receive queue.
-- **************************************************************************
function FarmBuddy:AddItemToQueue(uniqueID, item)
    for _, v in pairs(ITEM_QUEUE) do
        if v.uniqueID == uniqueID then return end
    end

    tinsert(ITEM_QUEUE, {
        uniqueID = uniqueID,
        itemValue = item
    })
end

-- **************************************************************************
-- NAME : FarmBuddy:ItemInfoReceived()
-- DESC : Called when the item info has received.
-- **************************************************************************
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

-- **************************************************************************
-- NAME : FarmBuddy:GetIconString()
-- DESC : Gets an icon string.
-- **************************************************************************
function FarmBuddy:GetIconString(icon, space)
    local str = '|T' .. icon .. ':16|t'
    if space == true then
        str = str .. ' '
    end
    return str
end

-- **************************************************************************
-- NAME : FarmBuddy:GetNameFromItemLink()
-- DESC : Gets the item link without the brackets.
-- **************************************************************************
function FarmBuddy:GetNameFromItemLink(itemLink)
    local itemLinkNoBrackets = itemLink:gsub("%[(.-)%]", "%1")
    return itemLinkNoBrackets
end
