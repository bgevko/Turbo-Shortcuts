
-- In this file, you'll find all functions that relate to editing effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua

require "Pattern_Editor.constants"


--[[ NOTE EFFECTS CLASS ------------------------------------------------------------
Master class for setting effects.
-----------------------------------------------------------------------------]]
local TrackEffects = {}
function TrackEffects:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

--[[ SET EFFECTS MASTER METHOD ------------------------------------------------
This is a master class for setting effects. I created a class to keep the 
logic all in one place. NoteEffects and MasterEffects will inherit from this.
  Usage:
  NoteEffects:set(ARPEGGIO, 5) -> sets arpeggio in the note column, line 5
  TrackEffects:set(ARPEGGIO, 5) -> sets arpeggio in the effects column, line 5
  MasterEffects:set(ARPEGGIO, 5) -> sets arpeggio in the master track, line 5
-----------------------------------------------------------------------------]]
function TrackEffects:set(type, line_num)
  if type == ARPEGGIO then
    self:_set_fx('0A', '00', line_num)
  elseif type == SLIDE_UP then
    self:_set_fx('0U', '00', line_num)
  elseif type == SLIDE_DOWN then
    self:_set_fx('0D', '00', line_num)
  elseif type == DELAY_25 then
    self:_set_fx('0Q', '40', line_num)
  elseif type == DELAY_50 then
    self:_set_fx('0Q', '80', line_num)
  elseif type == DELAY_75 then
    self:_set_fx('0Q', 'C0', line_num)
  else
    error("Invalid effect type")
    return
  end
  show_status_message(type .. " effect set in " .. FX_EDIT_MODE .. " scope.")
end

--[[ SET EFFECTS ALL NOTES ------------------------------------------------]]
function TrackEffects:set_all(type)
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    TrackEffects:set(type, note_positions[i])
  end
end

--[[ SET EFFECTS ALL NOTES IN LOOP ------------------------------------------------]]
function TrackEffects:set_loop(type)
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    TrackEffects:set(type, note_positions[i])
  end
end

--[[ INCREMENT LEFT BIT ------------------------------------------------]]
function TrackEffects:inc_left(amount, line_num)
  TrackEffects:_inc_4bit_hex(X, amount, line_num)
end

--[[ INCREMENT RIGHT BIT ------------------------------------------------]]
function TrackEffects:inc_right(amount, line_num)
  TrackEffects:_inc_4bit_hex(Y, amount, line_num)
end

--[[ INCREMENT LEFT BIT ALL NOTES ------------------------------------------------]]
function TrackEffects:inc_left_all(amount)
  local note_positions = get_notes_in_pattern()
  
  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    TrackEffects:_inc_4bit_hex(X, amount, note_positions[i])
  end
end

--[[ INCREMENT RIGHT BIT ALL NOTES ------------------------------------------------]]
function TrackEffects:inc_right_all(amount)
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    TrackEffects:_inc_4bit_hex(Y, amount, note_positions[i])
  end
end

--[[ INCREMENT LEFT BIT ALL NOTES IN LOOP ------------------------------------------------]]
function TrackEffects:inc_left_loop(amount)
  local note_positions = get_notes_in_loop_block()
  
  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    TrackEffects:_inc_4bit_hex(X, amount, note_positions[i])
  end
end

--[[ INCREMENT RIGHT BIT ALL NOTES IN LOOP ------------------------------------------------]]
function TrackEffects:inc_right_loop(amount)
  local note_positions = get_notes_in_loop_block()
  
  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    TrackEffects:_inc_4bit_hex(Y, amount, note_positions[i])
  end
end

--[[ INCREMENT EFFECTS CHRONOLOGICALLY ------------------------------------------------]]
function TrackEffects:inc(amount, line_num)
  TrackEffects:_inc_8bit_hex(amount, line_num)
end

--[[ INCREMENT EFFECTS CHRONOLOGICALLY ALL NOTES ------------------------------------------------]]
function TrackEffects:inc_all(amount)
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    TrackEffects:_inc_8bit_hex(amount, note_positions[i])
  end
end

--[[ INCREMENT EFFECTS CHRONOLOGICALLY ALL NOTES IN LOOP ------------------------------------------------]]
function TrackEffects:inc_all_loop(amount)
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    TrackEffects:_inc_8bit_hex(amount, note_positions[i])
  end
