local L = LibStub('AceLocale-3.0'):NewLocale('FarmBuddyStandalone', 'enUS', true)
if not L then return end

L = L or {}
L["FARM_BUDDY_ABOUT"] = "About"
L["FARM_BUDDY_ACTIONS"] = "Actions"
L["FARM_BUDDY_ADD_ITEM_DESC"] = "Click the add item button below to add a new item."
L["FARM_BUDDY_ADD_NEW_ITEM"] = "Add new item"
L["FARM_BUDDY_ALERT_COUNT_USAGE"] = "An quantity for your farming goal."
L["FARM_BUDDY_ANCHOR_HELP_TEXT"] = "Hold left mouse button to move. Right click to close."
L["FARM_BUDDY_APPERANCE"] = "Appearance"
L["FARM_BUDDY_AUTHOR"] = "Author"
L["FARM_BUDDY_BACKGROUND_TRANSPARENCY"] = "Background transparency"
L["FARM_BUDDY_BAR_COLOR_GOAL"] = "Progress bar color (goal reached)"
L["FARM_BUDDY_BAR_COLOR_NO_GOAL"] = "Progress bar color (Goal not reached)"
L["FARM_BUDDY_BAR_COLOR_NO_QUANTITY"] = "Progress bar color (No goal defined)"
L["FARM_BUDDY_BONUS_DISPLAY"] = "Bonus display style"
L["FARM_BUDDY_BROKER_TOOLTIP_LINE_1"] = "Left click to toggle the Farm Buddy frame display."
L["FARM_BUDDY_BROKER_TOOLTIP_LINE_2"] = "Right click to open the settings."
L["FARM_BUDDY_CHAT_COMMANDS"] = "Chat Commands"
L["FARM_BUDDY_COLORS"] = "Colors"
L["FARM_BUDDY_COMMAND_GOAL_ARGS"] = "Quantity"
L["FARM_BUDDY_COMMAND_GOAL_DESC"] = "Sets the goal quantity."
L["FARM_BUDDY_COMMAND_GOAL_PARAM_MISSING"] = "You have to set a quantity as second parameter."
L["FARM_BUDDY_COMMAND_HELP_DESC"] = "Prints this information."
L["FARM_BUDDY_COMMAND_LIST"] = "Prints this information."
L["FARM_BUDDY_COMMAND_RESET_ARGS"] = "all | items"
L["FARM_BUDDY_COMMAND_RESET_DESC"] = "Resets Farm Buddy to it's default settings."
L["FARM_BUDDY_COMMAND_SETTINGS_DESC"] = "Open up the AddOn settings page."
L["FARM_BUDDY_COMMAND_TRACK_ARGS"] = "Item ID | Item Name | Item Link"
L["FARM_BUDDY_COMMAND_TRACK_DESC"] = "Sets the tracked item."
L["FARM_BUDDY_COMMAND_VERSION_DESC"] = "Show the current used Farm Buddy Version."
L["FARM_BUDDY_CONFIG_RESET_MSG"] = "The configuration has been set back to the defaults."
L["FARM_BUDDY_CONFIRM_ALL_RESET"] = "Are you sure you want to reset all settings to default values?"
L["FARM_BUDDY_CONFIRM_RESET"] = "Are you sure you want to reset all items?"
L["FARM_BUDDY_CONFIRM_RESET_FRAME_POSITION"] = "Are you sure you want to reset the main frame to it's default position?"
L["FARM_BUDDY_COUNT"] = "Count only"
L["FARM_BUDDY_COUNT_SINGLE"] = "Count"
L["FARM_BUDDY_COUNT_WITH_PERCENATGE"] = "Count with percentage"
L["FARM_BUDDY_DATA_BROKER"] = "Broker Plugin"
L["FARM_BUDDY_DATA_BROKER_SHOW_ITEM_NAME"] = "Show item name"
L["FARM_BUDDY_ENABLE_DATA_BROKER_SUPPORT"] = "Enable broker plugin support"
L["FARM_BUDDY_FAST_TRACKING_MOUSE_BUTTON"] = "Fast tracking mouse button"
L["FARM_BUDDY_FAST_TRACKING_SHORTCUTS"] = "Fast tracking shortcuts"
L["FARM_BUDDY_FAST_TRACKING_SHORTCUTS_DESC"] = "Combine your desired keys as a fast tracking shortcut. Fast tracking allows you to track an item from your inventory with these shortcut."
L["FARM_BUDDY_GERMAN"] = "German"
L["FARM_BUDDY_GOAL_SET"] = "The goal quantity has been set."
L["FARM_BUDDY_HIDE_FRAME_IN_COMBAT"] = "Hide frame in combat"
L["FARM_BUDDY_HIDE_NOTIFICATIONS_IN_COMBAT"] = "Hide notifications in combat"
L["FARM_BUDDY_INCLUDE_BANK"] = "Include items in your bank"
L["FARM_BUDDY_INCLUDE_BANK_DESC"] = "If enabled items in your bank are included when counting the farmed item."
L["FARM_BUDDY_INVALID_NUMBER"] = "Shows a notification if the item quantity has reached."
L["FARM_BUDDY_ITEM"] = "Item"
L["FARM_BUDDY_ITEM_COUNT"] = "Item Count"
L["FARM_BUDDY_ITEM_ID"] = "Item ID"
L["FARM_BUDDY_ITEM_NOT_ON_LIST"] = "The given item is not in the list of tracked items."
L["FARM_BUDDY_ITEM_NOT_SET_MSG"] = "The !itemName! is already one of your tracked items!"
L["FARM_BUDDY_ITEM_SET_MSG"] = "!itemName! has been added to the list."
L["FARM_BUDDY_ITEM_SETTING"] = "Item ID / Item Link / Item name"
L["FARM_BUDDY_ITEM_TO_TRACK_DESC"] = "The name of the item to track"
L["FARM_BUDDY_ITEM_TO_TRACK_USAGE"] = [=[It's recommended to use the item ID or the item link. If you use the item name the item will show up in the list until you have seen the item in the current play session.

You can track unknown item names they will appear automaticly if you have the item in your inventory.

Use the following site to obtain the desired item ID:
- http://www.wowhead.com]=]
L["FARM_BUDDY_ITEMS"] = "Items"
L["FARM_BUDDY_KEY_ALT"] = "Alt"
L["FARM_BUDDY_KEY_CTRL"] = "CTRL"
L["FARM_BUDDY_KEY_LEFT_MOUSE_BUTTON"] = "Left mouse button"
L["FARM_BUDDY_KEY_RIGHT_MOUSE_BUTTON"] = "Right mouse button"
L["FARM_BUDDY_KEY_SHIFT"] = "Shift"
L["FARM_BUDDY_LOCALIZATION"] = "Localization"
L["FARM_BUDDY_LOCK_FRAME"] = "Lock frame"
L["FARM_BUDDY_LOCK_FRAME_DESC"] = "When this option is active the frame is locked at it's place an can't be moved."
L["FARM_BUDDY_MOVE_NOTIFICATION"] = "Change Notification Position"
L["FARM_BUDDY_MOVE_NOTIFICATION_DESC"] = "Change the Position of the Notification Frame."
L["FARM_BUDDY_NAME"] = "Name"
L["FARM_BUDDY_NO"] = "No"
L["FARM_BUDDY_NO_TRACKED_ITEMS"] = "No tracked items"
L["FARM_BUDDY_NOTIFICATION"] = "Enable Notifications"
L["FARM_BUDDY_NOTIFICATION_DEMO_ITEM_NAME"] = "Hearthstone"
L["FARM_BUDDY_NOTIFICATION_DESC"] = "Shows an notification if the item quantity has reached."
L["FARM_BUDDY_NOTIFICATION_GLOW"] = "Show Glow Effect"
L["FARM_BUDDY_NOTIFICATION_GLOW_DESC"] = "Shows a glow effect if a notification is shown."
L["FARM_BUDDY_NOTIFICATION_SHINE"] = "Show Shine Effect"
L["FARM_BUDDY_NOTIFICATION_SHINE_DESC"] = "Shows a shine effect if a notification is shown."
L["FARM_BUDDY_NOTIFICATION_SOUND"] = "Notification Sound"
L["FARM_BUDDY_NOTIFICATIONS"] = "Notifications"
L["FARM_BUDDY_PERCENT"] = "Percent"
L["FARM_BUDDY_PERCENTAGE"] = "Percentage only"
L["FARM_BUDDY_PLAY_NOTIFICATION_DISPLAY_DURATION"] = "Notification Display Duration"
L["FARM_BUDDY_PLAY_NOTIFICATION_DISPLAY_DURATION_DESC"] = "The Notification Display Duration in seconds."
L["FARM_BUDDY_PLAY_NOTIFICATION_SOUND"] = "Play Notification Sound"
L["FARM_BUDDY_PLAY_NOTIFICATION_SOUND_DESC"] = "Play a notification sound file if the farm goal has reached."
L["FARM_BUDDY_PROGRESS_DISPLAY"] = "Progress display style"
L["FARM_BUDDY_QUANTITY"] = "Quantity"
L["FARM_BUDDY_RARITY"] = "Rarity"
L["FARM_BUDDY_REMOVE_ITEM"] = "Remove item"
L["FARM_BUDDY_REMOVE_ITEM_DESC"] = "Removes this item from the list."
L["FARM_BUDDY_RESET"] = "Reset"
L["FARM_BUDDY_RESET_ALL"] = "Reset settings to default"
L["FARM_BUDDY_RESET_ALL_DESC"] = "Reset all settings to default values."
L["FARM_BUDDY_RESET_ALL_ITEMS"] = "Reset all tracked Items"
L["FARM_BUDDY_RESET_ALL_ITEMS_DESC"] = "Resets all tracked items."
L["FARM_BUDDY_RESET_DESC"] = "Resets the tracked item."
L["FARM_BUDDY_RESET_FRAME_POSITION"] = "Reset main frame to default position"
L["FARM_BUDDY_RESET_FRAME_POSITION_DESC"] = "Reset the main frame position to the default position. This action is very useful if the frame is not draggable because it is blocked by another frame for example."
L["FARM_BUDDY_SETTINGS"] = "Common"
L["FARM_BUDDY_SHORTCUTS"] = "Shortcuts"
L["FARM_BUDDY_SHOW_BONUS"] = "Show bonus behind item goal"
L["FARM_BUDDY_SHOW_BONUS_DESC"] = "Shows a bonus value behind the tracking goal. The bonus is the amount over your defined goal."
L["FARM_BUDDY_SHOW_BUTTONS"] = "Show buttons"
L["FARM_BUDDY_SHOW_BUTTONS_DESC"] = "Show the action buttons on the titles right handed side."
L["FARM_BUDDY_SHOW_FRAME"] = "Show frame"
L["FARM_BUDDY_SHOW_GOAL"] = "Show Goal next to the item count"
L["FARM_BUDDY_SHOW_GOAL_INDICATOR"] = "Show goal indicator"
L["FARM_BUDDY_SHOW_GOAL_INDICATOR_DESC"] = "Shows the item count in green color and adds a check mark before the item count."
L["FARM_BUDDY_SHOW_PROGRESS_BAR"] = "Show progress bar"
L["FARM_BUDDY_SHOW_PROGRESS_BAR_DESC"] = "Shows a progress bar under the item name."
L["FARM_BUDDY_SHOW_TITLE"] = "Show title"
L["FARM_BUDDY_SHOW_TITLE_DESC"] = "Show the title above the item frame."
L["FARM_BUDDY_SORT_ASC"] = "Ascending"
L["FARM_BUDDY_SORT_BY"] = "Sort items by"
L["FARM_BUDDY_SORT_DESC"] = "Descending"
L["FARM_BUDDY_SORT_ORDER"] = "Sort order"
L["FARM_BUDDY_TEST_NOTIFICATION"] = "Test Notification"
L["FARM_BUDDY_TEST_NOTIFICATION_DESC"] = "Triggers a test for the finish notification."
L["FARM_BUDDY_TRACK_ITEM_PARAM_MISSING"] = "You have to set an Item Name or Item Link as second parameter."
L["FARM_BUDDY_VERSION"] = "Version"
L["FARM_BUDDY_WAITING_FOR_DATA"] = "Waiting for data"
L["FARM_BUDDY_YES"] = "Yes"
