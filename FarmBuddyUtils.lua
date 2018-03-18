-- **************************************************************************
-- * FarmBuddyUtils.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FARM_BUDDY_ID = FarmBuddy_GetID();
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID);


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