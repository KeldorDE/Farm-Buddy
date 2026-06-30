---@diagnostic disable: undefined-global

local L = LibStub('AceLocale-3.0'):NewLocale('FarmBuddyStandalone', 'ruRU', false)
if not L then return end

L = L or {}
L["FARM_BUDDY_ABOUT"] = "О аддоне"
L["FARM_BUDDY_ACTIONS"] = "Действия"
L["FARM_BUDDY_ADD_ITEM_DESC"] = "Нажмите кнопку добавления предмета ниже, чтобы добавить новый предмет."
L["FARM_BUDDY_ADD_NEW_ITEM"] = "Добавить новый предмет"
L["FARM_BUDDY_ALERT_COUNT_USAGE"] = "Количество для вашей цели фарминга."
L["FARM_BUDDY_ANCHOR_HELP_TEXT"] = "Удерживайте ЛКМ для перемещения. ПКМ для закрытия."
--[[Translation missing --]]
L["FARM_BUDDY_APPEARANCE"] = "Внешний вид"
L["FARM_BUDDY_AUTHOR"] = "Автор"
L["FARM_BUDDY_BACKGROUND_TRANSPARENCY"] = "Прозрачность фона"
L["FARM_BUDDY_BAR_COLOR_GOAL"] = "Цвет полосы прогресса (цель достигнута)"
L["FARM_BUDDY_BAR_COLOR_NO_GOAL"] = "Цвет полосы прогресса (цель не достигнута)"
L["FARM_BUDDY_BAR_COLOR_NO_QUANTITY"] = "Цвет полосы прогресса (цель не определена)"
L["FARM_BUDDY_BONUS_DISPLAY"] = "Стиль отображения бонуса"
L["FARM_BUDDY_BROKER_TOOLTIP_LINE_1"] = "ЛКМ для переключения отображения рамки Farm Buddy."
L["FARM_BUDDY_BROKER_TOOLTIP_LINE_2"] = "ПКМ для открытия настроек."
L["FARM_BUDDY_CHAT_COMMANDS"] = "Команды чата"
L["FARM_BUDDY_COLORS"] = "Цвета"
L["FARM_BUDDY_COMMAND_GOAL_ARGS"] = "Количество"
L["FARM_BUDDY_COMMAND_GOAL_DESC"] = "Устанавливает количество цели."
L["FARM_BUDDY_COMMAND_GOAL_PARAM_MISSING"] = "Вы должны указать количество как второй параметр."
L["FARM_BUDDY_COMMAND_HELP_DESC"] = "Выводит эту информацию."
L["FARM_BUDDY_COMMAND_LIST"] = "Выводит эту информацию."
L["FARM_BUDDY_COMMAND_RESET_ARGS"] = "все | предметы"
L["FARM_BUDDY_COMMAND_RESET_DESC"] = "Сбрасывает Farm Buddy к настройкам по умолчанию."
L["FARM_BUDDY_COMMAND_SETTINGS_DESC"] = "Открывает страницу настроек аддона."
L["FARM_BUDDY_COMMAND_TOGGLE_DESC"] = "Переключает отображение рамки Farm Buddy."
L["FARM_BUDDY_COMMAND_TRACK_ARGS"] = "ID предмета | Название предмета | Ссылка на предмет"
L["FARM_BUDDY_COMMAND_TRACK_DESC"] = "Устанавливает отслеживаемый предмет."
L["FARM_BUDDY_COMMAND_VERSION_DESC"] = "Показывает текущую используемую версию Farm Buddy."
L["FARM_BUDDY_CONFIG_RESET_MSG"] = "Конфигурация сброшена к значениям по умолчанию."
L["FARM_BUDDY_CONFIRM_ALL_RESET"] = "Вы уверены, что хотите сбросить все настройки к значениям по умолчанию?"
L["FARM_BUDDY_CONFIRM_RESET"] = "Вы уверены, что хотите сбросить все предметы?"
L["FARM_BUDDY_CONFIRM_RESET_FRAME_POSITION"] = "Вы уверены, что хотите сбросить основную рамку в позицию по умолчанию?"
L["FARM_BUDDY_COUNT"] = "Только количество"
L["FARM_BUDDY_COUNT_SINGLE"] = "Количество"
--[[Translation missing --]]
L["FARM_BUDDY_COUNT_WITH_PERCENTAGE"] = "Количество с процентом"
L["FARM_BUDDY_DATA_BROKER"] = "Плагин Broker"
L["FARM_BUDDY_DATA_BROKER_NUM_ITEMS"] = "Количество предметов для показа"
L["FARM_BUDDY_DATA_BROKER_NUM_ITEMS_DESC"] = "Ограничивает количество предметов для отображения в плагине Broker. Если количество установлено в 0, Broker действует как плагин запуска."
L["FARM_BUDDY_DATA_BROKER_SHOW_ITEM_NAME"] = "Показывать название предмета"
L["FARM_BUDDY_ENABLE_DATA_BROKER_SUPPORT"] = "Включить поддержку плагина Broker"
L["FARM_BUDDY_FAST_TRACKING_MOUSE_BUTTON"] = "Кнопка мыши для быстрого отслеживания"
L["FARM_BUDDY_FAST_TRACKING_SHORTCUTS"] = "Сочетания клавиш для быстрого отслеживания"
L["FARM_BUDDY_FAST_TRACKING_SHORTCUTS_DESC"] = "Комбинируйте желаемые клавиши как сочетание для быстрого отслеживания. Быстрое отслеживание позволяет отслеживать предмет из инвентаря с помощью этого сочетания."
L["FARM_BUDDY_FRAME_SCALE"] = "Масштаб рамки"
L["FARM_BUDDY_GERMAN"] = "Немецкий"
L["FARM_BUDDY_GOAL_SET"] = "Количество цели установлено."
L["FARM_BUDDY_HIDE_FRAME_IN_COMBAT"] = "Скрывать рамку в бою"
L["FARM_BUDDY_HIDE_ITEM"] = "Скрыто"
L["FARM_BUDDY_HIDE_ITEM_DESC"] = "Скрыть предмет."
L["FARM_BUDDY_HIDE_ITEM_USAGE"] = "Предмет не будет отображаться в трекере или уведомлениях"
L["FARM_BUDDY_HIDE_NOTIFICATIONS_IN_COMBAT"] = "Скрывать уведомления в бою"
L["FARM_BUDDY_INCLUDE_BANK"] = "Учитывать предметы в банке"
L["FARM_BUDDY_INCLUDE_BANK_DESC"] = "Если включено, предметы в вашем банке будут учитываться при подсчёте фармимых предметов."
L["FARM_BUDDY_INVALID_NUMBER"] = "Показывает уведомление, если достигнуто количество предмета."
L["FARM_BUDDY_ITEM"] = "Предмет"
L["FARM_BUDDY_ITEM_COUNT"] = "Количество предметов"
L["FARM_BUDDY_ITEM_ID"] = "ID предмета"
L["FARM_BUDDY_ITEM_NOT_ON_LIST"] = "Указанный предмет отсутствует в списке отслеживаемых предметов."
L["FARM_BUDDY_ITEM_NOT_SET_MSG"] = "!itemName! уже является одним из ваших отслеживаемых предметов!"
L["FARM_BUDDY_ITEM_SET_MSG"] = "!itemName! добавлен в список."
L["FARM_BUDDY_ITEM_SETTING"] = "ID предмета / Ссылка на предмет / Название предмета"
L["FARM_BUDDY_ITEM_TO_TRACK_DESC"] = "Название предмета для отслеживания"
L["FARM_BUDDY_ITEM_TO_TRACK_USAGE"] = [=[Вы можете отслеживать неизвестные названия предметов, они появятся автоматически, если предмет есть в вашем инвентаре.

Используйте следующий сайт для получения желаемого ID предмета:
- http://www.wowhead.com]=]
L["FARM_BUDDY_ITEMS"] = "Предметы"
--[[Translation missing --]]
L["FARM_BUDDY_KEY_ALT"] = "Alt"
--[[Translation missing --]]
L["FARM_BUDDY_KEY_CTRL"] = "CTRL"
--[[Translation missing --]]
L["FARM_BUDDY_KEY_LEFT_MOUSE_BUTTON"] = "Left mouse button"
--[[Translation missing --]]
L["FARM_BUDDY_KEY_RIGHT_MOUSE_BUTTON"] = "Right mouse button"
--[[Translation missing --]]
L["FARM_BUDDY_KEY_SHIFT"] = "Shift"
--[[Translation missing --]]
L["FARM_BUDDY_LOCALIZATION"] = "Localization"
--[[Translation missing --]]
L["FARM_BUDDY_LOCK_FRAME"] = "Lock frame"
--[[Translation missing --]]
L["FARM_BUDDY_LOCK_FRAME_DESC"] = "When this option is active the frame is locked at it's place an can't be moved."
--[[Translation missing --]]
L["FARM_BUDDY_MOVE_NOTIFICATION"] = "Change Notification Position"
--[[Translation missing --]]
L["FARM_BUDDY_MOVE_NOTIFICATION_DESC"] = "Change the Position of the Notification Frame."
--[[Translation missing --]]
L["FARM_BUDDY_NAME"] = "Name"
--[[Translation missing --]]
L["FARM_BUDDY_NO"] = "No"
--[[Translation missing --]]
L["FARM_BUDDY_NO_TRACKED_ITEMS"] = "No tracked items"
--[[Translation missing --]]
L["FARM_BUDDY_NOTIFICATION"] = "Enable Notifications"
--[[Translation missing --]]
L["FARM_BUDDY_NOTIFICATION_DEMO_ITEM_NAME"] = "Hearthstone"
--[[Translation missing --]]
L["FARM_BUDDY_NOTIFICATION_DESC"] = "Shows an notification if the item quantity has reached."
--[[Translation missing --]]
L["FARM_BUDDY_NOTIFICATION_GLOW"] = "Show Glow Effect"
--[[Translation missing --]]
L["FARM_BUDDY_NOTIFICATION_GLOW_DESC"] = "Shows a glow effect if a notification is shown."
--[[Translation missing --]]
L["FARM_BUDDY_NOTIFICATION_SHINE"] = "Show Shine Effect"
--[[Translation missing --]]
L["FARM_BUDDY_NOTIFICATION_SHINE_DESC"] = "Shows a shine effect if a notification is shown."
--[[Translation missing --]]
L["FARM_BUDDY_NOTIFICATION_SOUND"] = "Notification Sound"
--[[Translation missing --]]
L["FARM_BUDDY_NOTIFICATIONS"] = "Notifications"
--[[Translation missing --]]
L["FARM_BUDDY_PERCENT"] = "Percent"
--[[Translation missing --]]
L["FARM_BUDDY_PERCENTAGE"] = "Percentage only"
--[[Translation missing --]]
L["FARM_BUDDY_PLAY_NOTIFICATION_DISPLAY_DURATION"] = "Notification Display Duration"
--[[Translation missing --]]
L["FARM_BUDDY_PLAY_NOTIFICATION_DISPLAY_DURATION_DESC"] = "The Notification Display Duration in seconds."
--[[Translation missing --]]
L["FARM_BUDDY_PLAY_NOTIFICATION_SOUND"] = "Play Notification Sound"
--[[Translation missing --]]
L["FARM_BUDDY_PLAY_NOTIFICATION_SOUND_DESC"] = "Play a notification sound file if the farm goal has reached."
--[[Translation missing --]]
L["FARM_BUDDY_PROGRESS_DISPLAY"] = "Progress display style"
--[[Translation missing --]]
L["FARM_BUDDY_QUANTITY"] = "Quantity"
--[[Translation missing --]]
L["FARM_BUDDY_RARITY"] = "Rarity"
--[[Translation missing --]]
L["FARM_BUDDY_REMOVE_ITEM"] = "Remove item"
--[[Translation missing --]]
L["FARM_BUDDY_REMOVE_ITEM_DESC"] = "Removes this item from the list."
--[[Translation missing --]]
L["FARM_BUDDY_RESET"] = "Reset"
--[[Translation missing --]]
L["FARM_BUDDY_RESET_ALL"] = "Reset settings to default"
--[[Translation missing --]]
L["FARM_BUDDY_RESET_ALL_DESC"] = "Reset all settings to default values."
--[[Translation missing --]]
L["FARM_BUDDY_RESET_ALL_ITEMS"] = "Reset all tracked Items"
--[[Translation missing --]]
L["FARM_BUDDY_RESET_ALL_ITEMS_DESC"] = "Resets all tracked items."
--[[Translation missing --]]
L["FARM_BUDDY_RESET_DESC"] = "Resets the tracked item."
--[[Translation missing --]]
L["FARM_BUDDY_RESET_FRAME_POSITION"] = "Reset main frame to default position"
--[[Translation missing --]]
L["FARM_BUDDY_RESET_FRAME_POSITION_DESC"] = "Reset the main frame position to the default position. This action is very useful if the frame is not draggable because it is blocked by another frame for example."
--[[Translation missing --]]
L["FARM_BUDDY_SETTINGS"] = "Common"
--[[Translation missing --]]
L["FARM_BUDDY_SHORTCUTS"] = "Shortcuts"
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_BONUS"] = "Show bonus behind item goal"
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_BONUS_DESC"] = "Shows a bonus value behind the tracking goal. The bonus is the amount over your defined goal."
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_BUTTONS"] = "Show buttons"
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_BUTTONS_DESC"] = "Show the action buttons on the titles right handed side."
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_FRAME"] = "Show frame"
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_GOAL"] = "Show Goal next to the item count"
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_GOAL_INDICATOR"] = "Show goal indicator"
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_GOAL_INDICATOR_DESC"] = "Shows the item count in green color and adds a check mark before the item count."
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_PROGRESS_BAR"] = "Show progress bar"
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_PROGRESS_BAR_DESC"] = "Shows a progress bar under the item name."
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_TITLE"] = "Show title"
--[[Translation missing --]]
L["FARM_BUDDY_SHOW_TITLE_DESC"] = "Show the title above the item frame."
--[[Translation missing --]]
L["FARM_BUDDY_SORT_ASC"] = "Ascending"
--[[Translation missing --]]
L["FARM_BUDDY_SORT_BY"] = "Sort items by"
--[[Translation missing --]]
L["FARM_BUDDY_SORT_DESC"] = "Descending"
--[[Translation missing --]]
L["FARM_BUDDY_SORT_ORDER"] = "Sort order"
--[[Translation missing --]]
L["FARM_BUDDY_SUPPORT"] = "Support"
--[[Translation missing --]]
L["FARM_BUDDY_SUPPORT_TEXT"] = "patreon.com/c/keldor"
--[[Translation missing --]]
L["FARM_BUDDY_TEST_NOTIFICATION"] = "Test Notification"
--[[Translation missing --]]
L["FARM_BUDDY_TEST_NOTIFICATION_DESC"] = "Triggers a test for the finish notification."
--[[Translation missing --]]
L["FARM_BUDDY_TRACK_ITEM_PARAM_MISSING"] = "You have to set an Item Name or Item Link as second parameter."
--[[Translation missing --]]
L["FARM_BUDDY_VERSION"] = "Version"
--[[Translation missing --]]
L["FARM_BUDDY_WAITING_FOR_DATA"] = "Waiting for data"
--[[Translation missing --]]
L["FARM_BUDDY_YES"] = "Yes"
