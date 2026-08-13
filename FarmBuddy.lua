---@diagnostic disable: undefined-global
-- **************************************************************************
-- * FarmBuddy.lua
-- *
-- * By: Keldor
-- **************************************************************************

local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true)
local FarmBuddy = LibStub('AceAddon-3.0'):NewAddon(FARM_BUDDY_ID, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0')
local ITEM_DATA_INIT_COMPLETE = false
local NOTIFICATION_QUEUE = {}
local NOTIFICATION_TRIGGERED = {}
local ITEM_STORAGE = {}
local ITEM_FRAMES = {}
local PLAYER_IN_COMBAT = false
local DEFAULTS = {
    profile = {
        items = {},
        settings = {
            showFrame = true,
            showTitle = true,
            showIcon = true,
            showQuantity = true,
            includeBank = false,
            includeWarbandBank = false,
            goalNotification = true,
            chatGoalNotifications = false,
            notificationDisplayDuration = 5,
            notificationGlow = true,
            notificationShine = true,
            playNotificationSound = true,
            notificationSound = SOUNDKIT.ALARM_CLOCK_WARNING_3,
            frameLocked = false,
            showButtons = true,
            showGoalIndicator = true,
            showProgressBar = true,
            progressStyle = 'CountPercentage',
            progressBarNoGoalColor = { r = 1, g = .8, b = 0, a = 1 },
            progressBarGoalColor = { r = 0, g = .6, b = 0, a = 1 },
            progressBarNoQuantityColor = { r = 0, g = .5, b = 1, a = 1 },
            backgroundTransparency = 0.3,
            fastTrackingMouseButton = 'LeftButton',
            fastTrackingKeys = {
                ctrl = false,
                shift = false,
                alt = true,
            },
            showGoalBonus = false,
            goalBonusDisplay = 'percent',
            hideFrameInCombat = false,
            hideNotificationsInCombat = false,
            sortBy = 'name',
            sortOrder = 'asc',
            frameScale = 1.0,
            enableDataBrokerSupport = false,
            showDataBrokerItemName = true,
            dataBrokerNumItems = 2,
        }
    }
}

---Is called by AceAddon when the addon is first loaded.
function FarmBuddy:OnInitialize()
    self.db = LibStub('AceDB-3.0'):New(FARM_BUDDY_ID .. 'DB', DEFAULTS)

    -- Register events
    self:RegisterEvent('PLAYER_ENTERING_WORLD', 'PlayerEnteringWorld')
    self:RegisterEvent('BAG_UPDATE_DELAYED', 'BagUpdateDelayed')
    self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'ItemInfoReceived')
    self:RegisterEvent('PLAYER_REGEN_DISABLED', 'PlayerRegenDisabled')
    self:RegisterEvent('PLAYER_REGEN_ENABLED', 'PlayerRegenEnabled')
    self:RegisterEvent('PET_BATTLE_OPENING_START', 'PlayerRegenDisabled')
    self:RegisterEvent('PET_BATTLE_CLOSE', 'PlayerRegenEnabled')

    self.db.RegisterCallback(self, 'OnProfileChanged', 'OnProfileChanged')
    self.db.RegisterCallback(self, 'OnProfileCopied', 'OnProfileChanged')
    self.db.RegisterCallback(self, 'OnProfileReset', 'OnProfileChanged')
    self.db.RegisterCallback(self, 'OnProfileShutdown', 'OnProfileShutdown')

    Mixin(FarmBuddyFrame, BackdropTemplateMixin)

    -- Init addon stuff
    self:InitSettings()
    self:InitItems()
    self:RegisterDialogs()
    self:InitDataBroker()
    self:SetTitleDisplay()
    self:SetButtonDisplay()
    self:SetFrameLockStatus()
    self:SetBackgroundTransparency()
    self:InitChatCommands()
    self:SetShowFrame()
    self:SetScale()
    self:RestoreFramePosition()
    self:UpdateGUI(false)

    FarmBuddyFrame:HookScript('OnDragStop', function() self:SaveFramePosition() end)
    FarmBuddyFrame.AddItemButton:SetScript('OnClick', function(_, button) self:AddItemClick(button) end)
