-- **************************************************************************
-- * FarmBuddy.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FARM_BUDDY_ID = 'FarmBuddyStandalone';
local ADDON_NAME = 'Farm Buddy';
local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true);
local FarmBuddy = LibStub('AceAddon-3.0'):NewAddon(FARM_BUDDY_ID, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0');
local ADDON_VERSION = GetAddOnMetadata('FarmBuddy', 'Version');

-- **************************************************************************
-- NAME : FarmBuddy:OnInitialize()
-- DESC : Is called by AceAddon when the addon is first loaded.
-- **************************************************************************
function FarmBuddy:OnInitialize()

  -- Register events
  self:RegisterEvent('BAG_UPDATE', 'BagUpdate');

  local itemGap = -66;

  local FRAME = CreateFrame('Frame', 'Item1', FarmBuddyFrame, 'FarmBuddyItemTemplate');
  FRAME.Title:SetText('Ruhestein');
  FRAME.Title:SetTextColor(255, 255, 255, 1);
  FRAME.Subline:SetText('0 / 1');

  local FRAME2 = CreateFrame('Frame', 'Item2', FarmBuddyFrame, 'FarmBuddyItemTemplate');
  FRAME2.Title:SetText('Seidenstoff');
  FRAME2.Title:SetTextColor(255, 255, 255, 1);
  FRAME2.Subline:SetText('132 / 200');
  FRAME2:SetPoint("BOTTOM", FRAME, 0, itemGap);

  local FRAME3 = CreateFrame('Frame', 'Item3', FarmBuddyFrame, 'FarmBuddyItemTemplate');
  FRAME3.Title:SetText('Wollstoff');
  FRAME3.Title:SetTextColor(255, 255, 255, 1);
  FRAME3.Subline:SetText('48 / 200');
  FRAME3:SetPoint("BOTTOM", FRAME2, 0, itemGap);

  local FRAME4 = CreateFrame('Frame', 'Item4', FarmBuddyFrame, 'FarmBuddyItemTemplate');
  FRAME4.Title:SetText('Luftpartikel');
  FRAME4.Title:SetTextColor(0, 255, 0, 1);
  FRAME4.Subline:SetText('0 / 50');
  FRAME4:SetPoint("BOTTOM", FRAME3, 0, itemGap);



end

-- **************************************************************************
-- NAME : FarmBuddy_OnLoad()
-- DESC : Registers the plugin upon it loading.
-- **************************************************************************
function FarmBuddy_OnLoad(self)

end

-- **************************************************************************
-- NAME : FarmBuddy_OnShow()
-- DESC : Called when plugin is visible.
-- **************************************************************************
function FarmBuddy_OnShow(self)

end

-- **************************************************************************
-- NAME : FarmBuddy_OnClick()
-- DESC : Called when plugin is clicked.
-- **************************************************************************
function FarmBuddy_OnClick(self, button)

end

-- **************************************************************************
-- NAME : FarmBuddy:OnEnable()
-- DESC : Is called when the Plugin gets enabled.
-- **************************************************************************
function FarmBuddy:OnEnable()

end

-- **************************************************************************
-- NAME : FarmBuddy:OnDisable()
-- DESC : Is called when the Plugin gets disabled.
-- **************************************************************************
function FarmBuddy:OnDisable()

end

-- **************************************************************************
-- NAME : FarmBuddy_GetID()
-- DESC : Gets the Plugin ID.
-- **************************************************************************
function FarmBuddy_GetID()
  return FARM_BUDDY_ID;
end

-- **************************************************************************
-- NAME : FarmBuddy_GetAddOnName()
-- DESC : Gets the Plugin AdOn name.
-- **************************************************************************
function FarmBuddy_GetAddOnName()
  return ADDON_NAME;
end

-- **************************************************************************
-- NAME : TitanFarmBuddy:BagUpdate()
-- DESC : Parse events registered to plugin and act on them.
-- **************************************************************************
function FarmBuddy:BagUpdate()

end