end


--[[ SET EFFECTS TRACK ------------------------------------------------
This method overrides NoteEffects:_set_fx() to handle getting the correct
column and property names for setting effects in the track column. Do not use this
this directly, use the TrackEffects:set() method instead.
-----------------------------------------------------------------------------]]
function TrackEffects:_set_fx(fx_number_string, fx_amount_string, line_num)
  local song = renoise.song()
  local fx_column_index = song.selected_effect_column_index
  if fx_column_index == 0 then
    fx_column_index = DEFAULT_FX_COLUMN
  end
  local col = song.selected_pattern_track:line(line_num).effect_columns[fx_column_index]

  col.number_string = fx_number_string
  col.amount_string = fx_amount_string
end

--[[ INCREMENT 4-BIT HEX TRACK EFFECTS ------------------------------------------------
Helper method that handles incrementing 4-bit hex values. This is a private method
Don't use directly, use TrackEffects:inc_left() or TrackEffects:inc_right() instead.
-----------------------------------------------------------------------------]]
function TrackEffects:_inc_4bit_hex(digit, amount, line_num)
  local song = renoise.song()
  local range = 16
  if line_num == nil then
    line_num = song.selected_line_index
  end
  local fx_column_index = song.selected_effect_column_index
  if fx_column_index == 0 then
    fx_column_index = DEFAULT_FX_COLUMN
  end
  local col = song.selected_pattern_track:line(line_num).effect_columns[fx_column_index]

  if digit == X then
    local x = bit.band(bit.rshift(col.amount_value, 4), 0xF)
    x = increment(x, amount, range)
    col.amount_value = bit.bor(bit.band(col.amount_value, 0xF), bit.lshift(x, 4))
  elseif digit == Y then
    local y = bit.band(col.amount_value, 0xF)
    y = increment(y, amount, range)
    col.amount_value = bit.bor(bit.band(col.amount_value, bit.lshift(0xF, 4)), y)
  else
    error("Invalid digit")
  end
end

--[[ INCREMENT 8-BIT HEX TRACK EFFECTS ------------------------------------------------
Helper method that handles incrementing 8-bit hex values. This is a private method
Don't use directly, use TrackEffects:inc() instead.
-----------------------------------------------------------------------------]]
function TrackEffects:_inc_8bit_hex(amount, line_num)
  local song = renoise.song()
  local range = 256
  if line_num == nil then
    line_num = song.selected_line_index
  end
  local fx_column_index = song.selected_effect_column_index
  if fx_column_index == 0 then
    fx_column_index = DEFAULT_FX_COLUMN
  end
  local col = song.selected_pattern_track:line(line_num).effect_columns[fx_column_index]

  local value = col.amount_value
  value = increment(value, amount, range)
  col.amount_value = value
end


--[[ NOTE EFFECTS CLASS ------------------------------------------------------------
NoteEffects class that inherits from TrackEffects.
-----------------------------------------------------------------------------]]
NoteEffects = TrackEffects:new()

--[[ SET NOTE EFFECTS ------------------------------------------------
This is a private method specific to NoteEffects class. It handles getting the correct
column and property names for setting effects in the note column. Do not use this
directly, use the NoteEffects:set() method instead.
-----------------------------------------------------------------------------]]
function NoteEffects:_set_fx(fx_number_string, fx_amount_string, line_num)
  local song = renoise.song()
  local note_column_index = song.selected_note_column_index
  if note_column_index == 0 then
    note_column_index = 1
  end
  local col = song.selected_pattern_track:line(line_num).note_columns[note_column_index]

  -- If the effect is delay, set it to delay column instead of note fx column
  if fx_number_string == '0Q' then
    col.delay_value = fx_amount_string
    return
  end

  col.effect_number_string = fx_number_string
  col.effect_amount_string = fx_amount_string
end

