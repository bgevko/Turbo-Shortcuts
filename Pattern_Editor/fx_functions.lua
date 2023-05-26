
-- In this file, you'll find all functions that relate to editing effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua

require "Pattern_Editor.constants"


--[[ SET EFFECT ---------------------------------------------------------------
Parameters: type (constant), col (EffectsColumn object)
Sets an effect to a column based on the provided type.
-----------------------------------------------------------------------------]]
function set_effect(type, col)
  local col = col or renoise.song().selected_line.effect_columns[DEFAULT_FX_COLUMN]
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
  show_status_message(effect_string .." set to col " .. DEFAULT_FX_COLUMN .. ".")
end


--[[ INCREMENT NOTE PROPERTY --------------------------------------------------
Parameters: property (constant), amount (number), note_col (NoteColumn object) (optional)
All multi-note increments use this function.
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
function increment_note_property_all_notes(property, amount)
  local song = renoise.song()
  local notes = get_notes_in_pattern()

  if notes == nil then
    return
  end

  local note_index = song.selected_note_column_index
  for i, line_num in ipairs(notes) do
    local note = song.selected_pattern_track:line(line_num).note_columns[note_index]
    increment_note_property(property, amount, note)
  end
end


--[[ INCREMENT MULTIPLE NOTES BY SUBDIVISION-----------------------------------------
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
      increment_note_property(DELAY, amount, note_col)
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
      randomize_note_property(DELAY, amount, note_col)
    end
  end
end


--[[ RANDOMIZE PROPERTY -------------------------------------------------------
Parameters: property (constant), amount (number), note_col (NoteColumn object) (optional)
Randomizes a property of a note (DELAY, VOL, PAN) by a given amount, plus or minus.
-----------------------------------------------------------------------------]]
function randomize_note_property(property, amount, note_col)
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


--[[ RANDOMIZE PROPERTY ALL NOTES ---------------------------------------------
Parameters: property (constant), amount (number)
Randomizes a property of all notes in a pattern.
-----------------------------------------------------------------------------]]
function randomize_note_property_all_notes(property, amount)
  local song = renoise.song()
  local notes = get_notes_in_pattern()

  if notes == nil then
    return
  end

  local note_index = song.selected_note_column_index
  for i, line_num in ipairs(notes) do
    local note = song.selected_pattern_track:line(line_num).note_columns[note_index]
    randomize_note_property(property, amount, note)
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
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[DEFAULT_FX_COLUMN]
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
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[DEFAULT_FX_COLUMN]
    if col then
      set_effect(type, col)
    end
  end
end


--[[INCREMENT LEFT OR RIGHT DIGIT OF EFFECT (4-BIT)  ---------------------------
  Parameters: digit (X or Y constants), amount (number), col (EffectsColumn object)
  Increments the left or the right digit of an effects value.
  Usage:
  A5C -> inc_4bit_hex_fx(X, 1) -> A6C
  A6C -> inc_4bit_hex_fx(Y, 1) -> A6D
-----------------------------------------------------------------------------]]
function inc_4bit_hex_fx(digit, amount, col)
  local range = 16 -- 0-F
  local selected_fx_index = renoise.song().selected_effect_column_index or DEFAULT_FX_COLUMN
  col = col or renoise.song().selected_line.effect_columns[selected_fx_index]

  if col.number_value == 0 then
    return
  end

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


--[[INCREMENT LEFT OR RIGHT DIGIT OF A NOTE PROPERTY (4-BIT)  ----------------
  Parameters: digit (X or Y constants), amount (number), col (NoteColumn object)
  Increments the left or the right digit of a note property (VOL, PAN, or DELAY)
  This function will increment the following items, ordered by priority:
    1. Non-empty note property (VOL, PAN, or DELAY)
    2. If more than one is non-empty, DEFAULT_NOTE_PROPERTY will be incremented
    3. If all properties are empty, DEFAULT_NOTE_PROPERTY will be incremented
  Usage:
    Usage examples:
    Line    Note   VOL   PAN   DELAY
    1       C-300  --    40    --
    2       C-300  20    --    --
    3       C-300  20    40    10
    4       C-300  --    --    --

    (Selection on line 1) inc_4bit_note_property(X, 1) -> Line 1, PAN = 50
    (Selection on line 1) inc_4bit_note_property(Y, 1) -> Line 1, PAN = 51
    
    (Selection on line 2) inc_4bit_note_property(X, 1) -> Line 2, VOL = 30
    (Selection on line 2) inc_4bit_note_property(Y, 1) -> Line 2, VOL = 31

    (Selection on line 3) inc_4bit_note_property(X, 1) -> Line 3, VOL = 30 (VOL is default note property)
    (Selection on line 3) inc_4bit_note_property(Y, 1) -> Line 3, VOL = 31 (VOL is default note property)

    (Selection on line 4) inc_4bit_note_property(X, 1) -> Line 4, VOL = 30 (VOL is default note property)
    (Selection on line 4) inc_4bit_note_property(Y, 1) -> Line 4, VOL = 31 (VOL is default note property)
-----------------------------------------------------------------------------]]
function inc_4bit_note_property(digit, amount, col)
  local range = 16 -- 0-F
  local note_column_index = renoise.song().selected_note_column_index or 1
  col = col or renoise.song().selected_line.note_columns[note_column_index]

  local priority = get_vol_pan_delay_priority(col)
  local x
  local y

  -- Set x and y to the value based on priority
  if priority == VOL then
    x = bit.band(bit.rshift(col.volume_value, 4), 0xF)
    y = bit.band(col.volume_value, 0xF)
  elseif priority == PAN then
    x = bit.band(bit.rshift(col.panning_value, 4), 0xF)
    y = bit.band(col.panning_value, 0xF)
  elseif priority == DELAY then
    x = bit.band(bit.rshift(col.delay_value, 4), 0xF)
    y = bit.band(col.delay_value, 0xF)
  else
    error("Invalid priority")
  end

  -- Increment x or y
  if digit == X then
    x = increment(x, amount, range)
  elseif digit == Y then
    y = increment(y, amount, range)
  else
    error("Invalid digit")
  end

  -- Set the value based on priority
  if priority == VOL then
    col.volume_value = bit.bor(bit.band(col.volume_value, 0xF), bit.lshift(x, 4))
    col.volume_value = bit.bor(bit.band(col.volume_value, bit.lshift(0xF, 4)), y)
  elseif priority == PAN then
    col.panning_value = bit.bor(bit.band(col.panning_value, 0xF), bit.lshift(x, 4))
    col.panning_value = bit.bor(bit.band(col.panning_value, bit.lshift(0xF, 4)), y)
  elseif priority == DELAY then
    col.delay_value = bit.bor(bit.band(col.delay_value, 0xF), bit.lshift(x, 4))
    col.delay_value = bit.bor(bit.band(col.delay_value, bit.lshift(0xF, 4)), y)
  else
    error("Invalid priority")
  end
end


--[[ GET VOL PAN OR DELAY PRIORITY --------------------------------------------
  Parameters: col (NoteColumn object)
  This is a helper function for inc_4bit_note_property. It returns a property
    if it is the only non-emptry property for the selected note column, otherwise
    it returns DEFAULT_NOTE_PROPERTY.
  ---------------------------------------------------------------------------]]
function get_vol_pan_delay_priority(col)
  if col == nil then
    return
  end

  local vol = col.volume_string
  local pan = col.panning_string
  local delay = col.delay_string

  if vol ~= ".." and pan == ".." and delay == ".." then
    return VOL
  elseif vol == ".." and pan ~= ".." and delay == ".." then
    return PAN
  elseif vol == ".." and pan == ".." and delay ~= ".." then
    return DELAY
  else
    return DEFAULT_NOTE_PROPERTY
  end
end

--[[ INCREMENT EFFECT CHRONOLOGICALLY (8-BIT) ---------------------------------
Parameters: amount (number), col (EffectsColumn object) (optional)
Increments effects hex value chronologically.
  Usage:
  A5C -> inc_8bit_hex_fx(1)  -> A5D
  A5D -> inc_8bit_hex_fx(-1) -> A6C
-----------------------------------------------------------------------------]]
function inc_8bit_hex_fx(amount, col)
  local range = 256 -- 256 because 00-FF
  local selected_fx_index = renoise.song().selected_effect_column_index or DEFAULT_FX_COLUMN
  col = col or renoise.song().selected_line.effect_columns[selected_fx_index] 
  if col.number_value == 0 then
    return
  end
  local value = col.amount_value
  value = increment(value, amount, range)
  col.amount_value = value
end


--[[ INCREMENT 4-BIT EFFECTS FOR ALL NOTES -----------------------------------
Parameters: side (constant), amount (number)
Increments the left or the right digit of an effects value, for all notes in a pattern.
  Usage:
  A5C -> inc_4bit_fx_all_notes(X, 1) -> A6C (for all notes in pattern)
-----------------------------------------------------------------------------]]
function inc_4bit_fx_all_notes(side, amount)
  local song = renoise.song()
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[DEFAULT_FX_COLUMN]
    if col then
      inc_4bit_hex_fx(side, amount, col)
    end
  end
end


--[[ INCREMENT 8-BIT EFFECTS FOR ALL NOTES -----------------------------------
Parameters: amount (number)
Increments effects hex value chronologically, for all notes in a pattern.
  Usage:
  A5C -> inc_8bit_fx_all_notes(1)  -> A5D (for all notes in pattern)
  A5D -> inc_8bit_fx_all_notes(-1) -> A6C (for all notes in pattern)
-----------------------------------------------------------------------------]]
function inc_8bit_fx_all_notes(amount)
  local song = renoise.song()
  local note_positions = get_notes_in_pattern()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[DEFAULT_FX_COLUMN]
    if col then
      inc_8bit_hex_fx(amount, col)
    end
  end
end


--[[ INCREMENT 4-BIT EFFECTS FOR ALL NOTES IN LOOP ---------------------------
Parameters: side (constant), amount (number)
Increments the left or the right digit of an effects value, for all notes 
within a loop block in a pattern.
  Usage:
  A5C -> inc_4bit_fx_loop(X, 1) -> A6C (for all notes in loop)
-----------------------------------------------------------------------------]]
function inc_4bit_fx_loop(side, amount)
  local song = renoise.song()
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[DEFAULT_FX_COLUMN]
    if col then
      inc_4bit_hex_fx(side, amount, col)
    end
  end
end


--[[ INCREMENT 8-BIT EFFECTS FOR ALL NOTES IN LOOP ---------------------------
Parameters: amount (number)
Increments effects hex value chronologically, for all notes within a loop block
in a pattern.
  Usage:
  A5C -> inc_8bit_fx_all_notes_in_loop(1)  -> A5D (for all notes in loop)
  A5D -> inc_8bit_fx_all_notes_in_loop(-1) -> A6C (for all notes in loop)
-----------------------------------------------------------------------------]]
function inc_8bit_fx_loop(amount)
  local song = renoise.song()
  local note_positions = get_notes_in_loop_block()

  if note_positions == nil then
    return
  end

  for i = 1, #note_positions do
    local col = song.selected_pattern_track:line(note_positions[i]).effect_columns[DEFAULT_FX_COLUMN]
    if col then
      inc_8bit_hex_fx(amount, col)
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
function set_fx_column(column)
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