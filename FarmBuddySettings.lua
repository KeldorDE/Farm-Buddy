-- **************************************************************************
-- * FarmBuddySettings.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FARM_BUDDY_ID = FarmBuddy_GetID();
local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true);
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID);
local ADDON_NAME = FarmBuddy_GetAddOnName();
local ADDON_VERSION = GetAddOnMetadata('FarmBuddy', 'Version');
local OPTION_ORDER = {};

-- **************************************************************************
-- NAME : FarmBuddy:InitSettings()
-- DESC : Creates the configuration page.
-- **************************************************************************
function FarmBuddy:InitSettings()
  LibStub('AceConfig-3.0'):RegisterOptionsTable(ADDON_NAME, FarmBuddy:GetConfigOptions());
  LibStub('AceConfigDialog-3.0'):AddToBlizOptions(ADDON_NAME);
end

-- **************************************************************************
-- NAME : FarmBuddy:GetConfigOption()
-- DESC : Gets the configuration array for the AceConfig lib.
-- **************************************************************************
function FarmBuddy:GetConfigOptions()
  return {
    name = ADDON_NAME,
    handler = FarmBuddy,
    childGroups = 'tab',
    type = 'group',
    args = {
      info_version = {
        type = 'description',
        name = L['FARM_BUDDY_VERSION'] .. ': ' .. ADDON_VERSION,
        order = FarmBuddy:GetOptionOrder('main'),
      },
      info_author = {
        type = 'description',
        name = L['FARM_BUDDY_AUTHOR'] .. ': ' .. GetAddOnMetadata('FarmBuddy', 'Author'),
        order = FarmBuddy:GetOptionOrder('main'),
      },
      tab_general = {
        name = L['FARM_BUDDY_SETTINGS'],
        type = 'group',
        order = FarmBuddy:GetOptionOrder('main'),
        args = {

        },
      },
      tab_items = {
        name = L['FARM_BUDDY_ITEMS'],
        type = 'group',
        order = FarmBuddy:GetOptionOrder('main'),
        args = {

        },
      },
      tab_notifications = {
        name = L['FARM_BUDDY_NOTIFICATIONS'],
        type = 'group',
        order = FarmBuddy:GetOptionOrder('main'),
        args = {

        }
      },
      tab_actions = {
        name = L['FARM_BUDDY_ACTIONS'],
        type = 'group',
        order = FarmBuddy:GetOptionOrder('main'),
        args = {

        }
      },
      tab_about = {
        name = L['FARM_BUDDY_ABOUT'],
        type = 'group',
        order = FarmBuddy:GetOptionOrder('about'),
        args = {
          about_space_1 = {
            type = 'description',
            name = '',
            order = FarmBuddy:GetOptionOrder('about'),
          },
          about_info_version_title = {
            type = 'description',
            name = L['FARM_BUDDY_VERSION'],
            order = FarmBuddy:GetOptionOrder('about'),
            width = 'half',
          },
          about_info_version = {
            type = 'description',
            name = ADDON_VERSION,
            order = FarmBuddy:GetOptionOrder('about'),
            width = 'double',
          },
          about_space_2 = {
            type = 'description',
            name = '',
            order = FarmBuddy:GetOptionOrder('about'),
          },
          about_info_author_title = {
            type = 'description',
            name = L['FARM_BUDDY_AUTHOR'],
            order = FarmBuddy:GetOptionOrder('about'),
            width = 'half',
          },
          about_info_author = {
            type = 'description',
            name = GetAddOnMetadata('FarmBuddy', 'Author'),
            order = FarmBuddy:GetOptionOrder('about'),
            width = 'double',
          },
          about_space_3 = {
            type = 'description',
            name = '\n\n',
            order = FarmBuddy:GetOptionOrder('about'),
          },
          about_info_localization_title = {
            type = 'description',
            fontSize = 'medium',
            name = FarmBuddy:GetColoredText(L['FARM_BUDDY_LOCALIZATION'], 'FFFFFF00') .. '\n',
            order = FarmBuddy:GetOptionOrder('about'),
            width = 'full',
          },
          about_info_localization_deDE = {
            type = 'description',
            fontSize = 'small',
            name = FarmBuddy:GetColoredText(L['FARM_BUDDY_GERMAN'], 'FF00FF00') .. '\n',
            order = FarmBuddy:GetOptionOrder('about'),
            width = 'full',
          },
          about_info_localization_supporters = {
            type = 'description',
            name = '   • Keldor\n\n\n',
            order = FarmBuddy:GetOptionOrder('about'),
            width = 'full',
          },
        }
      },
    }
  };
end

-- **************************************************************************
-- NAME : FarmBuddy:GetOptionOrder()
-- DESC : A helper function to order the option items in the order as listed in the array.
-- **************************************************************************
function FarmBuddy:GetOptionOrder(category)

  if not OPTION_ORDER.category then
    OPTION_ORDER.category = 0
  end

  OPTION_ORDER.category = OPTION_ORDER.category + 1;
  return OPTION_ORDER.category;
end