--[[ INCREMENT 4-BIT HEX NOTE EFFECTS ------------------------------------------------
Helper method that handles incrementing 4-bit hex values. This is a private method
Don't use directly, use NoteEffects:inc_left() or NoteEffects:inc_right() instead.
-----------------------------------------------------------------------------]]
function NoteEffects:_inc_4bit_hex(digit, amount, line_num)
  local song = renoise.song()
  local range = 16
  if line_num == nil then
    line_num = song.selected_line_index
  end
  local note_column_index = song.selected_note_column_index
  if note_column_index == 0 then
    note_column_index = 1
  end
  local col = song.selected_pattern_track:line(line_num).note_columns[note_column_index]

  if digit == X then
    local x = bit.band(bit.rshift(col.effect_amount_value, 4), 0xF)
    x = increment(x, amount, range)
    col.effect_amount_value = bit.bor(bit.band(col.effect_amount_value, 0xF), bit.lshift(x, 4))
  elseif digit == Y then
    local y = bit.band(col.effect_amount_value, 0xF)
    y = increment(y, amount, range)
    col.effect_amount_value = bit.bor(bit.band(col.effect_amount_value, bit.lshift(0xF, 4)), y)
  else
    error("Invalid digit")
  end
end

--[[ INCREMENT 8-BIT HEX NOTE EFFECTS ------------------------------------------------
Helper method that handles incrementing 8-bit hex values. This is a private method
Don't use directly, use NoteEffects:inc() instead.
-----------------------------------------------------------------------------]]
function NoteEffects:_inc_8bit_hex(amount, line_num)
  local song = renoise.song()
  local range = 256
  if line_num == nil then
    line_num = song.selected_line_index
  end
  local note_column_index = song.selected_note_column_index
  if note_column_index == 0 then
    note_column_index = 1
  end
  local col = song.selected_pattern_track:line(line_num).note_columns[note_column_index]

  local value = col.effect_amount_value
  value = increment(value, amount, range)
  col.effect_amount_value = value
end

--[[INCREMENT LEFT OR RIGHT DIGIT OF A NOTE PROPERTY (4-BIT)  ----------------
Helper method that handles incrementing 4-bit note properties. This is a private method
Don't use directly, use NoteEffects:inc_prop_left() or NoteEffects:inc_prop_right() instead.
-----------------------------------------------------------------------------]]
function NoteEffects:_inc_4bit_note_property(digit, property, amount, line_num)
  local song = renoise.song()
  local range = 16 -- 0-F
  if line_num == nil then
    line_num = renoise.song().selected_line_index
  end
  local note_column_index = song.selected_note_column_index
  if note_column_index == 0 then
    note_column_index = 1
  end
  local col = song.selected_pattern_track:line(line_num).note_columns[note_column_index]
  local x
  local y

  -- Set x and y to the value based on property
  if property == VOL then
    x = bit.band(bit.rshift(col.volume_value, 4), 0xF)
    y = bit.band(col.volume_value, 0xF)
  elseif property == PAN then
    x = bit.band(bit.rshift(col.panning_value, 4), 0xF)
    y = bit.band(col.panning_value, 0xF)
  elseif property == DELAY then
    x = bit.band(bit.rshift(col.delay_value, 4), 0xF)
    y = bit.band(col.delay_value, 0xF)
  else
    error("Invalid property")
  end

  -- Increment x or y
  if digit == X then
    x = increment(x, amount, range)
  elseif digit == Y then
    y = increment(y, amount, range)
  else
    error("Invalid digit")
  end

  -- Set the value based on property
  if property == VOL then
    col.volume_value = bit.bor(bit.band(col.volume_value, 0xF), bit.lshift(x, 4))
    col.volume_value = bit.bor(bit.band(col.volume_value, bit.lshift(0xF, 4)), y)
  elseif property == PAN then
    col.panning_value = bit.bor(bit.band(col.panning_value, 0xF), bit.lshift(x, 4))
    col.panning_value = bit.bor(bit.band(col.panning_value, bit.lshift(0xF, 4)), y)
  elseif property == DELAY then
    col.delay_value = bit.bor(bit.band(col.delay_value, 0xF), bit.lshift(x, 4))
    col.delay_value = bit.bor(bit.band(col.delay_value, bit.lshift(0xF, 4)), y)
  else
    error("Invalid property")
  end
end

--[[ INCREMENT NOTE PROPERTY LEFT BIT -----------------------------------------
Parameters: property: (VOL, PAN, DELAY), amount(number), line_num(number) (optional)]]
function NoteEffects:inc_prop_left(property, amount, line_num)
  self:_inc_4bit_note_property(X, property, amount, line_num)
end

--[[ INCREMENT NOTE PROPERTY LEFT BIT ALL NOTES --------------------------------]]
function NoteEffects:inc_prop_left_all(property, amount)
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    self:_inc_4bit_note_property(X, property, amount, note_positions[i])
  end
