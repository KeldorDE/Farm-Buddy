---@diagnostic disable: undefined-global
-- **************************************************************************
-- * FarmBuddySettings.lua
-- *
-- * By: Keldor
-- **************************************************************************

local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true)
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID)
local CONFIG_REG = LibStub("AceConfigRegistry-3.0")
local ADDON_VERSION = C_AddOns.GetAddOnMetadata('FarmBuddy', 'Version')
local ITEM_PREFIX = FARM_BUDDY_ID .. 'Item'
local ID_LENGTH = 32
local OPTION_ORDER = {}
local RANDOM_CHARS = {}
local POPUP_KEY_RESET_ALL_ITEMS_CONFIRM = FARM_BUDDY_ADDON_NAME .. 'ResetAllItemsConfirm'
local POPUP_KEY_RESET_ALL_CONFIRM = FARM_BUDDY_ADDON_NAME .. 'ResetAllConfirm'
local POPUP_KEY_RESET_FRAME_POSITION_CONFIRM = FARM_BUDDY_ADDON_NAME .. 'ResetFramePositionConfirm'
local NOTIFICATION_SOUNDS = {
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

---Creates the configuration page.
function FarmBuddy:InitSettings()
    LibStub('AceConfig-3.0'):RegisterOptionsTable(FARM_BUDDY_ADDON_NAME, self:GetConfigOptions())
    self.optionsFrame, self.optionsID = LibStub('AceConfigDialog-3.0'):AddToBlizOptions(FARM_BUDDY_ADDON_NAME)
    self:GenerateChars()
    self:LoadExistingConfigItems()
    self:RegisterDialogs()
end

---Gets the configuration array for the AceConfig lib.
---@return table
function FarmBuddy:GetConfigOptions()
    local options = {
        name = FARM_BUDDY_ADDON_NAME,
        handler = FarmBuddy,
        childGroups = 'tree',
        type = 'group',
        args = {
            info_version = {
                type = 'description',
                name = L['FARM_BUDDY_VERSION'] .. ': ' .. ADDON_VERSION,
                order = self:GetOptionOrder('main'),
            },
            info_author = {
                type = 'description',
                name = L['FARM_BUDDY_AUTHOR'] .. ': ' .. C_AddOns.GetAddOnMetadata('FarmBuddy', 'Author'),
                order = self:GetOptionOrder('main'),
            },
            tab_general = {
                name = L['FARM_BUDDY_SETTINGS'],
                type = 'group',
                order = self:GetOptionOrder('main'),
                args = {
                    general_space_1 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('general'),
                    },
                    general_include_bank = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_INCLUDE_BANK'],
                        desc = L['FARM_BUDDY_INCLUDE_BANK_DESC'],
                        get = function() return self:GetSetting('includeBank', 'bool') end,
                        set = function(_, input) self:SetSetting('includeBank', 'bool', input, true) end,
                        width = 'full',
                        order = self:GetOptionOrder('general'),
                    },
                    general_space_2 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('general'),
                    },
                    general_hide_frame_in_combat = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_HIDE_FRAME_IN_COMBAT'],
                        get = function() return self:GetSetting('hideFrameInCombat', 'bool') end,
                        set = function(_, input) self:SetSetting('hideFrameInCombat', 'bool', input, true) end,
                        width = 'full',
                        order = self:GetOptionOrder('general'),
                    },
                    general_space_3 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('general'),
                    },
                    general_shortcuts_heading = {
                        type = 'header',
                        name = L['FARM_BUDDY_SHORTCUTS'],
                        order = self:GetOptionOrder('general'),
                    },
                    general_fast_tracking_shortcut_mouse_button = {
                        type = 'select',
                        style = 'radio',
                        name = L['FARM_BUDDY_FAST_TRACKING_MOUSE_BUTTON'],
                        get = function() return self:GetSetting('fastTrackingMouseButton', 'string') end,
                        set = function(_, input) self:SetSetting('fastTrackingMouseButton', 'string', input, false) end,
                        width = 'full',
                        values = {
                            LeftButton = L['FARM_BUDDY_KEY_LEFT_MOUSE_BUTTON'],
                            RightButton = L['FARM_BUDDY_KEY_RIGHT_MOUSE_BUTTON'],
                        },
                        order = self:GetOptionOrder('general'),
                    },
                    general_space_4 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('general'),
                    },
                    general_fast_tracking_shortcut_keys = {
                        type = 'multiselect',
                        name = L['FARM_BUDDY_FAST_TRACKING_SHORTCUTS'],
                        desc = L['FARM_BUDDY_FAST_TRACKING_SHORTCUTS_DESC'],
                        set = 'SetKeySetting',
                        get = 'GetKeySetting',
                        values = {
                            alt = L['FARM_BUDDY_KEY_ALT'],
                            ctrl = L['FARM_BUDDY_KEY_CTRL'],
                            shift = L['FARM_BUDDY_KEY_SHIFT'],
                        },
                        width = 'full',
                        order = self:GetOptionOrder('general'),
                    },
                    general_space_5 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('general'),
                    },
                    general_shortcuts_heading = {
                        type = 'header',
                        name = L['FARM_BUDDY_DATA_BROKER'],
                        order = self:GetOptionOrder('general'),
                    },
                    general_space_6 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('general'),
                    },
                    general_enable_data_broker_support = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_ENABLE_DATA_BROKER_SUPPORT'],
                        get = function() return self:GetSetting('enableDataBrokerSupport', 'bool') end,
                        set = function(_, input) self:SetSetting('enableDataBrokerSupport', 'bool', input, true) end,
                        width = 'full',
                        order = self:GetOptionOrder('general'),
                    },
                    general_space_7 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('general'),
                    },
                    general_data_broker_show_item_name = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_DATA_BROKER_SHOW_ITEM_NAME'],
                        get = function() return self:GetSetting('showDataBrokerItemName', 'bool') end,
                        set = function(_, input) self:SetSetting('showDataBrokerItemName', 'bool', input, true) end,
                        width = 'full',
                        order = self:GetOptionOrder('general'),
                    },
                    general_space_8 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('general'),
                    },
                    general_data_broker_num_items = {
                        type = 'input',
                        name = L['FARM_BUDDY_DATA_BROKER_NUM_ITEMS'],
                        desc = L['FARM_BUDDY_DATA_BROKER_NUM_ITEMS_DESC'],
                        validate = 'ValidateNumber',
                        get = function() return self:GetSetting('dataBrokerNumItems', 'string') end,
                        set = function(_, input) self:SetSetting('dataBrokerNumItems', 'number', input, true) end,
                        width = 'double',
                        order = self:GetOptionOrder('general'),
                    },
                },
            },
            tab_items = {
                name = L['FARM_BUDDY_ITEMS'],
                type = 'group',
                childGroups = 'tree',
                order = self:GetOptionOrder('main'),
                args = {
                    items_space_1 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('items'),
                    },
                    items_description = {
                        type = 'description',
                        name = L['FARM_BUDDY_ADD_ITEM_DESC'],
                        order = self:GetOptionOrder('items'),
                    },
                    items_add_item = {
                        type = 'execute',
                        name = L['FARM_BUDDY_ADD_NEW_ITEM'],
                        func = function() self:AddConfigItem() end,
                        width = 'double',
                        order = self:GetOptionOrder('items'),
                    },
                    items_space_2 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('items'),
                    },
                },
            },
            tab_appearance = {
                name = L['FARM_BUDDY_APPEARANCE'],
                type = 'group',
                order = self:GetOptionOrder('main'),
                args = {
                    appearance_show_frame = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_SHOW_FRAME'],
                        get = function() return self:GetSetting('showFrame', 'bool') end,
                        set = function(_, input) self:SetSetting('showFrame', 'bool', input, false) self:SetShowFrame() end,
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_1 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_show_title = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_SHOW_TITLE'],
                        desc = L['FARM_BUDDY_SHOW_TITLE_DESC'],
                        get = function() return self:GetSetting('showTitle', 'bool') end,
                        set = function(_, input) self:SetSetting('showTitle', 'bool', input, false) self:SetTitleDisplay() end,
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_2 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_show_buttons = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_SHOW_BUTTONS'],
                        desc = L['FARM_BUDDY_SHOW_BUTTONS_DESC'],
                        get = function() return self:GetSetting('showButtons', 'bool') end,
                        set = function(_, input) self:SetSetting('showButtons', 'bool', input, false) self:SetButtonDisplay() end,
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_3 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_show_quantity = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_SHOW_GOAL'],
                        get = function() return self:GetSetting('showQuantity', 'bool') end,
                        set = function(_, input) self:SetSetting('showQuantity', 'bool', input, true) end,
                        width = 'full',
                        order = self:GetOptionOrder('general'),
                    },
                    appearance_space_4 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('general'),
                    },
                    appearance_show_goal_indicator = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_SHOW_GOAL_INDICATOR'],
                        desc = L['FARM_BUDDY_SHOW_GOAL_INDICATOR_DESC'],
                        get = function() return self:GetSetting('showGoalIndicator', 'bool') end,
                        set = function(_, input) self:SetSetting('showGoalIndicator', 'bool', input, true) end,
                        width = 'full',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_5 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_show_progressbar = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_SHOW_PROGRESS_BAR'],
                        desc = L['FARM_BUDDY_SHOW_PROGRESS_BAR_DESC'],
                        get = function() return self:GetSetting('showProgressBar', 'bool') end,
                        set = function(_, input) self:SetSetting('showProgressBar', 'bool', input, true) end,
                        width = 'full',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_6 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_lock_frame = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_LOCK_FRAME'],
                        desc = L['FARM_BUDDY_LOCK_FRAME_DESC'],
                        get = function() return self:GetSetting('frameLocked', 'bool') end,
                        set = function(_, input) self:SetSetting('frameLocked', 'bool', input, false) self:SetFrameLockStatus() end,
                        width = 'full',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_7 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_progress_display = {
                        type = 'select',
                        style = 'radio',
                        name = L['FARM_BUDDY_PROGRESS_DISPLAY'],
                        get = function() return self:GetSetting('progressStyle', 'string') end,
                        set = function(_, input) self:SetSetting('progressStyle', 'string', input, true) end,
                        width = 'full',
                        values = {
                            CountPercentage = L['FARM_BUDDY_COUNT_WITH_PERCENTAGE'],
                            Count = L['FARM_BUDDY_COUNT'],
                            Percentage = L['FARM_BUDDY_PERCENTAGE'],
                        },
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_8 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_show_bonus = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_SHOW_BONUS'],
                        desc = L['FARM_BUDDY_SHOW_BONUS_DESC'],
                        get = function() return self:GetSetting('showGoalBonus', 'bool') end,
                        set = function(_, input) self:SetSetting('showGoalBonus', 'bool', input, true) end,
                        width = 'full',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_9 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_bonus_display = {
                        type = 'select',
                        style = 'radio',
                        name = L['FARM_BUDDY_BONUS_DISPLAY'],
                        get = function() return self:GetSetting('goalBonusDisplay', 'string') end,
                        set = function(_, input) self:SetSetting('goalBonusDisplay', 'string', input, true) end,
                        width = 'full',
                        values = {
                            percent = L['FARM_BUDDY_PERCENT'],
                            count = L['FARM_BUDDY_ITEM_COUNT'],
                        },
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_10 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_sort_by = {
                        type = 'select',
                        style = 'radio',
                        name = L['FARM_BUDDY_SORT_BY'],
                        get = function() return self:GetSetting('sortBy', 'string') end,
                        set = function(_, input) self:SetSetting('sortBy', 'string', input, true) end,
                        width = 'full',
                        values = {
                            name = L['FARM_BUDDY_NAME'],
                            rarity = L['FARM_BUDDY_RARITY'],
                            count = L['FARM_BUDDY_COUNT_SINGLE'],
                        },
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_11 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_sort_order = {
                        type = 'select',
                        style = 'radio',
                        name = L['FARM_BUDDY_SORT_ORDER'],
                        get = function() return self:GetSetting('sortOrder', 'string') end,
                        set = function(_, input) self:SetSetting('sortOrder', 'string', input, true) end,
                        width = 'full',
                        values = {
                            asc = L['FARM_BUDDY_SORT_ASC'],
                            desc = L['FARM_BUDDY_SORT_DESC'],
                        },
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_12 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_color_heading = {
                        type = 'header',
                        name = L['FARM_BUDDY_COLORS'],
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_progress_no_goal_color = {
                        type = 'color',
                        name = L['FARM_BUDDY_BAR_COLOR_NO_GOAL'],
                        hasAlpha = false,
                        set = function(_, r,g,b,a) self:SetColorSetting('progressBarNoGoalColor', r, g, b, a, true) end,
                        get = function() return self:GetColorSetting('progressBarNoGoalColor') end,
                        width = 'full',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_progress_goal_color = {
                        type = 'color',
                        name = L['FARM_BUDDY_BAR_COLOR_GOAL'],
                        hasAlpha = false,
                        set = function(_, r,g,b,a) self:SetColorSetting('progressBarGoalColor', r, g, b, a, true) end,
                        get = function() return self:GetColorSetting('progressBarGoalColor') end,
                        width = 'full',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_progress_no_quantity_color = {
                        type = 'color',
                        name = L['FARM_BUDDY_BAR_COLOR_NO_QUANTITY'],
                        hasAlpha = false,
                        set = function(_, r,g,b,a) self:SetColorSetting('progressBarNoQuantityColor', r, g, b, a, true) end,
                        get = function() return self:GetColorSetting('progressBarNoQuantityColor') end,
                        width = 'full',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_13 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_background_transparency = {
                        type = 'range',
                        name = L['FARM_BUDDY_BACKGROUND_TRANSPARENCY'],
                        get = function() return self:GetSetting('backgroundTransparency', 'number') end,
                        set = function(_, input) self:SetSetting('backgroundTransparency', 'number', input, false) self:SetBackgroundTransparency() end,
                        isPercent = true,
                        bigStep  = 0.01,
                        min = 0,
                        max = 1,
                        width = 'full',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_space_14 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('appearance'),
                    },
                    appearance_scale = {
                        type = 'range',
                        name = L['FARM_BUDDY_FRAME_SCALE'],
                        get = function() return self:GetSetting('frameScale', 'number') end,
                        set = function(_, input) self:SetSetting('frameScale', 'number', input, false) self:SetScale() end,
                        isPercent = true,
                        bigStep  = 0.1,
                        min = 0.5,
                        max = 2.0,
                        width = 'full',
                        order = self:GetOptionOrder('appearance'),
                    },
                },
            },
            tab_notifications = {
                name = L['FARM_BUDDY_NOTIFICATIONS'],
                type = 'group',
                order = self:GetOptionOrder('main'),
                args = {
                    notifications_notification_status = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_NOTIFICATION'],
                        desc = L['FARM_BUDDY_NOTIFICATION_DESC'],
                        get = function() return self:GetSetting('goalNotification', 'bool') end,
                        set = function(_, input) self:SetSetting('goalNotification', 'bool', input, false) end,
                        width = 'full',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_space_1 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_hide_in_combat = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_HIDE_NOTIFICATIONS_IN_COMBAT'],
                        get = function() return self:GetSetting('hideNotificationsInCombat', 'bool') end,
                        set = function(_, input) self:SetSetting('hideNotificationsInCombat', 'bool', input, true) end,
                        width = 'full',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_space_2 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_notification_display_duration = {
                        type = 'input',
                        name = L['FARM_BUDDY_PLAY_NOTIFICATION_DISPLAY_DURATION'],
                        desc = L['FARM_BUDDY_PLAY_NOTIFICATION_DISPLAY_DURATION_DESC'],
                        get = function() return self:GetSetting('notificationDisplayDuration', 'string') end,
                        set = function(_, input) self:SetSetting('notificationDisplayDuration', 'number', input, false) end,
                        validate = 'ValidateNumber',
                        width = 'double',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_space_3 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_notification_glow = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_NOTIFICATION_GLOW'],
                        desc = L['FARM_BUDDY_NOTIFICATION_GLOW_DESC'],
                        get = function() return self:GetSetting('notificationGlow', 'bool') end,
                        set = function(_, input) self:SetSetting('notificationGlow', 'bool', input, false) end,
                        width = 'full',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_space_4 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_notification_shine = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_NOTIFICATION_SHINE'],
                        desc = L['FARM_BUDDY_NOTIFICATION_SHINE_DESC'],
                        get = function() return self:GetSetting('notificationShine', 'bool') end,
                        set = function(_, input) self:SetSetting('notificationShine', 'bool', input, false) end,
                        width = 'full',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_space_5 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_play_notification_sound = {
                        type = 'toggle',
                        name = L['FARM_BUDDY_PLAY_NOTIFICATION_SOUND'],
                        desc = L['FARM_BUDDY_PLAY_NOTIFICATION_SOUND_DESC'],
                        get = function() return self:GetSetting('notificationSound', 'bool') end,
                        set = function(_, input) self:SetSetting('notificationSound', 'bool', input, false) end,
                        width = 'full',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_space_6 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_notification_sound = {
                        type = 'select',
                        name = L['FARM_BUDDY_NOTIFICATION_SOUND'],
                        style = 'dropdown',
                        values = self:GetNotificationSounds(),
                        sorting = self:GetNotificationSoundsSorting(),
                        set = 'SetNotificationSound',
                        get = 'GetNotificationSound',
                        width = 'double',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_space_7 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('notifications'),
                    },
                    notifications_move_notification = {
                        type = 'execute',
                        name = L['FARM_BUDDY_MOVE_NOTIFICATION'],
                        desc = L['FARM_BUDDY_MOVE_NOTIFICATION_DESC'],
                        func = function() FarmBuddyNotification_ShowAnchor() end,
                        width = 'double',
                        order = self:GetOptionOrder('notifications'),
                    },
                }
            },
            tab_actions = {
                name = L['FARM_BUDDY_ACTIONS'],
                type = 'group',
                order = self:GetOptionOrder('main'),
                args = {
                    actions_space_1 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('actions'),
                    },
                    actions_space_2 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('actions'),
                        width = 'half',
                    },
                    actions_test_alert = {
                        type = 'execute',
                        name = L['FARM_BUDDY_TEST_NOTIFICATION'],
                        desc = L['FARM_BUDDY_TEST_NOTIFICATION_DESC'],
                        func = 'TestNotification',
                        width = 'double',
                        order = self:GetOptionOrder('actions'),
                    },
                    actions_space_3 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('actions'),
                    },
                    actions_space_4 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('actions'),
                        width = 'half',
                    },
                    actions_reset_items = {
                        type = 'execute',
                        name = L['FARM_BUDDY_RESET_ALL_ITEMS'],
                        desc = L['FARM_BUDDY_RESET_ALL_ITEMS_DESC'],
                        func = function() StaticPopup_Show(POPUP_KEY_RESET_ALL_ITEMS_CONFIRM) end,
                        width = 'double',
                        order = self:GetOptionOrder('actions'),
                    },
                    actions_space_5 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('actions'),
                    },
                    actions_space_6 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('actions'),
                        width = 'half',
                    },
                    actions_reset_frame_position = {
                        type = 'execute',
                        name = L['FARM_BUDDY_RESET_FRAME_POSITION'],
                        desc = L['FARM_BUDDY_RESET_FRAME_POSITION_DESC'],
                        func = function() StaticPopup_Show(POPUP_KEY_RESET_FRAME_POSITION_CONFIRM) end,
                        width = 'double',
                        order = self:GetOptionOrder('actions'),
                    },
                    actions_space_7 = {
                        type = 'header',
                        name = '',
                        order = self:GetOptionOrder('actions'),
                    },
                    actions_space_8 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('actions'),
                        width = 'half',
                    },
                    actions_reset_all = {
                        type = 'execute',
                        name = L['FARM_BUDDY_RESET_ALL'],
                        desc = L['FARM_BUDDY_RESET_ALL_DESC'],
                        func = function() StaticPopup_Show(POPUP_KEY_RESET_ALL_CONFIRM) end,
                        width = 'double',
                        order = self:GetOptionOrder('actions'),
                    },
                }
            },
            tab_profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db),
            tab_about = {
                name = L['FARM_BUDDY_ABOUT'],
                type = 'group',
                order = self:GetOptionOrder('main'),
                args = {
                    about_space_1 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('about'),
                    },
                    about_info_version_title = {
                        type = 'description',
                        name = L['FARM_BUDDY_VERSION'],
                        order = self:GetOptionOrder('about'),
                        width = 'half',
                    },
                    about_info_version = {
                        type = 'description',
                        name = ADDON_VERSION,
                        order = self:GetOptionOrder('about'),
                        width = 'double',
                    },
                    about_space_2 = {
                        type = 'description',
                        name = '',
                        order = self:GetOptionOrder('about'),
                    },
                    about_info_author_title = {
                        type = 'description',
                        name = L['FARM_BUDDY_AUTHOR'],
                        order = self:GetOptionOrder('about'),
                        width = 'half',
                    },
                    about_info_author = {
                        type = 'description',
                        name = C_AddOns.GetAddOnMetadata('FarmBuddy', 'Author'),
                        order = self:GetOptionOrder('about'),
                        width = 'double',
                    },
                    about_space_3 = {
                        type = 'description',
                        name = '\n\n',
                        order = self:GetOptionOrder('about'),
                    },
                    about_info_localization_title = {
                        type = 'description',
                        fontSize = 'medium',
                        name = self:GetColoredText(L['FARM_BUDDY_LOCALIZATION'], FARM_BUDDY_COLOR_YELLOW) .. '\n',
                        order = self:GetOptionOrder('about'),
                        width = 'full',
                    },
                    about_info_localization_deDE = {
                        type = 'description',
                        fontSize = 'small',
                        name = self:GetColoredText(L['FARM_BUDDY_GERMAN'], FARM_BUDDY_COLOR_GREEN) .. '\n',
                        order = self:GetOptionOrder('about'),
                        width = 'full',
                    },
                    about_info_localization_supporters = {
                        type = 'description',
                        name = '   • Keldor\n\n\n',
                        order = self:GetOptionOrder('about'),
                        width = 'full',
                    },
                    about_info_support_title = {
                        type = 'description',
                        fontSize = 'medium',
                        name = self:GetColoredText(L['FARM_BUDDY_SUPPORT'], FARM_BUDDY_COLOR_YELLOW) .. '\n',
                        order = self:GetOptionOrder('about'),
                        width = 'full',
                    },
                    about_info_support_text = {
                        type = 'description',
                        name = '   • ' .. L['FARM_BUDDY_SUPPORT_TEXT'] .. '\n\n\n',
                        order = self:GetOptionOrder('about'),
                        width = 'full',
                    },
                    about_info_chat_commands_title = {
                        type = 'description',
                        fontSize = 'medium',
                        name = self:GetColoredText(L['FARM_BUDDY_CHAT_COMMANDS'], FARM_BUDDY_COLOR_YELLOW) .. '\n',
                        order = self:GetOptionOrder('about'),
                        width = 'full',
                    },
                    about_info_chat_commands = {
                        type = 'description',
                        name = self:GetChatCommandsHelp(false),
                        order = self:GetOptionOrder('about'),
                        width = 'full',
                    },
                }
            },
        }
    }

    -- Order profile tab right before the about entry
    options.args.tab_profiles.order = options.args.tab_about.order - 1

    return options
