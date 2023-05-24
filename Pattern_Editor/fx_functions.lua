
-- In this file, you'll find all functions that relate to editing effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua

require "Pattern_Editor.constants"


--[[ SET EFFECT ---------------------------------------------------------------
Parameters: type (constant), col (EffectsColumn object)
Sets an effect to a column based on the provided type.
-----------------------------------------------------------------------------]]
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


--[[ INCREMENT NOTE PROPERTY --------------------------------------------------
Parameters: property (constant), amount (number), note_col (NoteColumn object)
Increments a property of a note (DELAY, VOL, PAN).
-----------------------------------------------------------------------------]]
function increment_note_property(property, amount, note_col)
  local note_col = note_col or renoise.song().selected_note_column

  if note_col == nil then
    return
  end

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


--[[ INCREMENT NOTE PROPERTY MULTIPLE -----------------------------------------
Parameters: property (constant), subdivision (constant), amount (number)
Increments a property of multiple notes based on a specified subdivision.
-----------------------------------------------------------------------------]]
function inc_note_property_multiple(property, subdivision, amount)
  local song = renoise.song()
  local max_lines = song.selected_pattern.number_of_lines
  local multipler = 1
  local start_point_modifier = 1

  if subdivision == EIGHTH then
    multipler = 2
  elseif subdivision == SIXTEENTH then
    multipler = 1
    start_point_modifier = 0
  else
    error("Invalid subdivision")
  end

  local interval = multipler * math.floor(song.transport.lpb / 4)
  local start_point = math.floor(song.transport.lpb / 4) + start_point_modifier

  for i = start_point, max_lines, interval do
    local note_col = song.selected_pattern_track:line(i).note_columns[1]
    if note_col then
      increment_note_property(property, amount, note_col)
    end
  end
end


--[[ SET EFFECT ALL NOTES -----------------------------------------------------
Parameters: type (constant)
Applies a specific effect to all notes in a pattern.
-----------------------------------------------------------------------------]]
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


--[[ SET EFFECT ALL NOTES IN LOOP BLOCK ---------------------------------------
Parameters: type (constant)
Applies a specific effect to all notes within a loop block in a pattern.
-----------------------------------------------------------------------------]]
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


--[[ DUAL INCREMENT FX --------------------------------------------------------
Parameters: side (constant), amount (number), col (EffectsColumn object)
Increments the value of either xx-- or --yy side of a dual-sided effect.
-----------------------------------------------------------------------------]]
function dual_increment_fx(side, amount, col)
  local range = 16 -- 16 because 0-F
  col = col or renoise.song().selected_line.effect_columns[SELECTED_FX_COLUMN]
  if col.number_value == 0 then
    return
  end
  if side == X then
    local x = bit.band(bit.rshift(col.amount_value, 4), 0xF)
    x = increment(x, amount, range)
    col.amount_value = bit.bor(bit.band(col.amount_value, 0xF), bit.lshift(x, 4))
  elseif side == Y then
    local y = bit.band(col.amount_value, 0xF)
    y = increment(y, amount, range)
    col.amount_value = bit.bor(bit.band(col.amount_value, bit.lshift(0xF, 4)), y)
  else
    error("Invalid side, must be X or Y")
  end
end


--[[ SINGLE INCREMENT FX ------------------------------------------------------
Parameters: amount (number), col (EffectsColumn object)
Increments the value of a single-sided effect.
-----------------------------------------------------------------------------]]
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


--[[ DUAL INCREMENT FX ALL NOTES ----------------------------------------------
Parameters: side (constant), amount (number)
Applies a dual increment effect to all notes in a pattern.
-----------------------------------------------------------------------------]]
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


--[[ SINGLE INCREMENT FX ALL NOTES --------------------------------------------
Parameters: amount (number)
Applies a single increment effect to all notes in a pattern.
-----------------------------------------------------------------------------]]
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


--[[ DUAL INCREMENT FX IN LOOP ------------------------------------------------
Parameters: side (constant), amount (number)
Applies a dual increment effect to all notes within a loop block in a pattern.
-----------------------------------------------------------------------------]]
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


--[[ SINGLE INCREMENT FX IN LOOP ----------------------------------------------
Parameters: amount (number)
Applies a single increment effect to all notes within a loop block in a pattern.
-----------------------------------------------------------------------------]]
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


--[[ INCREMENT HELPER ---------------------------------------------------------
Parameters: value (number), amount (number), range (number)
Helper function to handle the increment of values.
-----------------------------------------------------------------------------]]
function increment(value, amount, range)
  -- Error if range is not 16 or 256
  if range ~= 16 and range ~= 256 then
    error("Range must be 16 or 256")
  end
  return (value + amount) % range
end


--[[ SET FX COLUMN ------------------------------------------------------------
Parameters: column (constant)
Sets the selected FX column for edits.
-----------------------------------------------------------------------------]]
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