-- **************************************************************************
-- * Notification.lua
-- *
-- * By: Keldor
-- **************************************************************************

local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true);
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID);
local FarmBuddyNotification = LibStub('AceAddon-3.0'):NewAddon('FarmBuddyNotificationStandalone');
local FRAME_NAME = 'FarmBuddyAlertFrameTemplate';
local FRAME = CreateFrame('Button', FRAME_NAME, UIParent, 'FarmBuddyAlertFrameTemplate');
local FRAME_HIDDEN = true;


-- **************************************************************************
-- NAME : FarmBuddyNotification_Show()
-- DESC : Shows a notification frame for the given item link.
-- **************************************************************************
function FarmBuddyNotification_Show(itemName, goal, sound, duration, glow, shine)

  FarmBuddyNotification_HideNotification(false);

  local itemInfo = FarmBuddy:GetItemInfo(itemName);
  if itemInfo ~= nil then

    FarmBuddyNotification_SetTitle(FARM_BUDDY_ADDON_NAME);
    FarmBuddyNotification_SetWidth(400);
    FarmBuddyNotification_SetText(goal .. ' ' .. itemInfo.Name);
    FarmBuddyNotification_SetIcon(itemInfo.IconFileDataID);

    if sound ~= nil and sound ~= '' then
      PlaySound(sound);
    end

    if glow then
      FRAME.glow:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Guild");
      FRAME.glow:SetTexCoord(0.00195313, 0.74804688, 0.19531250, 0.49609375);
      FRAME.glow:SetVertexColor(1,1,1);
      FRAME.glow:Show();
    else
      FRAME.glow:Hide();
    end

    if shine then
      FRAME.shine:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Guild");
      FRAME.shine:SetTexCoord(0.75195313, 0.91601563, 0.19531250, 0.35937500);
      FRAME.shine:SetPoint("BOTTOMLEFT", 0, 16);
      FRAME.shine:Show();
    else
      FRAME.shine:Hide();
    end

    FRAME_HIDDEN = false;

    FRAME:Show();
    FRAME.animIn:Play();

    if glow then
      FRAME.glow.animIn:Play();
    end
    if shine then
      FRAME.shine.animIn:Play();
    end

    FRAME.waitAndAnimOut:Play();
  end
end

-- **************************************************************************
-- NAME : FarmBuddyNotification_HideNotification()
-- DESC : Resets the timer and hides the notification.
-- **************************************************************************
function FarmBuddyNotification_HideNotification(click)
  FRAME_HIDDEN = true;
  FRAME.waitAndAnimOut:Stop();
  if click == true then
    FRAME.animOut:Play();
  end
end

-- **************************************************************************
-- NAME : FarmBuddyNotification_SetTitle()
-- DESC : Sets the notification title.
-- **************************************************************************
function FarmBuddyNotification_SetTitle(title)
  FRAME.unlocked:SetText(title);
end

-- **************************************************************************
-- NAME : FarmBuddyNotification_SetText()
-- DESC : Sets the notification text.
-- **************************************************************************
function FarmBuddyNotification_SetText(text)
  FRAME.Name:SetText(text);
end

-- **************************************************************************
-- NAME : FarmBuddyNotification_SetIcon()
-- DESC : Sets the notification icon.
-- **************************************************************************
function FarmBuddyNotification_SetIcon(icon)
  FRAME.Icon.Texture:SetTexture(icon);
end

-- **************************************************************************
-- NAME : FarmBuddyNotification_SetWidth()
-- DESC : Sets the notification frame width.
-- **************************************************************************
function FarmBuddyNotification_SetWidth(width)
  FRAME:SetWidth(width);
end

-- **************************************************************************
-- NAME : FarmBuddyNotification_OnMouseDown()
-- DESC : Handles the OnMouseDown event for the FarmBuddyAnchor frame.
-- **************************************************************************
function FarmBuddyNotification_OnMouseDown(self, button)

  if button == 'LeftButton' and not self.isMoving then
    self:StartMoving();
    self.isMoving = true;
  end

  if button == 'RightButton' and not self.isMoving then
    self:Hide();
    Settings.OpenToCategory(FARM_BUDDY_ADDON_NAME);
  end
end

-- **************************************************************************
-- NAME : FarmBuddyNotification_OnMouseUp()
-- DESC : Handles the OnMouseUp event for the FarmBuddyAnchor frame.
-- **************************************************************************
function FarmBuddyNotification_OnMouseUp(self, button)

  if button == 'LeftButton' and self.isMoving then
    self:StopMovingOrSizing();
    self.isMoving = false;
  end
end

-- **************************************************************************
-- NAME : FarmBuddyNotification_ShowAnchor()
-- DESC : Shows the Notification Anchor frame.
-- **************************************************************************
function FarmBuddyNotification_ShowAnchor()

  -- Set Scale for Anchor frame
  FarmBuddyAnchor:SetScale(FRAME:GetEffectiveScale());
  FarmBuddyAnchor.Name:SetText(L['FARM_BUDDY_ANCHOR_HELP_TEXT']);

  FarmBuddyAnchor:Show();
end

-- **************************************************************************
-- NAME : FarmBuddyNotification_Shown()
-- DESC : Gets the notification is currently shown status.
-- **************************************************************************
function FarmBuddyNotification_Shown()
  if FRAME_HIDDEN == false then
    return true;
  end
  return false;
end
