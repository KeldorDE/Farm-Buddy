local L = LibStub('AceLocale-3.0'):NewLocale('FarmBuddyStandalone', 'deDE', false)
if not L then return end

L = L or {}
L["FARM_BUDDY_ABOUT"] = "Über"
L["FARM_BUDDY_ACTIONS"] = "Aktionen"
L["FARM_BUDDY_ADD_ITEM_DESC"] = "Klicke auf den \"Gegenstand hinzufügen\"-Button, um einen weiteren Gegenstand hinzuzufügen."
L["FARM_BUDDY_ADD_NEW_ITEM"] = "Gegenstand hinzufügen"
L["FARM_BUDDY_ALERT_COUNT_USAGE"] = "Die gewünschte Anzahl des beobachteten Gegenstands."
L["FARM_BUDDY_ANCHOR_HELP_TEXT"] = "Linke Maustaste halten zum Bewegen. Rechtsklick zum Schließen."
L["FARM_BUDDY_APPERANCE"] = "Ansicht"
L["FARM_BUDDY_AUTHOR"] = "Autor"
L["FARM_BUDDY_BACKGROUND_TRANSPARENCY"] = "Transparenz des Hintergrunds"
L["FARM_BUDDY_BAR_COLOR_GOAL"] = "Fortschrittsbalken Farbe (Ziel erreicht)"
L["FARM_BUDDY_BAR_COLOR_NO_GOAL"] = "Fortschrittsbalken Farbe (Ziel nicht erreicht)"
L["FARM_BUDDY_BAR_COLOR_NO_QUANTITY"] = "Fortschrittsbalken Farbe (Kein Ziel definiert)"
L["FARM_BUDDY_BONUS_DISPLAY"] = "Anzeigeart des Bonus"
L["FARM_BUDDY_BROKER_TOOLTIP_LINE_1"] = "Linksklick, um die Anzeige des Farm Buddy Fensters umzuschalten."
L["FARM_BUDDY_BROKER_TOOLTIP_LINE_2"] = "Rechtsklick, um die Einstellungen zu öffnen."
L["FARM_BUDDY_CHAT_COMMANDS"] = "Chat Befehle"
L["FARM_BUDDY_COLORS"] = "Farben"
L["FARM_BUDDY_COMMAND_GOAL_ARGS"] = "Anzahl"
L["FARM_BUDDY_COMMAND_GOAL_DESC"] = "Setzt die Anzahl der Gegenstände die für das Erreichen des Ziels benötigt werden."
L["FARM_BUDDY_COMMAND_GOAL_PARAM_MISSING"] = "Du musst eine Anzahl als zweiten Parameter übergeben."
L["FARM_BUDDY_COMMAND_HELP_DESC"] = "Zeigt diese Hilfe an."
L["FARM_BUDDY_COMMAND_LIST"] = "Zeigt diese Hilfe an."
L["FARM_BUDDY_COMMAND_RESET_ARGS"] = "all | items"
L["FARM_BUDDY_COMMAND_RESET_DESC"] = "Setzt die Farm Buddy Einstellungen auf die Standardwerte zurück."
L["FARM_BUDDY_COMMAND_SETTINGS_DESC"] = "Öffnet das Fenster mit den AddOn Einstellung."
L["FARM_BUDDY_COMMAND_TOGGLE_DESC"] = "Schaltet die Sichtbarkeit des Hauptfensters um."
L["FARM_BUDDY_COMMAND_TRACK_ARGS"] = "Gegenstands ID | Gegenstands Link | Gegentandsname"
L["FARM_BUDDY_COMMAND_TRACK_DESC"] = "Setzt den beobachteten Gegenstand."
L["FARM_BUDDY_COMMAND_VERSION_DESC"] = "Zeigt die aktuell verwendete Farm Buddy Version an."
L["FARM_BUDDY_CONFIG_RESET_MSG"] = "Die Konfiguration wurde auf die Standardwerte zurückgesetzt."
L["FARM_BUDDY_CONFIRM_ALL_RESET"] = "Bist du sicher, dass du alle Einstellungen auf die Standardwerte zurücksetzen möchtest?"
L["FARM_BUDDY_CONFIRM_RESET"] = "Bist du sicher, dass du alle beobachteten Gegenstände zurücksetzen möchtest?"
L["FARM_BUDDY_CONFIRM_RESET_FRAME_POSITION"] = "Bist du sicher, dass du das Hauptfenster auf die Standardposition zurücksetzen möchtest?"
L["FARM_BUDDY_COUNT"] = "Nur Anzahl"
L["FARM_BUDDY_COUNT_SINGLE"] = "Anzahl"
L["FARM_BUDDY_COUNT_WITH_PERCENATGE"] = "Anzahl und Prozent"
L["FARM_BUDDY_DATA_BROKER"] = "Broker Plugin"
L["FARM_BUDDY_DATA_BROKER_NUM_ITEMS"] = "Anzahl anzuzeigender Gegenstände"
L["FARM_BUDDY_DATA_BROKER_NUM_ITEMS_DESC"] = "Legt die Anzahl der im Data Broker Plugin anzuzeigenden Gegenstände fest. Wenn der Wert auf 0 gesetzt wird, interagiert der Data Broker als Launcher."
L["FARM_BUDDY_DATA_BROKER_SHOW_ITEM_NAME"] = "Gegenstandsnamen anzeigen"
L["FARM_BUDDY_ENABLE_DATA_BROKER_SUPPORT"] = "Broker Plugin Unterstützung aktivieren"
L["FARM_BUDDY_FAST_TRACKING_MOUSE_BUTTON"] = "Maustaste für die Schnellerfassung"
L["FARM_BUDDY_FAST_TRACKING_SHORTCUTS"] = "Tastenkürzel der Schnellerfassung"
L["FARM_BUDDY_FAST_TRACKING_SHORTCUTS_DESC"] = "Kombiniere deine gewünschten Tasten zu eine Schnellerfassungs-Tastenkürzel. Mithilfe des Tastenkürzels kannst du einen Gegenstand aus deinem Inventar sofort zur Liste hinzufügen."
L["FARM_BUDDY_FRAME_SCALE"] = "Fenstergröße"
L["FARM_BUDDY_GERMAN"] = "Deutsch"
L["FARM_BUDDY_GOAL_SET"] = "Das neue Ziel wurde erfolgreich gesetzt."
L["FARM_BUDDY_HIDE_FRAME_IN_COMBAT"] = "Fenster im Kampf ausblenden"
L["FARM_BUDDY_HIDE_ITEM"] = "Versteckt"
L["FARM_BUDDY_HIDE_ITEM_DESC"] = "Gegenstand ausblenden"
L["FARM_BUDDY_HIDE_ITEM_USAGE"] = "Gegenstand wird nicht im Tracker oder in den Benachrichtigungen angezeigt"
L["FARM_BUDDY_HIDE_NOTIFICATIONS_IN_COMBAT"] = "Zeige keine Benachrichtigungen im Kampf an"
L["FARM_BUDDY_INCLUDE_BANK"] = "Gegenstände in der Bank zählen"
L["FARM_BUDDY_INCLUDE_BANK_DESC"] = "Wenn diese Option aktiviert ist, werden die Gegenstände in der Bank des aktiven Charakters zur Gesamtanzahl hinzuaddiert."
L["FARM_BUDDY_INVALID_NUMBER"] = "Zeigt eine Benachrichtigung an, sobald das eingestellte Ziel erreicht wurde."
L["FARM_BUDDY_ITEM"] = "Gegenstand"
L["FARM_BUDDY_ITEM_COUNT"] = "Anzahl der Gegenstände"
L["FARM_BUDDY_ITEM_ID"] = "Item ID"
L["FARM_BUDDY_ITEM_NOT_ON_LIST"] = "Der angegebene Gegenstand ist nicht in der Liste beobachteter Gegenstände."
L["FARM_BUDDY_ITEM_NOT_SET_MSG"] = "!itemName! ist bereits in der Liste."
L["FARM_BUDDY_ITEM_SET_MSG"] = "!itemName! wurde der Liste hinzugefügt."
L["FARM_BUDDY_ITEM_SETTING"] = "Item ID / Item Link / Gegenstandsname"
L["FARM_BUDDY_ITEM_TO_TRACK_DESC"] = "Der Names des Gegenstands der Beobachtet werden soll"
L["FARM_BUDDY_ITEM_TO_TRACK_USAGE"] = [=[Es wird empfohlen einen Item Link oder die Item ID zu verwenden. Sollte ein Gegenstandsname verwendet werden, wird der Gegenstand erst in der Liste auftauchen, sobald dieser in der aktuellen Sitzung vom Spieler gesehen wurde.

Du kannst allerdings auch nicht bekannte Gegenstände aufnehmen, diese erscheinen automatisch in der Liste, sobald du diese das erste Mal im Inventar hast.

Die Item ID kann auf folgenden Seiten gefunden werden:
- http://de.wowhead.com
- http://wowdata.buffed.de]=]
L["FARM_BUDDY_ITEMS"] = "Gegenstände"
L["FARM_BUDDY_KEY_ALT"] = "Alt"
L["FARM_BUDDY_KEY_CTRL"] = "Strg"
L["FARM_BUDDY_KEY_LEFT_MOUSE_BUTTON"] = "Linke Maustaste"
L["FARM_BUDDY_KEY_RIGHT_MOUSE_BUTTON"] = "Rechte Maustaste"
L["FARM_BUDDY_KEY_SHIFT"] = "Shift"
L["FARM_BUDDY_LOCALIZATION"] = "Übersetzungen"
L["FARM_BUDDY_LOCK_FRAME"] = "Fenster sperren"
L["FARM_BUDDY_LOCK_FRAME_DESC"] = "Sperrt das Verschieben des Farm Buddy Fensters."
L["FARM_BUDDY_MOVE_NOTIFICATION"] = "Position der Benachrichtigung anpassen"
L["FARM_BUDDY_MOVE_NOTIFICATION_DESC"] = "Ermöglicht die Anpassung der Position der Benachrichtigung."
L["FARM_BUDDY_NAME"] = "Name"
L["FARM_BUDDY_NO"] = "Nein"
L["FARM_BUDDY_NO_TRACKED_ITEMS"] = "Keine Gegenstände zum Anzeigen"
L["FARM_BUDDY_NOTIFICATION"] = "Benachrichtigungen aktivieren"
L["FARM_BUDDY_NOTIFICATION_DEMO_ITEM_NAME"] = "Ruhestein"
L["FARM_BUDDY_NOTIFICATION_DESC"] = "Zeigt eine Benachrichtigung an, sobald das eingestellte Ziel erreicht wurde."
L["FARM_BUDDY_NOTIFICATION_GLOW"] = "Glühen Effekt verwenden"
L["FARM_BUDDY_NOTIFICATION_GLOW_DESC"] = "Zeigt einen glühenden Effekt an, wenn eine Benachrichtigung angezeigt wird."
L["FARM_BUDDY_NOTIFICATION_SHINE"] = "Strahlenden Effekt anzeigen"
L["FARM_BUDDY_NOTIFICATION_SHINE_DESC"] = "Zeigt einen Strahlenden Effekt an, wenn eine Benachrichtigung angezeigt wird."
L["FARM_BUDDY_NOTIFICATION_SOUND"] = "Benachrichtigungston"
L["FARM_BUDDY_NOTIFICATIONS"] = "Benachrichtigungen"
L["FARM_BUDDY_PERCENT"] = "Prozent"
L["FARM_BUDDY_PERCENTAGE"] = "Nur Prozent"
L["FARM_BUDDY_PLAY_NOTIFICATION_DISPLAY_DURATION"] = "Anzeigedauer von Benachrichtigungen"
L["FARM_BUDDY_PLAY_NOTIFICATION_DISPLAY_DURATION_DESC"] = "Legt die Anzeigedauer von Benachrichtigungen in Sekunden fest."
L["FARM_BUDDY_PLAY_NOTIFICATION_SOUND"] = "Benachrichtigungston abspielen"
L["FARM_BUDDY_PLAY_NOTIFICATION_SOUND_DESC"] = "Spiele einen Benachrichtigungston ab, sobald das Ziel erreicht wurde."
L["FARM_BUDDY_PROGRESS_DISPLAY"] = "Anzeigeformat des Fortschritts"
L["FARM_BUDDY_QUANTITY"] = "Anzahl"
L["FARM_BUDDY_RARITY"] = "Qualität"
L["FARM_BUDDY_REMOVE_ITEM"] = "Gegenstand entfernen"
L["FARM_BUDDY_REMOVE_ITEM_DESC"] = "Entfernt diesen Gegenstand aus der Liste."
L["FARM_BUDDY_RESET"] = "Zurücksetzen"
L["FARM_BUDDY_RESET_ALL"] = "Einstellungen auf Standardwerte zurücksetzen"
L["FARM_BUDDY_RESET_ALL_DESC"] = "Setzt alle AddOn Einstellungen auf die Standardwerte zurück."
L["FARM_BUDDY_RESET_ALL_ITEMS"] = "Alle beobachteten Gegenstände zurücksetzen"
L["FARM_BUDDY_RESET_ALL_ITEMS_DESC"] = "Setzt alle beobachteten Gegenstände zurück."
L["FARM_BUDDY_RESET_DESC"] = "Setzt die Fortschrittsverfolgung des Gegenstands zurück."
L["FARM_BUDDY_RESET_FRAME_POSITION"] = "Hauptfenster auf Standardposition zurücksetzen"
L["FARM_BUDDY_RESET_FRAME_POSITION_DESC"] = "Setzt das Hauptfenster auf die Standardposition zurück. Diese Aktion ist oft nützlich, wenn das Fenster z.B. hinter einem anderen Fenster liegt."
L["FARM_BUDDY_SETTINGS"] = "Allgemein"
L["FARM_BUDDY_SHORTCUTS"] = "Tastenkürzel"
L["FARM_BUDDY_SHOW_BONUS"] = "Zeige den Bonus hinter dem Ziel"
L["FARM_BUDDY_SHOW_BONUS_DESC"] = "Zeige den Bonus hinter dem Ziel an. Der Bonus ist der Wert, der über dem definierten Ziel liegt."
L["FARM_BUDDY_SHOW_BUTTONS"] = "Zeige Buttons"
L["FARM_BUDDY_SHOW_BUTTONS_DESC"] = "Buttons rechts neben dem Titel anzeigen."
L["FARM_BUDDY_SHOW_FRAME"] = "Fenster anzeigen"
L["FARM_BUDDY_SHOW_GOAL"] = "Zeige das gesetzte Ziel neben der Anzahl der Gegenstände."
L["FARM_BUDDY_SHOW_GOAL_INDICATOR"] = "Markiere abgeschlossene Ziele"
L["FARM_BUDDY_SHOW_GOAL_INDICATOR_DESC"] = "Zeigt die Anzahl der Gegenstände mit einem Haken und grünem Text an, wenn die Zielvorgabe erreicht wurde."
L["FARM_BUDDY_SHOW_PROGRESS_BAR"] = "Fortschrittsbalken anzeigen"
L["FARM_BUDDY_SHOW_PROGRESS_BAR_DESC"] = "Zeigt einen Fortschrittsbalken unter dem Gegenstandsnamen an."
L["FARM_BUDDY_SHOW_TITLE"] = "Titel anzeigen"
L["FARM_BUDDY_SHOW_TITLE_DESC"] = "Legt fest, ob der Titel über dem Addon Fenster angezeigt werden soll."
L["FARM_BUDDY_SORT_ASC"] = "Aufsteigend"
L["FARM_BUDDY_SORT_BY"] = "Sortiere Gegenstände nach"
L["FARM_BUDDY_SORT_DESC"] = "Absteigend"
L["FARM_BUDDY_SORT_ORDER"] = "Sortierung von Gegenständen"
L["FARM_BUDDY_SUPPORT"] = "Unterstützung"
L["FARM_BUDDY_SUPPORT_TEXT"] = "patreon.com/eso_database_com"
L["FARM_BUDDY_TEST_NOTIFICATION"] = "Benachrichtigung testen"
L["FARM_BUDDY_TEST_NOTIFICATION_DESC"] = "Löst einen Test der Benachrichtigung bei Erreichen des eingestellten Ziels aus."
L["FARM_BUDDY_TRACK_ITEM_PARAM_MISSING"] = "Du musst einen Gegenstandsnamen oder einen Gegenstands Link als zweiten Parameter übergeben."
L["FARM_BUDDY_VERSION"] = "Version"
L["FARM_BUDDY_WAITING_FOR_DATA"] = "Warte auf Daten"
L["FARM_BUDDY_YES"] = "Ja"
