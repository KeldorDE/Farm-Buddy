---@diagnostic disable: undefined-global
-- **************************************************************************
-- * Notification.lua
-- *
-- * By: Keldor
-- **************************************************************************

local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true)
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID)
local FRAME_NAME = 'FarmBuddyAlertFrameTemplate'
local FRAME = CreateFrame('Button', FRAME_NAME, UIParent, FRAME_NAME)
local FRAME_HIDDEN = true

---Shows a notification frame for the given item link.
---@param name string Item name.
---@param icon number|string Icon file data ID or texture path.
---@param goal number|string Goal quantity shown before the name.
---@param sound? number|string Sound to play, or nil for no sound.
---@param duration number Display duration in seconds.
---@param glow boolean Show the glow animation.
---@param shine boolean Show the shine animation.
function FarmBuddyNotification_Show(name, icon, goal, sound, duration, glow, shine)

    FarmBuddyNotification_HideNotification(false)

    FarmBuddyNotification_SetTitle(FARM_BUDDY_ADDON_NAME)
    FarmBuddyNotification_SetWidth(400)
    FarmBuddyNotification_SetText(goal .. ' ' .. name)
    FarmBuddyNotification_SetIcon(icon)

    if sound then
        PlaySound(sound)
    end

    if glow then
        FRAME.glow:SetTexture('Interface\\AchievementFrame\\UI-Achievement-Guild')
        FRAME.glow:SetTexCoord(0.00195313, 0.74804688, 0.19531250, 0.49609375)
        FRAME.glow:SetVertexColor(1, 1, 1)
        FRAME.glow:Show()
    else
        FRAME.glow:Hide()
    end

    if shine then
        FRAME.shine:SetTexture('Interface\\AchievementFrame\\UI-Achievement-Guild')
        FRAME.shine:SetTexCoord(0.75195313, 0.91601563, 0.19531250, 0.35937500)
        FRAME.shine:SetPoint('BOTTOMLEFT', 0, 16)
        FRAME.shine:Show()
    else
        FRAME.shine:Hide()
    end

    FRAME_HIDDEN = false

    FRAME:Show()
    FRAME.animIn:Play()

    if glow then
        FRAME.glow.animIn:Play()
    end

    if shine then
        FRAME.shine.animIn:Play()
    end

    FRAME.waitAndAnimOut.animOut:SetStartDelay(duration)
    FRAME.waitAndAnimOut:Play()
end

---Resets the timer and hides the notification.
---@param click? boolean Play the out-animation when triggered by a click.
function FarmBuddyNotification_HideNotification(click)
    FRAME_HIDDEN = true
    FRAME.waitAndAnimOut:Stop()
    if click then
        FRAME.animOut:Play()
    end
end

---Sets the notification title.
---@param title string
function FarmBuddyNotification_SetTitle(title)
    FRAME.unlocked:SetText(title)
end

---Sets the notification text.
---@param text string
function FarmBuddyNotification_SetText(text)
    FRAME.Name:SetText(text)
end

---Sets the notification icon.
---@param icon number|string Icon file data ID or texture path.
function FarmBuddyNotification_SetIcon(icon)
    FRAME.Icon.Texture:SetTexture(icon)
end

---Sets the notification frame width.
---@param width number
function FarmBuddyNotification_SetWidth(width)
    FRAME:SetWidth(width)
end

---Handles the OnMouseDown event for the FarmBuddyAnchor frame.
---@param self table The anchor frame.
---@param button string Mouse button that was pressed.
function FarmBuddyNotification_OnMouseDown(self, button)
    if button == 'LeftButton' and not self.isMoving then
        self:StartMoving()
        self.isMoving = true
    end

    if button == 'RightButton' and not self.isMoving then
        self:Hide()
        Settings.OpenToCategory(FarmBuddy.optionsID)
    end
end

---Handles the OnMouseUp event for the FarmBuddyAnchor frame.
---@param self table The anchor frame.
---@param button string Mouse button that was released.
function FarmBuddyNotification_OnMouseUp(self, button)
    if button == 'LeftButton' and self.isMoving then
        self:StopMovingOrSizing()
        self.isMoving = false
    end
end

---Shows the Notification Anchor frame.
function FarmBuddyNotification_ShowAnchor()
    -- Set Scale for Anchor frame
    FarmBuddyAnchor:SetScale(FRAME:GetEffectiveScale())
    FarmBuddyAnchor.Name:SetText(L['FARM_BUDDY_ANCHOR_HELP_TEXT'])

    FarmBuddyAnchor:Show()
end

---Gets the notification is currently shown status.
---@return boolean shown True while a notification is currently displayed.
function FarmBuddyNotification_Shown()
    return not FRAME_HIDDEN and true or false
end