end

--[[ INCREMENT NOTE PROPERTY LEFT BIT ALL NOTES IN LOOP ------------------------]]
function NoteEffects:inc_prop_left_loop(property, amount)
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    self:_inc_4bit_note_property(X, property, amount, note_positions[i])
  end
end

--[[ INCREMENT NOTE PROPERTY RIGHT BIT -----------------------------------------]]
function NoteEffects:inc_prop_right(property, amount, line_num)
  self:_inc_4bit_note_property(Y, property, amount, line_num)
end

--[[ INCREMENT NOTE PROPERTY RIGHT BIT ALL NOTES --------------------------------]]
function NoteEffects:inc_prop_right_all(property, amount)
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    self:_inc_4bit_note_property(Y, property, amount, note_positions[i])
  end
end

--[[ INCREMENT NOTE PROPERTY RIGHT BIT ALL NOTES IN LOOP ------------------------]]
function NoteEffects:inc_prop_right_loop(property, amount)
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    self:_inc_4bit_note_property(Y, property, amount, note_positions[i])
  end
end

--[[ INCREMENT NOTE PROPERTY --------------------------------------------------
Parameters: property (constant), amount (number), line_num (number) (optional)
Increments a property of a note (DELAY, VOL, PAN) chronologically.
-----------------------------------------------------------------------------]]
function NoteEffects:inc_prop(property, amount, line_num)
  local song = renoise.song()
  if line_num == nil then
    line_num = renoise.song().selected_line_index
  end
  local note_column_index = song.selected_note_column_index
  if note_column_index == 0 then
    note_column_index = 1
  end
  local note_col = song.selected_pattern_track:line(line_num).note_columns[note_column_index]

  if note_col == nil then
    note_col = 1
  end

  local range = 256
  local value = 0

  if property == DELAY then
    value = note_col.delay_value
  elseif property == VOL then
    value = note_col.volume_value
  elseif property == PAN then
    value = note_col.panning_value
    range = 128
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


--[[ INCREMENT NOTE PROPERTY ALL ----------------------------------------------
Parameters: property (constant), amount (number)
Increments a property of all notes in a pattern.
-----------------------------------------------------------------------------]]
function NoteEffects:inc_prop_all(property, amount)
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    self:inc_prop(property, amount, note_positions[i])
  end
end

--[[ INCREMENT NOTE PROPERTY ALL NOTES IN LOOP ----------------------------------------------
Parameters: property (constant), amount (number)
Increments a property of all notes in loop block.
-----------------------------------------------------------------------------]]
function NoteEffects:inc_prop_loop(property, amount)
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    self:inc_prop(property, amount, note_positions[i])
  end
end

--[[ RANDOMIZE PROPERTY -------------------------------------------------------
Parameters: property (VOL, PAN, DELAY), amount (number), line_num (optional)
-----------------------------------------------------------------------------]]
function NoteEffects:randomize_prop(property, amount, line_num)
  local song = renoise.song()
  if line_num == nil then
    line_num = renoise.song().selected_line_index
  end
  local note_column_index = song.selected_note_column_index
  if note_column_index == 0 then
    note_column_index = 1
  end
  local note_col = song.selected_pattern_track:line(line_num).note_columns[note_column_index]

  if note_col == nil then
      note_col = 1
  end

  local range = 256
  local value = 0

  if property == DELAY then
    value = note_col.delay_value
  elseif property == VOL then
    value = note_col.volume_value
  elseif property == PAN then
    value = note_col.panning_value
    range = 128
  else
    error("Invalid property")
    return
  end

  value = randomize(value, amount, range)

  if property == DELAY then
    note_col.delay_value = value
  elseif property == VOL then
    note_col.volume_value = value
  elseif property == PAN then
    note_col.panning_value = value
  end
end

--[[ RANDOMIZE PROPERTY ALL NOTES ---------------------------------------------]]
function NoteEffects:randomize_prop_all(property, amount)
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    self:randomize_prop(property, amount, note_positions[i])
  end
end

--[[ RANDOMIZE PROPERTY ALL NOTES IN LOOP ---------------------------------------------]]
function NoteEffects:randomize_prop_loop(property, amount)
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    self:randomize_prop(property, amount, note_positions[i])
  end
end


