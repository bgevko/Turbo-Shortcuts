
-- In this file, you'll find all functions that relate to editing effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua

require "Pattern_Editor.constants"

-----------------------
-- Set Effect --
-----------------------
function set_effect(type, col)
  local col = col or renoise.song().selected_line.effect_columns[SELECTED_FX_COLUMN]
  local note_col = renoise.song().selected_note_column
  local effect_string = ''

  if type == ARPEGGIO then
    col.number_string = '0A'
    col.amount_string = '00'
    effect_string = 'ARPEGGIO'
  elseif type == SLIDE_UP then
    col.number_string = '0U'
    col.amount_string = '00'
    effect_string = 'SLIDE UP'
  elseif type == SLIDE_DOWN then
    col.number_string = '0D'
    col.amount_string = '00'
    effect_string = 'SLIDE DOWN'
  elseif type == NOTE_DELAY_25 then
    note_col.delay_string = '40'
  elseif type == NOTE_DELAY_50 then
    note_col.delay_string = '80'
  elseif type == NOTE_DELAY_75 then
    note_col.delay_string = 'C0'
  else
    error("Invalid effect type")
    return
  end

  show_status_message(effect_string .." set to col " .. SELECTED_FX_COLUMN .. ".")

end

-----------------------
-- Set effect on all notes --
-----------------------
function set_effect_all_notes(type)
  local song = renoise.song()
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[SELECTED_FX_COLUMN]
    if col then
      set_effect(type, col)
    end
  end
end

-----------------------
-- Set effect on all notes in loop block --
-----------------------
function set_effect_all_notes_in_loop_block(type)
  local song = renoise.song()
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[SELECTED_FX_COLUMN]
    if col then
      set_effect(type, col)
    end
  end
end

-----------------------
-- Increment two sided fx --
-----------------------
function dual_increment_fx(side, amount, col)
  local range = 16 -- 16 because 0-F
  col = col or renoise.song().selected_line.effect_columns[SELECTED_FX_COLUMN]
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

-----------------------
-- Increment single sided fx --
-----------------------
function single_increment_fx(amount, col)
  local range = 256 -- 256 because 00-FF
  col = col or renoise.song().selected_line.effect_columns[SELECTED_FX_COLUMN] 
  if col.number_value == 0 then
    return
  end
  local value = col.amount_value
  value = increment(value, amount, range)
  col.amount_value = value
end

-----------------------
-- Increment note delay, volume, or panning --
-----------------------
function increment_note_property(property, amount)
  local note_col = renoise.song().selected_note_column
  local range = 256
  local value = 0

  if property == DELAY then
    value = note_col.delay_value
  elseif property == VOL then
    value = note_col.volume_value
  elseif property == PAN then
    value = note_col.panning_value
  else
    error("Invalid property")
    return
  end

  value = increment(value, amount, range)

  if property == DELAY then
    note_col.delay_value = value
  elseif property == VOL then
    note_col.volume_value = value
  elseif property == PAN then
    note_col.panning_value = value
  end
end

-----------------------
-- Increment two sided all notes --
-----------------------
function dual_increment_fx_all_notes(side, amount)
  local song = renoise.song()
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[SELECTED_FX_COLUMN]
    if col then
      dual_increment_fx(side, amount, col)
    end
  end
end

-----------------------
-- Increment single sided all notes --
-----------------------
function single_increment_fx_all_notes(amount)
  local song = renoise.song()
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[SELECTED_FX_COLUMN]
    if col then
      single_increment_fx(amount, col)
    end
  end
end

-----------------------
-- Increment two sided in loop block --
-----------------------
function dual_increment_fx_in_loop(side, amount)
  local song = renoise.song()
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[SELECTED_FX_COLUMN]
    if col then
      dual_increment_fx(side, amount, col)
    end
  end
end

-----------------------
-- Increment single sided in loop block --
-----------------------

function single_increment_fx_in_loop(amount)
  local song = renoise.song()
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[SELECTED_FX_COLUMN]
    if col then
      single_increment_fx(amount, col)
    end
  end
end

-----------------------
-- Increment helper --
-----------------------
function increment(value, amount, range)
  -- Error if range is not 16 or 256
  if range ~= 16 and range ~= 256 then
    error("Range must be 16 or 256")
  end
  return (value + amount) % range
end

-----------------------
-- Set FX column  --
-----------------------
function set_fx_column(column)

  if column == FX1 then
    SELECTED_FX_COLUMN = FX1
  elseif column == FX2 then
    SELECTED_FX_COLUMN = FX2
  elseif column == FX3 then
    SELECTED_FX_COLUMN = FX3
  elseif column == FX4 then
    SELECTED_FX_COLUMN = FX4
  elseif column == FX5 then
    SELECTED_FX_COLUMN = FX5
  elseif column == FX6 then
    SELECTED_FX_COLUMN = FX6
  elseif column == FX7 then
    SELECTED_FX_COLUMN = FX7
  elseif column == FX8 then
    SELECTED_FX_COLUMN = FX8
  else
    error("Column must be FX1, FX2, FX3, FX3, FX4, FX5, FX6, FX7, or FX8")
    return
  end
  show_status_message("Selected FX column for edits: " .. SELECTED_FX_COLUMN)
end