end

---Adds a new config item row to tree.
---@param id string|nil
---@param itemID number|string
---@param name string|nil
function FarmBuddy:AddConfigItem(id, itemID, name)
    local options = CONFIG_REG:GetOptionsTable(FARM_BUDDY_ADDON_NAME, 'dialog', 'AceConfigDialog-3.0')
    local itemIDText

    if (itemID == nil or tonumber(itemID) == 0) then
        itemID = 0
        itemIDText = L['FARM_BUDDY_WAITING_FOR_DATA'] .. '...'
    else
        itemIDText = itemID
    end

    -- New item so generate a unique ID to save it in SavedVariables
    if (id == nil) then

        id = self:GetRandomString(ID_LENGTH)
        if (name == nil) then
            name = ''
        end

        if (self.db.profile.items ~= nil) then
            tinsert(self.db.profile.items, {
                id = id,
                itemID = tonumber(itemID),
                name = name,
                quantity = 0,
                rarity = 0,
            })
        end
    end

    local count = (self:TableLength(options.args.tab_items.args) - 4) + 1

    options.args.tab_items.args[ITEM_PREFIX .. id] = {
        name = L['FARM_BUDDY_ITEM'] .. ' ' .. count,
        type = 'group',
        order = self:GetOptionOrder('items'),
        unique_index = id,
        args = {
            ['item_name_' .. id] = {
                type = 'input',
                name = L['FARM_BUDDY_ITEM_SETTING'],
                desc = L['FARM_BUDDY_ITEM_TO_TRACK_DESC'],
                get = function(info) return self:GetItemFromSV(info.option.unique_index, 'name', false) end,
                set = function(info, input) self:SetItem(info.option.unique_index, input) end,
                width = 'double',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_spacer_1_' .. id] = {
                type = 'description',
                name = '',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_quantity_' .. id] = {
                type = 'input',
                name = L['FARM_BUDDY_QUANTITY'],
                desc = L['FARM_BUDDY_COMMAND_GOAL_DESC'],
                usage = L['FARM_BUDDY_ALERT_COUNT_USAGE'],
                validate = 'ValidateNumber',
                get = function(info) return self:GetItemFromSV(info.option.unique_index, 'quantity', false) end,
                set = function(info, input) self:SetItemProp(info.option.unique_index, 'quantity', input, true) end,
                width = 'half',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_hidden_' .. id] = {
                type = 'toggle',
                name = L['FARM_BUDDY_HIDE_ITEM'],
                desc = L['FARM_BUDDY_HIDE_ITEM_DESC'],
                usage = L['FARM_BUDDY_HIDE_ITEM_USAGE'],
                get = function(info) return self:GetItemFromSV(info.option.unique_index, 'hidden', true) == 1 end,
                set = function(info, input) self:SetItemProp(info.option.unique_index, 'hidden', (input and 1 or 0), true) end,
                width = 'half',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_spacer_2_' .. id] = {
                type = 'description',
                name = '',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_spacer_line_1_' .. id] = {
                type = 'header',
                name = '',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_id_desc_' .. id] = {
                type = 'description',
                name = self:GetColoredText(L['FARM_BUDDY_ITEM_ID'] .. ':', FARM_BUDDY_COLOR_ORANGE),
                width = 'half',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_id_' .. id] = {
                type = 'description',
                name = itemIDText,
                width = 'half',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_spacer_3_' .. id] = {
                type = 'description',
                name = '',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_spacer_line_2_' .. id] = {
                type = 'header',
                name = '',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_clear_button_' .. id] = {
                type = 'execute',
                name = L['FARM_BUDDY_REMOVE_ITEM'],
                desc = L['FARM_BUDDY_REMOVE_ITEM_DESC'],
                order = self:GetOptionOrder(id),
                func = function(info) self:RemoveItem(info) end,
                unique_index = id,
            },
            ['item_spacer_line_3_' .. id] = {
                type = 'header',
                name = '',
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
            ['item_desc_' .. id] = {
                type = 'description',
                name = L['FARM_BUDDY_ITEM_TO_TRACK_USAGE'],
                order = self:GetOptionOrder(id),
                unique_index = id,
            },
        },
    }

    CONFIG_REG:NotifyChange(FARM_BUDDY_ADDON_NAME)
end

---Loads existing items from SavedVariables.
function FarmBuddy:LoadExistingConfigItems()
    if (self.db.profile.items ~= nil) then
        local items = self.db.profile.items
        for _, itemStorage in pairs(items) do
            self:AddConfigItem(itemStorage.id, itemStorage.itemID)
        end
        CONFIG_REG:NotifyChange(FARM_BUDDY_ADDON_NAME)
    end
end

---Gets the SavedVariables index for the given item ID.
---@param id string
---@return number?
function FarmBuddy:GetItemIndexByID(id)
    if (self.db.profile.items ~= nil) then
        for k, v in pairs(self.db.profile.items) do
            if (v.id == id) then
                return k
            end
        end
    end

    return nil
end

---Gets the unique ID from the SavedVariables by item ID.
---@param itemID number|string
---@return string?
function FarmBuddy:GetItemUniqueIDByItemID(itemID)
    if (self.db.profile.items ~= nil) then
        for _, v in pairs(self.db.profile.items) do
            if (tonumber(v.itemID) == tonumber(itemID)) then
                return v.id
            end
        end
    end

    return nil
end

---Gets the key value from the SavedVariables item list.
---@param id string
---@param key string
---@param numeric boolean
---@return number|string
function FarmBuddy:GetItemFromSV(id, key, numeric)
    local index = self:GetItemIndexByID(id)
    local value
    if numeric == true then
        value = 0
    else
        value = ''
    end

    if(index ~= nil and self.db.profile.items[index][key] ~= nil) then
        value = self.db.profile.items[index][key]

        if(numeric == true) then
            value = tonumber(value)
        else
            value = tostring(value)
        end
    end

    return value
end

---Saves the item with the given ID and key to the SavedVariables.
---@param id string
---@param key string
---@param input string|number
---@param numeric boolean
function FarmBuddy:SetItemProp(id, key, input, numeric)
    local index = self:GetItemIndexByID(id)
    if(index ~= nil) then

        -- Set empty value based on numeric var
        if (input == '') then
            if (numeric == true) then
                input = 0
            else
                input = ''
            end
        end

        if (numeric == true) then
            input = tonumber(input)
        end

        self.db.profile.items[index][key] = input

        -- Only reset the trigger when the new goal exceeds the current count,
        -- so an already reached goal does not immediately notify again.
        if (key == 'quantity') then
            local item = self.db.profile.items[index]
            if (input > (item.count or 0)) then
                self:ResetNotificationTrigger(item.itemID, false)
            else
                self:ResetNotificationTrigger(item.itemID, true)
            end
        end
    end

    self:InitItems()
    self:UpdateGUI()
end

---Receive item info or fetch info from the server.
---@param id string
---@param input string
function FarmBuddy:SetItem(id, input)
    self:SetItemProp(id, 'name', input, false)

    local itemInfo = self:GetItemInfo(input, id)
    if (itemInfo ~= nil) then
        self:SetReceivedItemInfo(id, itemInfo)
    end
end

---Get the active status for the given key from the SavedVariables.
---@param _ table
---@param key string
---@return boolean
function FarmBuddy:GetKeySetting(_, key)

    if (self.db.profile.settings.fastTrackingKeys ~= nil) then
        if (self.db.profile.settings.fastTrackingKeys[key] ~= nil) then
            return self.db.profile.settings.fastTrackingKeys[key]
        end
    end

    return false
end

---Sets the status for the given key from the SavedVariables.
---@param _ table
---@param key string
---@param state boolean
function FarmBuddy:SetKeySetting(_, key, state)

    if (self.db.profile.settings.fastTrackingKeys ~= nil) then
        if (self.db.profile.settings.fastTrackingKeys[key] ~= nil) then
            self.db.profile.settings.fastTrackingKeys[key] = state
        end
    end
end

---Removes the item with the given ID from the settings GUI and SavedVariables.
---@param info table
function FarmBuddy:RemoveItem(info)
    local groupName = ITEM_PREFIX .. info.option.unique_index

    -- Remove settings group for item ID
    if (info.options.args.tab_items.args[groupName] ~= nil) then
        info.options.args.tab_items.args[groupName] = nil
    end

    -- Remove item from SavedVariables
    local index = self:GetItemIndexByID(info.option.unique_index)
    if(index ~= nil) then
        tremove(self.db.profile.items, index)
    end

    -- Remove frame and redraw
    self:RemoveItemFrame(info.option.unique_index)
    self:InitItems()
    self:UpdateGUI()

    -- Update settings GUI
    self:ReindexConfigItems()
    CONFIG_REG:NotifyChange(FARM_BUDDY_ADDON_NAME)
end

---Number item entries by it's new order.
function FarmBuddy:ReindexConfigItems()
    local options = CONFIG_REG:GetOptionsTable(FARM_BUDDY_ADDON_NAME, 'dialog', 'AceConfigDialog-3.0')
    if (options.args.tab_items.args ~= nil) then
        for k in pairs(options.args.tab_items.args) do
            if (string.sub(k, 1, string.len(ITEM_PREFIX)) == ITEM_PREFIX) then
                options.args.tab_items.args[k] = nil
            end
        end

        self:LoadExistingConfigItems()
    end
end

---A helper function to order the option items in the order as listed in the array.
---@param category string
---@return number
function FarmBuddy:GetOptionOrder(category)
    if not OPTION_ORDER[category] then
        OPTION_ORDER[category] = 0
    end

    OPTION_ORDER[category] = OPTION_ORDER[category] + 1

    return OPTION_ORDER[category]
end

---Gets the setting value.
---@param name string
---@param type string
---@return any
function FarmBuddy:GetSetting(name, type)

    local val

    if (self.db.profile.settings ~= nil) then
        if (self.db.profile.settings[name] ~= nil) then
            val = self.db.profile.settings[name]

            if (type == 'string') then
                val = tostring(val)
            end
        end
    end

    return val
end

---Sets the setting value.
---@param name string
---@param type string
---@param input any
---@param updateGUI boolean
function FarmBuddy:SetSetting(name, type, input, updateGUI)

    if (self.db.profile.settings ~= nil) then
        if (self.db.profile.settings[name] ~= nil) then

            if(type == 'number') then
                input = tonumber(input)
            end

            self.db.profile.settings[name] = input

            if (updateGUI == true) then
                self:InitItems()
                self:UpdateGUI()
            end
        end
    end
end

---Sets the color setting value.
---@param name string
---@param r number
---@param g number
---@param b number
---@param a number
---@param updateGUI boolean
function FarmBuddy:SetColorSetting(name, r, g, b, a, updateGUI)

    if (self.db.profile.settings ~= nil) then
        if (self.db.profile.settings[name] ~= nil) then
            if (r ~= nil and g ~= nil and b ~= nil) then
                self.db.profile.settings[name] = { r = r, g = g, b = b, a = a }

                if (updateGUI == true) then
                    self:UpdateGUI()
                end
            end
        end
    end
end

---Gets the color setting value.
---@param name string
---@return number? r
---@return number? g
---@return number? b
---@return number? a
function FarmBuddy:GetColorSetting(name)

    if (self.db.profile.settings ~= nil) then
        if (self.db.profile.settings[name] ~= nil) then
            local color = self.db.profile.settings[name]
            return color.r, color.g, color.b, color.a
        end
    end

    return nil
end

---Raises a test notification.
function FarmBuddy:TestNotification()
    local itemInfo = self:GetItemInfo(L['FARM_BUDDY_NOTIFICATION_DEMO_ITEM_NAME'])
    self:ShowNotification(0, itemInfo.Name, itemInfo.IconFileDataID, 200, true)
end

---Generates a table of random chars.
function FarmBuddy:GenerateChars()
    for i = 48, 57 do table.insert(RANDOM_CHARS, string.char(i)) end
    for i = 65, 90 do table.insert(RANDOM_CHARS, string.char(i)) end
    for i = 97, 122 do table.insert(RANDOM_CHARS, string.char(i)) end
end

---Generates a random string with the given length.
---@param length number
---@return string
function FarmBuddy:GetRandomString(length)
    local strTable = {}

    for _ = 1, length do
        table.insert(strTable, RANDOM_CHARS[math.random(1, #RANDOM_CHARS)])
    end

    return table.concat(strTable)
end

---Checks if the entered value a valid and positive number.
---@param _ table
---@param input string
---@return boolean
function FarmBuddy:ValidateNumber(_, input)

    local number = tonumber(input)
    if not number or number < 0 then
        self:Print(L['FARM_BUDDY_INVALID_NUMBER'])
        return false
    end

    return true
end

---Get a list of available sounds.
---@return table
function FarmBuddy:GetNotificationSounds()

    local sounds = {}

    for k, v in pairs(NOTIFICATION_SOUNDS) do
        sounds[k] = v
    end

    return sounds
end

---Get the sound keys sorted by their label ascending.
---@return table
function FarmBuddy:GetNotificationSoundsSorting()

    local sorting = {}

    for k in pairs(NOTIFICATION_SOUNDS) do
        table.insert(sorting, k)
    end

    table.sort(sorting, function(a, b)
        return NOTIFICATION_SOUNDS[a] < NOTIFICATION_SOUNDS[b]
    end)

    return sorting
end

---Registers the addons dialog boxes.
function FarmBuddy:RegisterDialogs()

    StaticPopupDialogs[POPUP_KEY_RESET_ALL_ITEMS_CONFIRM] = {
        text = L['FARM_BUDDY_CONFIRM_RESET'],
        button1 = L['FARM_BUDDY_YES'],
        button2 = L['FARM_BUDDY_NO'],
        OnAccept = function()
            self:ResetItems(true)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopupDialogs[POPUP_KEY_RESET_ALL_CONFIRM] = {
        text = L['FARM_BUDDY_CONFIRM_ALL_RESET'],
        button1 = L['FARM_BUDDY_YES'],
        button2 = L['FARM_BUDDY_NO'],
        OnAccept = function()
            self:ResetConfig()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopupDialogs[POPUP_KEY_RESET_FRAME_POSITION_CONFIRM] = {
        text = L['FARM_BUDDY_CONFIRM_RESET_FRAME_POSITION'],
        button1 = L['FARM_BUDDY_YES'],
        button2 = L['FARM_BUDDY_NO'],
        OnAccept = function()
            self:ResetFramePosition()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
end

---Resets all tracked items.
---@param update boolean
function FarmBuddy:ResetItems(update)

    if (self.db.profile.items ~= nil) then
        for k, v in pairs(self.db.profile.items) do
            self.db.profile.items[k] = nil
            self:RemoveItemFrame(v.id)
        end
    end

    -- Remove settings group for item ID
    self:ReindexConfigItems()

    -- Remove frame and redraw
    if (update == true) then
        self:InitItems()
        self:UpdateGUI()

        -- Update settings GUI
        CONFIG_REG:NotifyChange(FARM_BUDDY_ADDON_NAME)
    end
end

---Resets all settings to default.
function FarmBuddy:ResetConfig()
    self:ResetItems(false)
    self.db:ResetProfile()

    -- Remove frame and redraw
    self:InitItems()
    self:UpdateGUI()

    self:SetTitleDisplay()
    self:SetButtonDisplay()
    self:SetFrameLockStatus()
    self:SetBackgroundTransparency()
    self:SetShowFrame()
    self:SetScale()

    -- Update settings GUI
    CONFIG_REG:NotifyChange(FARM_BUDDY_ADDON_NAME)
end

---Sets the item ID and the correct name.
---@param uniqueID string
---@param info table
function FarmBuddy:SetReceivedItemInfo(uniqueID, info)
    self:SetItemProp(uniqueID, 'itemID', info.ItemID, true)
    self:SetItemProp(uniqueID, 'name', info.Name, false)
    self:SetSettingProp(uniqueID, 'item_id', 'name', info.ItemID)

    self:InitItems()
    self:UpdateGUI()

    -- Update settings GUI
    CONFIG_REG:NotifyChange(FARM_BUDDY_ADDON_NAME)
end

---Sets the settings item.
---@param uniqueID string
---@param configKey string
---@param propKey string
---@param value any
function FarmBuddy:SetSettingProp(uniqueID, configKey, propKey, value)

    local options = CONFIG_REG:GetOptionsTable(FARM_BUDDY_ADDON_NAME, 'dialog', 'AceConfigDialog-3.0')
    if (options.args.tab_items.args ~= nil) then
        for k in pairs(options.args.tab_items.args) do

            local prefixCheck = string.sub(k, 1, string.len(ITEM_PREFIX))
            local idCheck = string.sub(k, -string.len(uniqueID))

            if (prefixCheck == ITEM_PREFIX and idCheck == uniqueID) then
                options.args.tab_items.args[k].args[configKey .. '_' .. uniqueID][propKey] = tostring(value)
                break
            end
        end
    end
end

---Shows or hides the addon title bases on the showTitle setting.
function FarmBuddy:SetTitleDisplay()
    if (self.db.profile.settings.showTitle == true) then
        FarmBuddyFrame.Title:Show()
    else
        FarmBuddyFrame.Title:Hide()
    end
end

---Shows or hides the addon buttons bases on the showButtons setting.
function FarmBuddy:SetButtonDisplay()
    if (self.db.profile.settings.showButtons == true) then
        FarmBuddyFrame.AddItemButton:Show()
    else
        FarmBuddyFrame.AddItemButton:Hide()
    end
end

---Set or unset the frame is locked setting.
function FarmBuddy:SetFrameLockStatus()
    FarmBuddyFrame.FrameLock = self.db.profile.settings.frameLocked
end

---Set the background transparency based on the user setting.
function FarmBuddy:SetBackgroundTransparency()
    FarmBuddyFrame:SetBackdropColor(0, 0, 0, self.db.profile.settings.backgroundTransparency)
end

---Sets frame display.
function FarmBuddy:SetShowFrame()
    if (self.db.profile.settings.showFrame == true) then
        FarmBuddyFrame:Show()
    else
        FarmBuddyFrame:Hide()
    end
end

---Toggles frame display.
function FarmBuddy:ToggleShowFrame()
    if (self.db.profile.settings.showFrame == true) then
       FarmBuddyFrame:Hide()
     self.db.profile.settings.showFrame = false
    else
      FarmBuddyFrame:Show()
      self.db.profile.settings.showFrame = true
    end

    -- Update settings GUI
    CONFIG_REG:NotifyChange(FARM_BUDDY_ADDON_NAME)
end

---Resets the main frame to the center of the screen.
function FarmBuddy:ResetFramePosition()
    self.db.profile.framePosition = nil
    FarmBuddyFrame:ClearAllPoints()
    FarmBuddyFrame:SetPoint('CENTER')
end

---Opens the FarmBuddy Settings GUI with focus on the items tab.
---@param button string
function FarmBuddy:AddItemClick(button)
    if (button == 'LeftButton') then
        self:OpenSettings('tab_items')
    end
end

---Opens the FarmBuddy settings GUI.
---@param tab string|nil
function FarmBuddy:OpenSettings(tab)

    Settings.OpenToCategory(self.optionsID)

    if (tab ~= nil) then
        LibStub('AceConfigDialog-3.0'):SelectGroup(FARM_BUDDY_ADDON_NAME, tab)
    end
end

---Fires before changing the profile.
function FarmBuddy:OnProfileShutdown()
    self:ResetItems(false)
end

---Fires after changing the profile.
function FarmBuddy:OnProfileChanged()

    self:InitItems()
    self:SetTitleDisplay()
    self:SetButtonDisplay()
    self:SetFrameLockStatus()
    self:SetBackgroundTransparency()
    self:SetShowFrame()
    self:RestoreFramePosition()

    -- Update GUIs
    CONFIG_REG:NotifyChange(FARM_BUDDY_ADDON_NAME)
    self:UpdateGUI()
end

---Sets the notification sound.
---@param _ table
---@param input number
function FarmBuddy:SetNotificationSound(_, input)
    self:SetSetting('notificationSound', 'number', input, false)
    PlaySound(input, 'master')
end

---Gets the notification sound.
---@return number
function FarmBuddy:GetNotificationSound()
    local sound = self:GetSetting('notificationSound', 'number')
    if not sound or NOTIFICATION_SOUNDS[sound] == nil then
        return SOUNDKIT.ALARM_CLOCK_WARNING_3
    end

    return sound
end
