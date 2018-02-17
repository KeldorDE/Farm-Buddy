-- **************************************************************************
-- * FarmBuddySettings.lua
-- *
-- * By: Keldor
-- **************************************************************************

local FARM_BUDDY_ID = FarmBuddy_GetID();
local L = LibStub('AceLocale-3.0'):GetLocale(FARM_BUDDY_ID, true);
local FarmBuddy = LibStub('AceAddon-3.0'):GetAddon(FARM_BUDDY_ID);
local CONFIG_REG = LibStub("AceConfigRegistry-3.0")
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
  self:LoadExistingConfigItems();
end

-- **************************************************************************
-- NAME : FarmBuddy:GetConfigOption()
-- DESC : Gets the configuration array for the AceConfig lib.
-- **************************************************************************
function FarmBuddy:GetConfigOptions()
  local options = {
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
        childGroups = 'tree',
        order = FarmBuddy:GetOptionOrder('main'),
        args = {
          items_space_1 = {
            type = 'description',
            name = '',
            order = FarmBuddy:GetOptionOrder('items'),
          },
          items_description = {
            type = 'description',
            name = L['FARM_BUDDY_ADD_ITEM_DESC'],
            order = FarmBuddy:GetOptionOrder('items'),
          },
          items_add_item = {
            type = 'execute',
            name = L['FARM_BUDDY_ADD_NEW_ITEM'],
            func = function() FarmBuddy:AddConfigItem(); end,
            width = 'double',
            order = FarmBuddy:GetOptionOrder('items'),
          },
          items_space_2 = {
            type = 'description',
            name = '',
            order = FarmBuddy:GetOptionOrder('items'),
          },
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

  return options;
end

-- **************************************************************************
-- NAME : FarmBuddy:AddConfigItem()
-- DESC : Adds a new config item row to tree.
-- **************************************************************************
function FarmBuddy:AddConfigItem(index)

  local options = CONFIG_REG:GetOptionsTable(ADDON_NAME, 'dialog', 'AceConfigDialog-3.0');

  if(index == nil) then
    local count = FarmBuddy:TableLength(options.args.tab_items.args) - 4;
    index = count + 1;
  end

  options.args.tab_items.args[FARM_BUDDY_ID .. 'Item' .. index] = {
    name = L['FARM_BUDDY_ITEM'] .. ' ' .. index,
    type = 'group',
    order = FarmBuddy:GetOptionOrder('items'),
    args = {
      ['item_name_' .. index] = {
        type = 'input',
        name = L['FARM_BUDDY_ITEM'],
        usage = L['FARM_BUDDY_ITEM_TO_TRACK_USAGE'],
        desc = L['FARM_BUDDY_ITEM_TO_TRACK_DESC'],
        get = function() return self:GetDBItem(index, 'name'); end,
        set = function(info, input) self:SetItemName(index, info, input); end,
        width = 'double',
        order = 0,
      },
      ['item_quantity_' .. index] = {
        type = 'input',
        name = L['FARM_BUDDY_QUANTITY'],
        desc = L['FARM_BUDDY_COMMAND_GOAL_DESC'],
        usage = L['FARM_BUDDY_ALERT_COUNT_USAGE'],
        get = function() return tostring(self:GetDBItem(index, 'quantity')); end,
        set = function(info, input) self:SetQuantity(index, info, input); end,
        width = 'half',
        order = 1,
      },
      ['item_spacer_' .. index] = {
        type = 'description',
        name = '',
        order = 2,
      },
      ['item_clear_button_' .. index] = {
        type = 'execute',
        name = L['FARM_BUDDY_REMOVE_ITEM'],
        desc = L['FARM_BUDDY_REMOVE_ITEM_DESC'],
        order = 3,
      },
    },
  };

  CONFIG_REG:NotifyChange(ADDON_NAME);
end

-- **************************************************************************
-- NAME : FarmBuddy:GetDBItem()
-- DESC : Gets the key value from the SavedVariables item list.
-- **************************************************************************
function FarmBuddy:GetDBItem(index, key)
  if(self.db.profile.items[index] ~= nil) then
    if(self.db.profile.items[index][key] ~= nil) then
      return self.db.profile.items[index][key];
    end
  end
  return '';
end

-- **************************************************************************
-- NAME : FarmBuddy:LoadExistingConfigItems()
-- DESC : Loads existing items from SavedVariables.
-- **************************************************************************
function FarmBuddy:LoadExistingConfigItems()
  if (self.db.profile.items ~= nil) then
    local items = self.db.profile.items;
    for index, itemStorage in pairs(items) do
      self:AddConfigItem(index);
    end
    CONFIG_REG:NotifyChange(ADDON_NAME);
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:SetItemName()
-- DESC : Writes the item name for the given index to SavedVariables.
-- **************************************************************************
function FarmBuddy:SetItemName(index, info, input)

  if (self.db.profile.items ~= nil) then
    if (self.db.profile.items[index] ~= nil) then
      self.db.profile.items[index].name = input;
    else
      tinsert(self.db.profile.items, {
        name = input,
        quantity = 0
      });
    end
  end

  self:InitItems();
  self:UpdateGUI();
end

-- **************************************************************************
-- NAME : FarmBuddy:SetQuantity()
-- DESC : Writes the item quantity for the given index to SavedVariables.
-- **************************************************************************
function FarmBuddy:SetQuantity(index, info, input)

  if(input ~= '') then
    input = tonumber(input);
  end

  if (self.db.profile.items ~= nil) then
    if (self.db.profile.items[index] ~= nil) then
      self.db.profile.items[index].quantity = input;
    else
      tinsert(self.db.profile.items, {
        name = '',
        quantity = input;
      });
    end
  end

  self:InitItems();
  self:UpdateGUI();
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
