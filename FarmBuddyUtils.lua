---@diagnostic disable: undefined-global
-- **************************************************************************
-- * FarmBuddyUtils.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID)

---Gets a colored string.
---@param text string
---@param color string Hex color string (e.g. 'FF00FF00').
---@return string
function FarmBuddy:GetColoredText(text, color)
    return '|c' .. color .. text .. '|r'
end

---Gets the table item count.
---@param T table
---@return number
function FarmBuddy:TableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

---Gets the percent value.
---@param p number Current value.
---@param g number Goal value.
---@param capCheck boolean Clamp the result between 0 and 100 when true.
---@return number
function FarmBuddy:GetPercent(p, g, capCheck)
    local percent = 0

    if (capCheck == true and p > g) then
        percent = 100
    else
        percent = math.floor((p * 100) / g)
    end

    if (capCheck == true) then
        if (percent < 0) then
            percent = 0
        elseif (percent > 100) then
            percent = 100
        end
    end

    return percent
end

---Gets the bonus based on the given quantity value in percent or as item count.
---@param p number Current value.
---@param g number Goal value.
---@param inPercent boolean Return the bonus as a percentage when true, otherwise as an item count.
---@return number
function FarmBuddy:GetBonus(p, g, inPercent)
    local bonus = 0
    local percent = self:GetPercent(p, g, false)

    if (percent > 100) then
        if (inPercent == true) then
            bonus = percent - 100
        else
            bonus = p - g
        end
    end

    return bonus
end

---Sort items by the given key.
---@param a table
---@param b table
---@param key string Table key to sort by.
---@return boolean
function FarmBuddy:SortItemsByKey(a, b, key)
    if (self.db.profile.settings.sortOrder == 'asc') then
        return a[key] < b[key]
    else
        return a[key] > b[key]
    end
end

---Gets the item count.
---@param itemInfo table
---@param quantity? number Goal quantity.
---@param showIndicator? boolean Append an 'x' indicator when no goal is set.
---@return number|string count Numeric count, or a formatted string when a goal/indicator is shown.
function FarmBuddy:GetCount(itemInfo, quantity, showIndicator)
    local includeBank = self.db.profile.settings.includeBank
    local count = itemInfo.CountBags
    local displayStyle = self.db.profile.settings.progressStyle

    if includeBank == 1 or includeBank == true then
        count = itemInfo.CountTotal
    end

    if (self.db.profile.settings.showQuantity == true and quantity ~= nil and quantity > 0) then
        -- Handle bonus display
        local bonus = ''
        if (self.db.profile.settings.showGoalBonus == true) then
            local bonusInPercent = true
            local bonusUnit = '%'
            if (self.db.profile.settings.goalBonusDisplay == 'count') then
                bonusInPercent = false
                bonusUnit = ''
            end

            local bonusValue = self:GetBonus(count, quantity, bonusInPercent)
            if (bonusValue > 0) then
                bonus = ' ' .. self:GetColoredText('+' .. bonusValue .. bonusUnit, FARM_BUDDY_COLOR_GREEN)
            end
        end

        if (displayStyle == 'CountPercentage') then
            count = count .. ' / ' .. quantity .. ' (' .. self:GetPercent(count, quantity, true) .. '%)'
        elseif (displayStyle == 'Percentage') then
            count = self:GetPercent(count, quantity, true) .. '%'
        else
            count = count .. ' / ' .. quantity
        end

        count = count .. bonus
    elseif (showIndicator == true) then
        count = count .. 'x'
    end

    return count
end
