
-- In this file, you'll find all functions that relate to editing effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua

require "Pattern_Editor.constants"

-----------------------
-- Set Effect --
-----------------------
function set_arp()
  local col = renoise.song().selected_line.effect_columns[1]
  col.number_value = 10 -- code for arpeggio, 0A
  col.amount_value = 0 
end

function dual_increment_fx(side, amount, col)
  local range = 16 -- 16 because 0-F
  col = renoise.song().selected_line.effect_columns[1] or col
  if col.number_value == 0 then
    return
  end
  if side == "x" then
    local x = bit.band(bit.rshift(col.amount_value, 4), 0xF)
    x = increment(x, amount, range)
    col.amount_value = bit.bor(bit.band(col.amount_value, 0xF), bit.lshift(x, 4))
  elseif side == "y" then
    local y = bit.band(col.amount_value, 0xF)
    y = increment(y, amount, range)
    col.amount_value = bit.bor(bit.band(col.amount_value, bit.lshift(0xF, 4)), y)
  else
    error("Side must be 'x' or 'y'")
  end
end

function increment(value, amount, range)
  -- Error if range is not 16 or 256
  if range ~= 16 and range ~= 256 then
    error("Range must be 16 or 256")
  end
  return (value + amount) % range
end