end

---Is called when the Plugin gets enabled.
function FarmBuddy:OnEnable()
    self:SecureHook('HandleModifiedItemClick', 'ModifiedClick')
    self:ScheduleRepeatingTimer('NotificationTask', 1)
    self:ScheduleRepeatingTimer('ItemInfoReceived', 5)
end

---Is called when the Plugin gets disabled.
function FarmBuddy:OnDisable()
    self:CancelAllTimers()
end

---Is called when the player enters the world.
function FarmBuddy:PlayerEnteringWorld()
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')

    -- Delayed data fetching to prevent login timing issues
    C_Timer.After(4, function()
        if self.db.profile.items then
            ITEM_STORAGE = self.db.profile.items
            for _, itemStorage in pairs(ITEM_STORAGE) do
                if itemStorage.itemID and itemStorage.itemID > 0 then
                    local itemInfo = self:GetItemInfo(itemStorage.itemID, itemStorage.id)
                    NOTIFICATION_TRIGGERED[itemStorage.itemID] = itemInfo and itemStorage.quantity > 0 and self:GetCount(itemInfo) >= itemStorage.quantity
                end
            end
        end

        self:InitItems()
        self:UpdateGUI()
        ITEM_DATA_INIT_COMPLETE = true
    end)
end

---Registers the addon's dialog boxes.
function FarmBuddy:RegisterDialogs()
    StaticPopupDialogs[FARM_BUDDY_DIALOG_SET_ITEM_GOAL] = {
        text = L['FARM_BUDDY_POPUP_SET_GOAL_AMOUNT'],
        button1 = L['FARM_BUDDY_OK'],
        button2 = L['FARM_BUDDY_CANCEL'],
        hasEditBox = true,
        OnShow = function(dialog, data)
            local quantity = self:GetItemFromSV(data, 'quantity', true)
            if quantity and quantity > 0 then
                dialog:GetEditBox():SetText(tostring(quantity))
                dialog:GetEditBox():HighlightText()
            end
        end,
        OnAccept = function(dialog, data)
            self:ApplyItemGoal(data, dialog:GetEditBox():GetText())
        end,
        EditBoxOnEnterPressed = function(editBox)
            local dialog = editBox:GetParent()
            self:ApplyItemGoal(dialog.data, dialog:GetEditBox():GetText())
            dialog:Hide()
        end,
        EditBoxOnEscapePressed = function(editBox)
            editBox:GetParent():Hide()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopupDialogs[FARM_BUDDY_DIALOG_RESET_ALL_ITEMS_CONFIRM] = {
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
    StaticPopupDialogs[FARM_BUDDY_DIALOG_RESET_ALL_CONFIRM] = {
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
    StaticPopupDialogs[FARM_BUDDY_DIALOG_RESET_FRAME_POSITION_CONFIRM] = {
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

---Parse events registered to plugin and act on them.
function FarmBuddy:BagUpdateDelayed()
    if not ITEM_DATA_INIT_COMPLETE then
        return
    end

    self:InitItems()
    self:UpdateGUI()
end

---Fires when the player enters combat.
function FarmBuddy:PlayerRegenDisabled()
    if self.db.profile.settings.hideFrameInCombat then
        FarmBuddyFrame:Hide()
    end

    PLAYER_IN_COMBAT = true
end

---Fires if the player leaves combat.
function FarmBuddy:PlayerRegenEnabled()
    if self.db.profile.settings.showFrame then
        FarmBuddyFrame:Show()
    end

    PLAYER_IN_COMBAT = false
end

---Init all items including counts.
function FarmBuddy:InitItems()
    -- Copy saved items to temp storage to track counts
    if self.db.profile.items then
        ITEM_STORAGE = self.db.profile.items
        for index, itemStorage in pairs(ITEM_STORAGE) do
            if itemStorage.itemID and itemStorage.itemID > 0 then
                local itemInfo = self:GetItemInfo(itemStorage.itemID, itemStorage.id)
                if itemInfo then
                    itemStorage._info = itemInfo
                    ITEM_STORAGE[index].count = self:GetCount(itemInfo)
                    ITEM_STORAGE[index].rarity = itemInfo.Rarity
                else
                    ITEM_STORAGE[index].count = 0
                    ITEM_STORAGE[index].rarity = 0
                end
            else
                -- Fetch unknown items
                self:AddItemToQueue(itemStorage.id, itemStorage.name)
            end
        end

        self:SortItems()
    end
end

---Applies the item goal for the given item ID.
---@param id string Unique storage ID of the item.
---@param value number Goal quantity.
function FarmBuddy:ApplyItemGoal(id, value)
    self:SetItemProp(id, 'quantity', value, true)
end

---Sort items by the given setting.
function FarmBuddy:SortItems()
    table.sort(ITEM_STORAGE, function (a, b)
        return self:SortItemsByKey(a, b, self.db.profile.settings.sortBy)
    end)
end

---Is called when an item is clicked with modifier key.
---@param itemLink string
---@param itemLocation? table Item location (ItemLocationMixin) or nil for bags/bank/mail.
function FarmBuddy:ModifiedClick(itemLink, itemLocation)
    -- item location can be nil for bags/bank/mail and is not nil for inventory slots, make an explicit check
    if itemLocation and itemLocation.IsBagAndSlot and (not itemLocation:IsBagAndSlot()) then
        return
    end

    local db = self.db.profile.settings
    local modifierChecks = {
        alt = IsAltKeyDown,
        ctrl = IsControlKeyDown,
        shift = IsShiftKeyDown,
    }
    local conditions = false

    -- Check modifier keys
    for key, state in pairs(db.fastTrackingKeys) do
        local isKeyDown = modifierChecks[key]
        if isKeyDown then
            conditions = isKeyDown() == state
            if not conditions then
                break
            end
        end
    end

    if GetMouseButtonClicked() == db.fastTrackingMouseButton and not CursorHasItem() and conditions then
        if itemLink then
            local itemInfo = self:GetItemInfo(itemLink)
            if itemInfo then
                if self:AddConfigItem(nil, itemInfo.ItemID, self:GetNameFromItemLink(itemLink)) then
                    self:InitItems()
                    self:UpdateGUI()

                    local text = L['FARM_BUDDY_ITEM_SET_MSG']:gsub('!itemName!', itemLink)
                    self:Print(text)
                else
                    local text = L['FARM_BUDDY_ITEM_NOT_SET_MSG']:gsub('!itemName!', itemLink)
                    self:Print(text)
                end
            end
        end
    end
end

---Get the unique item ID by item name.
---@param name string
---@return string? id Unique storage ID, or nil if the item is not tracked.
function FarmBuddy:GetItemIDByName(name)
    local id

    for _, item in pairs(ITEM_STORAGE) do
        if item.name == name then
            id = item.id
            break
        end
    end

    return id
end

---Queues a notification.
---@param index number Item ID used as the queue key.
---@param itemName string
---@param itemIconFileDataID number
---@param quantity number Goal quantity.
function FarmBuddy:QueueNotification(index, itemInfo, quantity)
    NOTIFICATION_QUEUE[index] = {
        Index = index,
        ItemInfo = itemInfo,
        Quantity = quantity,
    }
end

---Resets the notification trigger state for the given item ID.
---@param itemID number
---@param value boolean
function FarmBuddy:ResetNotificationTrigger(itemID, value)
    NOTIFICATION_TRIGGERED[itemID] = value
end

---Is called by the timer to handle the next notification.
function FarmBuddy:NotificationTask()
    if not FarmBuddyNotification_Shown() then
        local hideInCombat = self.db.profile.settings.hideNotificationsInCombat
        for index, notification in pairs(NOTIFICATION_QUEUE) do
            if not hideInCombat or (hideInCombat and not PLAYER_IN_COMBAT) then
                self:ShowNotification(notification.Index, notification.ItemInfo, notification.Quantity, false)
            else
                NOTIFICATION_TRIGGERED[notification.Index] = true
            end
            NOTIFICATION_QUEUE[index] = nil
            break
        end
    end
end

---Raises a notification.
---@param index number Item ID used as the trigger key.
---@param itemInfo table Item info.
---@param quantity number Goal quantity.
---@param demo? boolean Force showing the notification (preview), bypassing the triggered state.
function FarmBuddy:ShowNotification(index, itemInfo, quantity, demo)
    if self.db.profile.settings.goalNotification or demo then

        local playSound = self.db.profile.settings.playNotificationSound
        local notificationDisplayDuration = tonumber(self.db.profile.settings.notificationDisplayDuration)
        local notificationGlow = self.db.profile.settings.notificationGlow
        local notificationShine = self.db.profile.settings.notificationShine
        local sound

        if playSound then
            sound = self.db.profile.settings.notificationSound
        end

        if not demo then
            NOTIFICATION_TRIGGERED[index] = true
        end

        if self.db.profile.settings.chatGoalNotifications then
            local message = L["FARM_BUDDY_CHAT_NOTIFICATION_TEXT"]:gsub('!quantity!', quantity):gsub('!itemLink!', itemInfo.Link)
            self:Print(message)
        end

        FarmBuddyNotification_Show(
            itemInfo.Name, itemInfo.IconFileDataID, quantity, sound, notificationDisplayDuration, notificationGlow, notificationShine
        )
    end
end

---Updates the GUI elements.
function FarmBuddy:UpdateGUI(handleNotifications)
    if handleNotifications == nil then
        handleNotifications = true
    end

    local curFrame
    local lastFrame = FarmBuddyFrame
    local totalHeight = 0
    local count = 0

    self:ClearDataBrokerData()

    for _, itemStorage in pairs(ITEM_STORAGE) do

        local itemInfo = itemStorage._info
        if itemInfo then
            local frameName = FARM_BUDDY_ID .. 'Item' .. itemStorage.id
            curFrame = ITEM_FRAMES[frameName]

            if itemStorage.hidden == 1 then
                if curFrame then
                    curFrame:Hide()
                end
            else
                local itemCount = self:GetCount(itemInfo)
                local goalReached
                local progressBarFrame

                -- Only add new frame if the frame does not already exists
                if not curFrame then

                    curFrame = CreateFrame('Frame', frameName, FarmBuddyFrame, 'FarmBuddyItemTemplate')
                    curFrame.storageID = itemStorage.id
                    curFrame.Texture:SetTexture(itemInfo.IconFileDataID)

                    curFrame.ProgressBar = CreateFrame('STATUSBAR', frameName .. 'ProgressBar', curFrame, 'FarmBuddyProgressBarTemplate')
                    curFrame.ProgressBar:SetPoint('TOPLEFT', curFrame, (curFrame.Texture:GetWidth() + 7), -25)
                    curFrame.ProgressBar.baseWidth = curFrame.ProgressBar:GetWidth()

                    -- Keep the title on a single line so it clips instead of
                    -- wrapping when constrained to the available width. The
                    -- inherited font is centered by default, so left-align it.
                    curFrame.Title:SetWordWrap(false)
                    curFrame.Title:SetJustifyH('LEFT')

                    ITEM_FRAMES[frameName] = curFrame
                end

                -- Derive the displayed name from the live item info so it reflects
                -- the current client language instead of the stored name.
                curFrame.Title:SetText(itemInfo.Name)
                curFrame.Title:SetTextColor(itemInfo.Rarity.r, itemInfo.Rarity.g, itemInfo.Rarity.b, 1)

                progressBarFrame = curFrame.ProgressBar

                -- Handle notifications
                if itemStorage.quantity > 0 and itemCount >= itemStorage.quantity and not NOTIFICATION_TRIGGERED[itemInfo.ItemID] then
                    goalReached = true

                    if handleNotifications and ITEM_DATA_INIT_COMPLETE then
                        self:QueueNotification(itemInfo.ItemID, itemInfo, itemStorage.quantity)
                    end
                else
                    NOTIFICATION_QUEUE[itemInfo.ItemID] = nil
                    goalReached = false
                end

                curFrame:Show()
                curFrame:ClearAllPoints()

                -- Set frame position
                if count > 0 then
                    curFrame:SetPoint('TOPLEFT', lastFrame, 0, -(curFrame:GetHeight() + 3))
                else
                    curFrame:SetPoint('TOPLEFT', FarmBuddyFrame, 0, 0)
                end

                -- Toggle the item icon. When it is hidden, shift the content
                -- (title, completion check and progress bar) left by the icon
                -- width and widen the title and progress bar by the same amount
                -- so they fill the freed space and keep the same look.
                local iconWidth = curFrame.Texture:GetWidth()
                local iconOffset = 0

                if self.db.profile.settings.showIcon then
                    curFrame.Texture:Show()
                else
                    curFrame.Texture:Hide()
                    iconOffset = -iconWidth
                end

                local extraWidth = -iconOffset

                curFrame.Title:SetPoint('TOPLEFT', curFrame, 39 + iconOffset, -7)
                curFrame.Title:SetWidth(curFrame.ProgressBar.baseWidth + 4 + extraWidth)
                curFrame.Complete:SetPoint('LEFT', curFrame, 40 + iconOffset, -11)
                curFrame.ProgressBar:SetPoint('TOPLEFT', curFrame, (iconWidth + 7) + iconOffset, -25)
                curFrame.ProgressBar:SetWidth(curFrame.ProgressBar.baseWidth + extraWidth)

                if self.db.profile.settings.showProgressBar then
                    progressBarFrame:Show()
                    curFrame.Subline:Hide()
                    self:SetupProgressBar(progressBarFrame, itemInfo, itemStorage, itemCount)
                else
                    progressBarFrame:Hide()
                    curFrame.Subline:Show()
                    self:SetSubline(curFrame, itemInfo, itemStorage, goalReached)
                end

                lastFrame = curFrame
                totalHeight = (totalHeight + curFrame:GetHeight())
                count = count + 1

                self:AddItemToDataBroker(itemInfo, itemStorage)
            end
        end
    end

    -- Show no tracked item text
    if count == 0 then
        FarmBuddyFrame.EmptyText:SetText('- ' .. L['FARM_BUDDY_NO_TRACKED_ITEMS'] .. ' -')
        FarmBuddyFrame.EmptyText:Show()
        totalHeight = totalHeight + FarmBuddyFrame.EmptyText:GetHeight()
    else
        FarmBuddyFrame.EmptyText:Hide()
    end

    -- Set parent main frame height
    totalHeight = totalHeight + 4 -- Add footer spacing
    if totalHeight > 0 then
        FarmBuddyFrame:SetHeight(totalHeight)
    end

    self:UpdateDataBroker()
end

---Sets the item subline based on the user settings.
---@param frame table Item frame containing the Subline and Complete regions.
---@param itemInfo table
---@param itemStorage table
---@param goalReached boolean
function FarmBuddy:SetSubline(frame, itemInfo, itemStorage, goalReached)
    local point, _, _, _, yOfs = frame.Subline:GetPoint()
    local iconOffset = self.db.profile.settings.showIcon and 0 or -frame.Texture:GetWidth()

    frame.Subline:SetText(self:GetCount(itemInfo, itemStorage.quantity, true))

    if goalReached and self.db.profile.settings.showGoalIndicator then
        frame.Subline:SetPoint(point, 54 + iconOffset, yOfs)
        frame.Complete:Show()
        frame.Subline:SetTextColor(0, 0.9, 0, 1.0)
    else
        frame.Subline:SetPoint(point, 40 + iconOffset, yOfs)
        frame.Complete:Hide()
        frame.Subline:SetTextColor(1, 0.8, 0, 1.0)
    end
end

---Sets the values for the progress bar.
---@param progressBarFrame table
---@param itemInfo table
---@param itemStorage table
---@param itemCount number
function FarmBuddy:SetupProgressBar(progressBarFrame, itemInfo, itemStorage, itemCount)
    local color
    local goalCount
    local noGoal = false

    if self.db.profile.settings.showQuantity and itemStorage.quantity > 0 then
        goalCount = itemStorage.quantity
    else
        noGoal = true
    end

    if noGoal then
        color = self.db.profile.settings.progressBarNoQuantityColor
    elseif itemCount >= goalCount then
        color = self.db.profile.settings.progressBarGoalColor
    else
        color = self.db.profile.settings.progressBarNoGoalColor
    end

    if noGoal then
        progressBarFrame:SetMinMaxValues(1, 10)
        progressBarFrame:SetValue(10)
    else
        progressBarFrame:SetMinMaxValues(0, goalCount)
        progressBarFrame:SetValue(itemCount)
    end

    progressBarFrame.text:SetText(self:GetCount(itemInfo, itemStorage.quantity, true))
    progressBarFrame:SetStatusBarColor(color.r, color.g, color.b, color.a)
end

---Removes the item frame with the given ID.
---@param id string Unique storage ID of the item.
function FarmBuddy:RemoveItemFrame(id)
    local frameName = FARM_BUDDY_ID .. 'Item' .. id
    if ITEM_FRAMES[frameName] then
        ITEM_FRAMES[frameName]:Hide()
        ITEM_FRAMES[frameName] = nil
    end
end

---Applies the configured frame scale.
function FarmBuddy:SetScale()
    if self.db.profile.settings.frameScale then
        FarmBuddyFrame:SetScale(self.db.profile.settings.frameScale)
    end
end

---Saves the current position of the frame.
function FarmBuddy:SaveFramePosition()
    local point, _, relativePoint, x, y = FarmBuddyFrame:GetPoint()
    self.db.profile.framePosition = {
        point = point, relativePoint = relativePoint, x = x, y = y,
    }
end

---Restores the saved position of the frame.
function FarmBuddy:RestoreFramePosition()
    local pos = self.db.profile.framePosition
    FarmBuddyFrame:ClearAllPoints()
    if pos and pos.point then
        FarmBuddyFrame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
    else
        FarmBuddyFrame:SetPoint('CENTER')
    end
end

---Hides the specified item.
---@param itemFrame table
function FarmBuddy:HideItem(itemFrame)
    self:SetItemProp(itemFrame.storageID, 'hidden', 1, true)
    self:NotifySettingsChanged()
end

---Shows the specified item.
---@param self table
---@param button string
function FarmBuddy_ItemOnMouseUp(self, button)
    if button == "RightButton" then
        FarmBuddy:ShowItemContextMenu(self)
    end
end

---Forwards a drag start on an item row to move the main frame.
---@param self table
function FarmBuddy_ItemOnDragStart(self)
    local parent = self:GetParent()
    if not parent.FrameLock then
        parent:StartMoving()
    end
end

---Forwards a drag stop on an item row and saves the main frame position.
---@param self table
function FarmBuddy_ItemOnDragStop(self)
    local parent = self:GetParent()
    if not parent.FrameLock then
        parent:StopMovingOrSizing()
        FarmBuddy:SaveFramePosition()
    end
end

---Shows the context menu for the specified item.
---@param _ table
---@param itemFrame table
function FarmBuddy:ShowItemContextMenu(itemFrame)
    MenuUtil.CreateContextMenu(itemFrame, function(_, rootDescription)
        rootDescription:CreateTitle(itemFrame.Title:GetText())

        rootDescription:CreateButton(L["FARM_BUDDY_ITEM_CONTEXT_MENU_SET_GOAL"], function()
            StaticPopup_Show(FARM_BUDDY_DIALOG_SET_ITEM_GOAL, itemFrame.Title:GetText(), nil, itemFrame.storageID)
        end)

        rootDescription:CreateButton(L["FARM_BUDDY_ITEM_CONTEXT_MENU_HIDE"], function()
            self:HideItem(itemFrame)
        end)

        rootDescription:CreateDivider()

        rootDescription:CreateButton(L["FARM_BUDDY_ITEM_CONTEXT_MENU_REMOVE"], function()
            self:RemoveItem(itemFrame.storageID)
        end)
    end)
end
