-- **************************************************************************
-- * FarmBuddyChatCommands.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FARM_BUDDY_ID = FarmBuddy_GetID();
local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true);
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID);
local ADDON_NAME = FarmBuddy_GetAddOnName();
local CHAT_COMMAND = 'fbs';
local CHAT_COMMANDS = {
  track = {
    Args = '<' .. L['FARM_BUDDY_COMMAND_TRACK_ARGS'] .. '> (<' .. L['FARM_BUDDY_COMMAND_GOAL_ARGS'] .. '>)',
    Description = L['FARM_BUDDY_COMMAND_TRACK_DESC']
  },
  quantity = {
    Args = '<' .. L['FARM_BUDDY_COMMAND_TRACK_ARGS'] .. '> <' .. L['FARM_BUDDY_COMMAND_GOAL_ARGS'] .. '>',
    Description = L['FARM_BUDDY_COMMAND_GOAL_DESC']
  },
  reset = {
    Args = '<' .. L['FARM_BUDDY_COMMAND_RESET_ARGS'] .. '>',
    Description = L['FARM_BUDDY_COMMAND_RESET_DESC']
  },
  settings = {
    Args = '',
    Description = L['FARM_BUDDY_COMMAND_SETTINGS_DESC']
  },
  version = {
    Args = '',
    Description = L['FARM_BUDDY_COMMAND_VERSION_DESC']
  },
  help = {
    Args = '',
    Description = L['FARM_BUDDY_COMMAND_HELP_DESC']
  }
};

-- **************************************************************************
-- NAME : FarmBuddy:InitChatCommands()
-- DESC : Creates the chat commands.
-- **************************************************************************
function FarmBuddy:InitChatCommands()
  self:RegisterChatCommand(CHAT_COMMAND, 'ChatCommand');
end

-- **************************************************************************
-- NAME : FarmBuddy:GetChatCommandsHelp()
-- DESC : Returns the help text of the chat commands.
-- **************************************************************************
function FarmBuddy:GetChatCommandsHelp(printOut)

  local helpStr = '';

  for command, info in pairs(CHAT_COMMANDS) do
    helpStr = helpStr .. self:GetColoredText('/' .. CHAT_COMMAND, 'FF00FF00') .. ' ' .. self:GetColoredText(command, 'FFFF0000');
    if info.Args ~= '' then
      helpStr = helpStr .. ' ' .. self:GetColoredText(info.Args, 'FF00FF00');
    end
    helpStr = helpStr .. ' - ' .. info.Description;
    if printOut then
      print(helpStr);
      helpStr = '';
    else
      helpStr = helpStr .. '\n';
    end
  end

  return helpStr;
end

-- **************************************************************************
-- NAME : FarmBuddy:ChatCommand()
-- DESC : Handles AddOn commands.
-- **************************************************************************
function FarmBuddy:ChatCommand(input)

  local cmd, value, arg1 = self:GetArgs(input, 3);

  -- Show help
  if not cmd or cmd == 'help' then
    self:CmdGetHelp();

  -- Prints version information
  elseif cmd == 'version' then
    self:CmdVersion();

  -- Reset AddOn settings
  elseif cmd == 'reset' then
    self:CmdReset(value);

    -- Set tracked item
  elseif cmd == 'track' then
    self:CmdTrack(value, arg1);

  -- Set goal quantity
  elseif cmd == 'quantity' then
    self:CmdQuantity(value, arg1);

  -- Open settings
  elseif cmd == 'settings' then
    self:CmdSettings();
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:CmdGetHelp()
-- DESC : Handles the help chat command.
-- **************************************************************************
function FarmBuddy:CmdGetHelp()

  self:Print(L['FARM_BUDDY_COMMAND_LIST'] .. '\n');
  self:GetChatCommandsHelp(true);
end

-- **************************************************************************
-- NAME : FarmBuddy:CmdVersion()
-- DESC : Handles the version chat command.
-- **************************************************************************
function FarmBuddy:CmdVersion()

  self:Print(GetAddOnMetadata('FarmBuddy', 'Version'));
end

-- **************************************************************************
-- NAME : FarmBuddy:CmdReset()
-- DESC : Handles the reset chat command.
-- **************************************************************************
function FarmBuddy:CmdReset(value)

  if value == 'all' then
    self:ResetConfig()
  else
    self:ResetItems(false);
  end

  self:InitItems();
  self:UpdateGUI();

  self:Print(L['FARM_BUDDY_CONFIG_RESET_MSG']);
end

-- **************************************************************************
-- NAME : FarmBuddy:CmdTrack()
-- DESC : Handles the track chat command.
-- **************************************************************************
function FarmBuddy:CmdTrack(item, quantity)

  if item ~= nil then

    local chatText;

    -- Convert item link to name
    local origItem = item;
    item = self:ItemLinkToID(item);

    -- Add the item
    self:AddConfigItem(nil, nil, item);

    if (quantity ~= nil) then
      local status = self:ValidateNumber(nil, quantity);
      if (status == true) then
        local itemID = self:GetItemIDByName(item);
        if (itemID ~= nil) then
          self:SetItemProp(itemID, 'quantity', tonumber(quantity), true);
        end
      end
    end

    self:InitItems();
    self:UpdateGUI();

    local text = L['FARM_BUDDY_ITEM_SET_MSG']:gsub('!itemName!', origItem);
    self:Print(text);
  else
    self:Print(L['FARM_BUDDY_TRACK_ITEM_PARAM_MISSING'])
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:CmdQuantity()
-- DESC : Handles the quantity chat command.
-- **************************************************************************
function FarmBuddy:CmdQuantity(item, quantity)

  if item ~= nil then

    local status = self:ValidateNumber(nil, quantity);
    if (status == true) then

      local itemID = self:GetItemIDByName(item);
      if (itemID ~= nil) then
        self:SetItemProp(itemID, 'quantity', tonumber(quantity), true);
        self:Print(L['FARM_BUDDY_GOAL_SET']);
      else
        self:Print(L['FARM_BUDDY_ITEM_NOT_ON_LIST']);
      end
    else
      self:Print(L['FARM_BUDDY_COMMAND_GOAL_PARAM_MISSING']);
    end
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:CmdSettings()
-- DESC : Handles the settings chat command.
-- **************************************************************************
function FarmBuddy:CmdSettings()
  self:OpenSettings('tab_general');
end

-- **************************************************************************
-- NAME : FarmBuddy:ItemLinkToName()
-- DESC : Converts a item link to item name.
-- **************************************************************************
function FarmBuddy:ItemLinkToID(item)

  local itemID = item:match("item:(%d+)");
  if (itemID ~= nil) then
    item = itemID;
  end

  return item;
end