-- **************************************************************************
-- * FarmBuddyItem.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FARM_BUDDY_ID = FarmBuddy_GetID();
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID);
local ITEM_QUEUE = {};

-- **************************************************************************
-- NAME : FarmBuddy:GetItemInfo()
-- DESC : Gets information for the given item name.
-- **************************************************************************
function FarmBuddy:GetItemInfo(item, uniqueID)

  if item then

    local itemName, itemLink, itemRarity = GetItemInfo(item);

    if itemLink == nil then

      -- Track item to fetch info later
      if (uniqueID ~= nil) then
        self:AddItemToQueue(uniqueID, item);
      end

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

function FarmBuddy:AddItemToQueue(uniqueID, item)
  tinsert(ITEM_QUEUE, {
    uniqueID = uniqueID,
    itemValue = item,
  });
end

function FarmBuddy:ItemInfoRecived()

  for k, v in pairs(ITEM_QUEUE) do
    local itemInfo = self:GetItemInfo(v.itemValue);
    if (itemInfo ~= nil) then
      self:SetRecivedItemInfo(v.uniqueID, itemInfo);
      ITEM_QUEUE[k] = nil;
    end
  end
end