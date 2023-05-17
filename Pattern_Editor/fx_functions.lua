
-- In this file, you'll find all functions that relate to editing effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua

require "Pattern_Editor.constants"

-----------------------
-- Set Effect --
-----------------------
function set_arp()
  local col = renoise.song().selected_line.effect_columns[1]

  col.number_string = '0A'
  col.amount_string = '5C'
  
end