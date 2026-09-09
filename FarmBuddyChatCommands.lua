---@diagnostic disable: undefined-global
-- **************************************************************************
-- * FarmBuddyChatCommands.lua
-- *
-- * By: Keldor
-- **************************************************************************

---@class FarmBuddy : AceConsole, AceEvent, AceHook, AceTimer
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID)
local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true)

-- Maps command names to their entry for quick lookup, derived from the ordered FARM_BUDDY_CHAT_COMMANDS list.
local CHAT_COMMANDS_BY_NAME = {}
for _, entry in ipairs(FARM_BUDDY_CHAT_COMMANDS) do
    CHAT_COMMANDS_BY_NAME[entry.Command] = entry
end

---Creates the chat commands.
function FarmBuddy:InitChatCommands()
    self:RegisterChatCommand(FARM_BUDDY_CHAT_COMMAND, 'ChatCommand')
end

---Handles AddOn commands.
---@param input string The raw chat command input.
function FarmBuddy:ChatCommand(input)
    local cmd, value, arg1 = self:GetArgs(input, 3)
    local entry = CHAT_COMMANDS_BY_NAME[cmd] or CHAT_COMMANDS_BY_NAME.help
    self[entry.Handler](self, value, arg1)
end

---Handles the track chat command.
---@param item string The item link or item ID.
---@param quantity string|number The quantity to set for the item.
function FarmBuddy:CmdTrack(item, quantity)
    if item then
        -- Convert item link to name
        local origItem = item
        item = self:ItemLinkToID(item)

        -- Resolve the item so already tracked items can be detected before adding
        local itemInfo = self:GetItemInfo(tonumber(item) or item)
        if itemInfo then
            item = itemInfo.ItemID
        end

        -- Add the item and abort if it is already tracked
        if not self:AddConfigItem(nil, item, self:GetNameFromItemLink(origItem)) then
            local text = L['FARM_BUDDY_ITEM_NOT_SET_MSG']:gsub('!itemName!', origItem)
            self:Print(text)
            return
        end

        if quantity then
            local status = self:ValidateNumber(nil, tostring(quantity))
            if status then
                local uniqueID = self:GetItemUniqueIDByItemID(item)
                if not uniqueID then
                    uniqueID = self:GetItemIDByName(self:GetNameFromItemLink(origItem))
                end
                if uniqueID then
                    self:SetItemProp(uniqueID, 'quantity', tonumber(quantity) or 0, true)
                end
            end
        end

        self:InitItems()
        self:UpdateGUI()

        local text = L['FARM_BUDDY_ITEM_SET_MSG']:gsub('!itemName!', origItem)
        self:Print(text)
    else
        self:Print(L['FARM_BUDDY_TRACK_ITEM_PARAM_MISSING'])
    end
end

---Handles the quantity chat command.
---@param item string The item link or item ID.
---@param quantity string|number The quantity to set for the item.
function FarmBuddy:CmdQuantity(item, quantity)
    if item then
        local status = self:ValidateNumber(nil, tostring(quantity))
        if status then
            -- Convert item link to ID
            local itemID = self:ItemLinkToID(item)
            if itemID then
                local uniqueID = self:GetItemUniqueIDByItemID(itemID)
                if uniqueID then
                    self:SetItemProp(uniqueID, 'quantity', tonumber(quantity) or 0, true)
                    self:Print(L['FARM_BUDDY_GOAL_SET'])
                else
                    self:Print(L['FARM_BUDDY_ITEM_NOT_ON_LIST'])
                end
            else
                self:Print(L['FARM_BUDDY_ITEM_NOT_ON_LIST'])
            end
        else
            self:Print(L['FARM_BUDDY_COMMAND_GOAL_PARAM_MISSING'])
        end
    end
end

---Handles the toggle chat command.
function FarmBuddy:CmdToggle()
    self:ToggleShowFrame()
end

---Handles the settings chat command.
function FarmBuddy:CmdSettings()
    self:OpenSettings('tab_general')
end

function FarmBuddy:CmdTestNotification()
    FarmBuddy:TestNotification()
end

---Handles the reset chat command.
---@param resetType string The reset type. Can be 'all' or 'items'.
function FarmBuddy:CmdReset(resetType)
    if resetType == 'all' then
        self:ResetConfig()
    else
        self:ResetItems(false)
    end

    self:InitItems()
    self:UpdateGUI()

    self:Print(L['FARM_BUDDY_CONFIG_RESET_MSG'])
end

---Handles the version chat command.
function FarmBuddy:CmdVersion()
    self:Print(C_AddOns.GetAddOnMetadata(FARM_BUDDY_FOLDER, 'Version'))
end

---Handles the help chat command.
function FarmBuddy:CmdGetHelp()
    self:Print(L['FARM_BUDDY_COMMAND_LIST'] .. '\n')
    self:GetChatCommandsHelp(true)
end

---Returns the help text of the chat commands.
---@param printOut boolean If true, each line is printed to the chat frame.
---@return string helpText The help text of the chat commands.
function FarmBuddy:GetChatCommandsHelp(printOut)
    local helpStr = ''

    for _, info in ipairs(FARM_BUDDY_CHAT_COMMANDS) do

        if not printOut then
            helpStr = helpStr .. '   '
        end

        helpStr = helpStr .. self:GetColoredText('/' .. FARM_BUDDY_CHAT_COMMAND, FARM_BUDDY_COLOR_GREEN)
            .. ' ' .. self:GetColoredText(info.Command, FARM_BUDDY_COLOR_BLUE)
        if info.Args ~= '' then
            helpStr = helpStr .. ' ' .. self:GetColoredText(info.Args, FARM_BUDDY_COLOR_YELLOW)
        end

        helpStr = helpStr .. ' - ' .. info.Description

        if printOut then
            DEFAULT_CHAT_FRAME:AddMessage(helpStr)
            helpStr = ''
        else
            helpStr = helpStr .. '\n'
        end
    end

    return helpStr
end
