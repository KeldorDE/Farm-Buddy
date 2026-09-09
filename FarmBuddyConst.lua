-- **************************************************************************
-- * FarmBuddyConst.lua
-- *
-- * By: Keldor
-- **************************************************************************

-- Addon information
FARM_BUDDY_ID = 'FarmBuddyStandalone'
FARM_BUDDY_ADDON_NAME = 'Farm Buddy'
-- Chunk vararg: the addon's folder name, as expected by C_AddOns.* APIs
FARM_BUDDY_FOLDER = ...

local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true)

FARM_BUDDY_RANDOM_CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

-- Colors
FARM_BUDDY_COLOR_WHITE = 'FFFFFFFF'
FARM_BUDDY_COLOR_YELLOW = 'FFFFFF00'
FARM_BUDDY_COLOR_GREEN = 'FF00FF00'
FARM_BUDDY_COLOR_ORANGE = 'FFFFD300'
FARM_BUDDY_COLOR_BLUE = 'FF4FBCD5'

-- Dialogs
FARM_BUDDY_DIALOG_SET_ITEM_GOAL = 'FARM_BUDDY_DIALOG_SET_ITEM_GOAL'
FARM_BUDDY_DIALOG_RESET_ALL_ITEMS_CONFIRM = 'FARM_BUDDY_DIALOG_RESET_ALL_ITEMS_CONFIRM'
FARM_BUDDY_DIALOG_RESET_ALL_CONFIRM = 'FARM_BUDDY_DIALOG_RESET_ALL_CONFIRM'
FARM_BUDDY_DIALOG_RESET_FRAME_POSITION_CONFIRM = 'FARM_BUDDY_DIALOG_RESET_FRAME_POSITION_CONFIRM'

-- Settings
FARM_BUDDY_ITEM_PREFIX = FARM_BUDDY_ID .. 'Item'
FARM_BUDDY_NOTIFICATION_SOUNDS = {
    [SOUNDKIT.ALARM_CLOCK_WARNING_1]        = L['FARM_BUDDY_SOUND_ALARM_1'],
    [SOUNDKIT.ALARM_CLOCK_WARNING_2]        = L['FARM_BUDDY_SOUND_ALARM_2'],
    [SOUNDKIT.ALARM_CLOCK_WARNING_3]        = L['FARM_BUDDY_SOUND_ALARM_3'],
    [SOUNDKIT.READY_CHECK]                  = L['FARM_BUDDY_SOUND_READY_CHECK'],
    [SOUNDKIT.RAID_WARNING]                 = L['FARM_BUDDY_SOUND_RAID_WARNING'],
    [SOUNDKIT.AUCTION_WINDOW_OPEN]          = L['FARM_BUDDY_SOUND_AUCTION'],
    [SOUNDKIT.IG_QUEST_LIST_COMPLETE]       = L['FARM_BUDDY_SOUND_QUEST_COMPLETE'],
    [SOUNDKIT.LFG_REWARDS]                  = L['FARM_BUDDY_SOUND_DUNGEON_REWARD'],
    [SOUNDKIT.UI_EPICLOOT_TOAST]            = L['FARM_BUDDY_SOUND_EPIC_LOOT'],
    [SOUNDKIT.UI_LEGENDARY_LOOT_TOAST]      = L['FARM_BUDDY_SOUND_LEGENDARY_LOOT'],
}

-- Chat commands
FARM_BUDDY_CHAT_COMMAND = 'fbs'
FARM_BUDDY_CHAT_COMMANDS = {
    {
        Command = 'track',
        Args = '<' .. L['FARM_BUDDY_COMMAND_TRACK_ARGS'] .. '> <' .. L['FARM_BUDDY_COMMAND_GOAL_ARGS'] .. '>',
        Description = L['FARM_BUDDY_COMMAND_TRACK_DESC'],
        Handler = 'CmdTrack',
    },
    {
        Command = 'quantity',
        Args = '<' .. L['FARM_BUDDY_COMMAND_TRACK_ARGS'] .. '> <' .. L['FARM_BUDDY_COMMAND_GOAL_ARGS'] .. '>',
        Description = L['FARM_BUDDY_COMMAND_GOAL_DESC'],
        Handler = 'CmdQuantity',
    },
    {
        Command = 'toggle',
        Args = '',
        Description = L['FARM_BUDDY_COMMAND_TOGGLE_DESC'],
        Handler = 'CmdToggle',
    },
    {
        Command = 'settings',
        Args = '',
        Description = L['FARM_BUDDY_COMMAND_SETTINGS_DESC'],
        Handler = 'CmdSettings',
    },
    {
        Command = 'testNotification',
        Args = '',
        Description = L['FARM_BUDDY_COMMAND_TEST_NOTIFICATION_DESC'],
        Handler = 'CmdTestNotification',
    },
    {
        Command = 'reset',
        Args = '<' .. L['FARM_BUDDY_COMMAND_RESET_ARGS'] .. '>',
        Description = L['FARM_BUDDY_COMMAND_RESET_DESC'],
        Handler = 'CmdReset',
    },
    {
        Command = 'version',
        Args = '',
        Description = L['FARM_BUDDY_COMMAND_VERSION_DESC'],
        Handler = 'CmdVersion',
    },
    {
        Command = 'help',
        Args = '',
        Description = L['FARM_BUDDY_COMMAND_HELP_DESC'],
        Handler = 'CmdGetHelp',
    }
}