--[[ SET TRACK EFFECT ---------------------------------------------------------------
Parameters: type (constant), line_num(number)(optional) ------------------------]]
function set_track_effect(type, line_num)
  local line_num = line_num or renoise.song().selected_line_index
  TrackEffects:set(type, line_num)
end

--[[ SET NOTE EFFECT ---------------------------------------------------------------
Parameters: type (constant), line_num(number)(optional) ------------------------]]
function set_note_effect(type, line_num)
  local line_num = line_num or renoise.song().selected_line_index
  NoteEffects:set(type, line_num)
end


--[[ INCREMENT GROOVE BY SUBDIVISION-----------------------------------------
Parameters: property (constant), subdivision (constant), amount (number)
Increments a property of multiple notes based on a specified subdivision.
-----------------------------------------------------------------------------]]
function increment_groove(subdivision, amount)
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

  local note_index = song.selected_note_column_index or 1
  for i = start_point, max_lines, interval do
    local note_col = song.selected_pattern_track:line(i).note_columns[note_index]
    if note_col then
      NoteEffects:inc_prop(DELAY, amount, note_col)
    end
  end
end


--[[ RANDOMIZE GROOVE BY SUBDIVISION -----------------------------------------
Parameters: subdivision (constant), amount (number)
Randomizes groove by a specified subdivision.
-----------------------------------------------------------------------------]]
function randomize_groove(subdivision, amount)
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
  local note_index = song.selected_note_column_index or 1

  for i = start_point, max_lines, interval do
    local note_col = song.selected_pattern_track:line(i).note_columns[note_index]
    if note_col then
      NoteEffects:randomize_prop(DELAY, amount, note_col)
    end
  end
end


--[[ INCREMENT HELPER ---------------------------------------------------------
Parameters: value (number), amount (number), range (number)
Helper function to handle the increment of values.
-----------------------------------------------------------------------------]]
function increment(value, amount, range)

  if range ~= 16 and range ~= 128 and range ~= 256 then
    error("Range must be 16 or 128 or 256")
  end
  return (value + amount) % range
end


--[[ RANDOMIZE HELPER ---------------------------------------------------------
Parameters: initial_value (number), amount (number), range (number)
Takes an initial value and randomizes it by a given amount within a given range.
-----------------------------------------------------------------------------]]
function randomize(initial_value, amount, range)
  local value = initial_value + math.random(-amount, amount)
  if value < 0 then
    value = 0
  elseif value > range then
    value = range
  end
  return value
end


--[[ SET FX COLUMN ------------------------------------------------------------
Parameters: column (constant)
Sets the selected FX column for edits.
-----------------------------------------------------------------------------]]
function set_default_fx_column(column)
  if column == FX1 then
    DEFAULT_FX_COLUMN = FX1
  elseif column == FX2 then
    DEFAULT_FX_COLUMN = FX2
  elseif column == FX3 then
    DEFAULT_FX_COLUMN = FX3
  elseif column == FX4 then
    DEFAULT_FX_COLUMN = FX4
  elseif column == FX5 then
    DEFAULT_FX_COLUMN = FX5
  elseif column == FX6 then
    DEFAULT_FX_COLUMN = FX6
  elseif column == FX7 then
    DEFAULT_FX_COLUMN = FX7
  elseif column == FX8 then
    DEFAULT_FX_COLUMN = FX8
  else
    error("Column must be FX1, FX2, FX3, FX3, FX4, FX5, FX6, FX7, or FX8")
    return
  end
  show_status_message("Selected FX column for edits: " .. DEFAULT_FX_COLUMN)
end


--[[ SET FX EDIT MODE ------------------------------------------------------------
Parameters: mode (constant)
Sets the effects edit mode. LOCAL will edit note effects, TRACK will edit
effects for the entire track, and MASTER will edit effects for the master track.
-----------------------------------------------------------------------------]]
set_fx_edit_mode = function(mode)
  if mode == FX_LOCAL then
    FX_EDIT_MODE = FX_LOCAL
  elseif mode == FX_TRACK then
    FX_EDIT_MODE = FX_TRACK
  elseif mode == FX_MASTER then
    FX_EDIT_MODE = FX_MASTER
  else
    error("Mode must be LOCAL, TRACK, or MASTER")
    return
  end
  show_status_message("Effects edit mode: " .. FX_EDIT_MODE)
end