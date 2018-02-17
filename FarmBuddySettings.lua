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
local ITEM_PREFIX = FARM_BUDDY_ID .. 'Item';
local ID_LENGTH = 32;
local OPTION_ORDER = {};
local RANDOM_CHARS = {}

-- **************************************************************************
-- NAME : FarmBuddy:InitSettings()
-- DESC : Creates the configuration page.
-- **************************************************************************
function FarmBuddy:InitSettings()
  LibStub('AceConfig-3.0'):RegisterOptionsTable(ADDON_NAME, FarmBuddy:GetConfigOptions());
  LibStub('AceConfigDialog-3.0'):AddToBlizOptions(ADDON_NAME);
  self:GenerateChars();
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
        order = self:GetOptionOrder('main'),
      },
      info_author = {
        type = 'description',
        name = L['FARM_BUDDY_AUTHOR'] .. ': ' .. GetAddOnMetadata('FarmBuddy', 'Author'),
        order = self:GetOptionOrder('main'),
      },
      tab_general = {
        name = L['FARM_BUDDY_SETTINGS'],
        type = 'group',
        order = self:GetOptionOrder('main'),
        args = {
          general_show_title = {
            type = 'toggle',
            name = L['FARM_BUDDY_SHOW_TITLE'],
            desc = L['FARM_BUDDY_SHOW_TITLE_DESC'],
            get = 'GetShowTitle',
            set = 'SetShowTitle',
            order = self:GetOptionOrder('main'),
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
            func = function() FarmBuddy:AddConfigItem(nil); end,
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
      tab_notifications = {
        name = L['FARM_BUDDY_NOTIFICATIONS'],
        type = 'group',
        order = self:GetOptionOrder('main'),
        args = {

        }
      },
      tab_actions = {
        name = L['FARM_BUDDY_ACTIONS'],
        type = 'group',
        order = self:GetOptionOrder('main'),
        args = {

        }
      },
      tab_about = {
        name = L['FARM_BUDDY_ABOUT'],
        type = 'group',
        order = self:GetOptionOrder('about'),
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
            order = FarmBuddy:GetOptionOrder('about'),
          },
          about_info_author_title = {
            type = 'description',
            name = L['FARM_BUDDY_AUTHOR'],
            order = self:GetOptionOrder('about'),
            width = 'half',
          },
          about_info_author = {
            type = 'description',
            name = GetAddOnMetadata('FarmBuddy', 'Author'),
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
            name = self:GetColoredText(L['FARM_BUDDY_LOCALIZATION'], 'FFFFFF00') .. '\n',
            order = self:GetOptionOrder('about'),
            width = 'full',
          },
          about_info_localization_deDE = {
            type = 'description',
            fontSize = 'small',
            name = self:GetColoredText(L['FARM_BUDDY_GERMAN'], 'FF00FF00') .. '\n',
            order = self:GetOptionOrder('about'),
            width = 'full',
          },
          about_info_localization_supporters = {
            type = 'description',
            name = '   • Keldor\n\n\n',
            order = self:GetOptionOrder('about'),
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
function FarmBuddy:AddConfigItem(id)

  local options = CONFIG_REG:GetOptionsTable(ADDON_NAME, 'dialog', 'AceConfigDialog-3.0');

  -- New item so generate a uniqie ID to save it in SavedVariables
  if (id == nil) then
    id = self:GetRandomString(ID_LENGTH);

    if (self.db.profile.items ~= nil) then
      tinsert(self.db.profile.items, {
        id = id,
        name = '',
        quantity = 0
      });
    end
  end

  local count = (FarmBuddy:TableLength(options.args.tab_items.args) - 4) + 1;

  options.args.tab_items.args[ITEM_PREFIX .. id] = {
    name = L['FARM_BUDDY_ITEM'] .. ' ' .. count,
    type = 'group',
    order = self:GetOptionOrder('items'),
    unique_index = id,
    args = {
      ['item_name_' .. id] = {
        type = 'input',
        name = L['FARM_BUDDY_ITEM'],
        usage = L['FARM_BUDDY_ITEM_TO_TRACK_USAGE'],
        desc = L['FARM_BUDDY_ITEM_TO_TRACK_DESC'],
        get = function(info) return self:GetItemFromSV(info.option.unique_index, 'name', false); end,
        set = function(info, input) self:SetItemProp(info.option.unique_index, 'name', input, false); end,
        width = 'double',
        order = 0,
        unique_index = id,
      },
      ['item_quantity_' .. id] = {
        type = 'input',
        name = L['FARM_BUDDY_QUANTITY'],
        desc = L['FARM_BUDDY_COMMAND_GOAL_DESC'],
        usage = L['FARM_BUDDY_ALERT_COUNT_USAGE'],
        get = function(info) return self:GetItemFromSV(info.option.unique_index, 'quantity', false); end,
        set = function(info, input) self:SetItemProp(info.option.unique_index, 'quantity', input, true); end,
        width = 'half',
        order = 1,
        unique_index = id,
      },
      ['item_spacer_' .. id] = {
        type = 'description',
        name = '',
        order = 2,
        unique_index = id,
      },
      ['item_clear_button_' .. id] = {
        type = 'execute',
        name = L['FARM_BUDDY_REMOVE_ITEM'],
        desc = L['FARM_BUDDY_REMOVE_ITEM_DESC'],
        order = 3,
        func = function(info) FarmBuddy:RemoveItem(info); end,
        unique_index = id,
      },
    },
  };

  CONFIG_REG:NotifyChange(ADDON_NAME);
end

-- **************************************************************************
-- NAME : FarmBuddy:LoadExistingConfigItems()
-- DESC : Loads existing items from SavedVariables.
-- **************************************************************************
function FarmBuddy:LoadExistingConfigItems()
  if (self.db.profile.items ~= nil) then
    local items = self.db.profile.items;
    for index, itemStorage in pairs(items) do
      self:AddConfigItem(itemStorage.id);
    end
    CONFIG_REG:NotifyChange(ADDON_NAME);
  end
end

-- **************************************************************************
-- NAME : FarmBuddy:GetItemIndexByID()
-- DESC : Gets the SavedVariables index for the given item ID.
-- **************************************************************************
function FarmBuddy:GetItemIndexByID(id)
  if (self.db.profile.items ~= nil) then
    for k, v in pairs(self.db.profile.items) do
      if (v.id == id) then
        return k;
      end
    end
  end
  return nil;
end

-- **************************************************************************
-- NAME : FarmBuddy:GetItemFromSV()
-- DESC : Gets the key value from the SavedVariables item list.
-- **************************************************************************
function FarmBuddy:GetItemFromSV(id, key, numeric)

  local value = '';
  local index = self:GetItemIndexByID(id);
  if(index ~= nil and self.db.profile.items[index][key] ~= nil) then
    value = self.db.profile.items[index][key];
    if(numeric == true) then
      value = tonumber(value);
    else
      value = tostring(value);
    end
  end

  return value;
end

-- **************************************************************************
-- NAME : FarmBuddy:SetItemProp()
-- DESC : Saves the item with the given ID and key to the SavedVariables.
-- **************************************************************************
function FarmBuddy:SetItemProp(id, key, input, numeric)

  local index = self:GetItemIndexByID(id);
  if(index ~= nil) then

    -- Set empty value based on numeric var
    if (input == '') then
      if (numeric == true) then
        input = 0;
      else
        input = '';
      end
    end

    if (numeric == true) then
      input = tonumber(input);
    end
    self.db.profile.items[index][key] = input;
  end

  self:InitItems();
  self:UpdateGUI();
end

-- **************************************************************************
-- NAME : FarmBuddy:RemoveItem()
-- DESC : Removes the item with the given ID from the settings GUI and SavedVariables.
-- **************************************************************************
function FarmBuddy:RemoveItem(info)

  local groupName = ITEM_PREFIX .. info.option.unique_index;

  -- Remove settings group for item ID
  if (info.options.args.tab_items.args[groupName] ~= nil) then
    info.options.args.tab_items.args[groupName] = nil;
  end

  -- Remove item from SavedVariables
  local index = self:GetItemIndexByID(info.option.unique_index);
  if(index ~= nil) then
    self.db.profile.items[index] = nil;
  end

  -- Remove frame and redraw
  self:RemoveItemFrame(info.option.unique_index);
  self:InitItems();
  self:UpdateGUI();

  -- Update settings GUI
  self:ReindexConfigItems();
  CONFIG_REG:NotifyChange(ADDON_NAME);
end

-- **************************************************************************
-- NAME : FarmBuddy:ReindexConfigItems()
-- DESC : Number item entries by it's new order.
-- **************************************************************************
function FarmBuddy:ReindexConfigItems()

  local options = CONFIG_REG:GetOptionsTable(ADDON_NAME, 'dialog', 'AceConfigDialog-3.0');
  if (options.args.tab_items.args ~= nil) then
    for k in pairs(options.args.tab_items.args) do
      if (string.sub(k, 1, string.len(ITEM_PREFIX)) == ITEM_PREFIX) then
        options.args.tab_items.args[k] = nil;
      end
    end

    self:LoadExistingConfigItems();
  end
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

-- **************************************************************************
-- NAME : FarmBuddy:GetShowTitle()
-- DESC : Gets the show title setting.
-- **************************************************************************
function FarmBuddy:GetShowTitle()
  return self.db.profile.settings.showTitle;
end

-- **************************************************************************
-- NAME : FarmBuddy:SetShowTitle()
-- DESC : Sets the show title setting.
-- **************************************************************************
function FarmBuddy:SetShowTitle(info, input)
  self.db.profile.settings.showTitle = input;
  self:SetTitleDisplay();
end

-- **************************************************************************
-- NAME : FarmBuddy:GenerateChars()
-- DESC : Generates a table of random chars.
-- **************************************************************************
function FarmBuddy:GenerateChars()
  -- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
  for i = 48, 57 do table.insert(RANDOM_CHARS, string.char(i)) end
  for i = 65, 90 do table.insert(RANDOM_CHARS, string.char(i)) end
  for i = 97, 122 do table.insert(RANDOM_CHARS, string.char(i)) end
end

-- **************************************************************************
-- NAME : FarmBuddy:GetRandomString()
-- DESC : Generates a random string with the given length.
-- **************************************************************************
function FarmBuddy:GetRandomString(length)
  local strTable = {};
  for i = 1, length do
    table.insert(strTable, RANDOM_CHARS[math.random(1, #RANDOM_CHARS)]);
  end;
  return table.concat(strTable);
end