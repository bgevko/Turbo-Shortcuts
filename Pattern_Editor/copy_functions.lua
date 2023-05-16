
-- In this file, you'll find all functions that relate to copying and pasting notes and effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua
-- jump() function defined in navigation.lua

require "Pattern_Editor.constants"
--------------------------------------------------------------------------------
-- COPYING FUNCTIONS
--------------------------------------------------------------------------------

---------------------------
-- Nudge line up or down --
---------------------------
function nudge_line(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selected_line = song.selected_line
  local step = (direction == DOWN) and 1 or -1
  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  next_line:copy_from(selected_line)
  selected_line:clear()
  jump(direction)
end

--------------------------------
-- Nudge column up or down --
--------------------------------
function nudge_column(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selection = song.selected_note_column or song.selected_effect_column -- Selects either note or effect column

  if selection == nil then
    return
  end

  local step = (direction == DOWN) and 1 or -1

  if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  local next_column = next_line.note_columns[song.selected_note_column_index]

  -- If selection is not on the note column, then it must be on the effect column
  if (next_column == nil) then
    next_column = next_line.effect_columns[song.selected_effect_column_index]
  end
  next_column:copy_from(selection)
  selection:clear()
  jump(direction)
end

---------------------------
-- Multiporpose copy --
---------------------------
function multi_purpose_copy(mode, direction)
  if mode == LINE then
    copy_line(direction)
  elseif mode == COLUMN then
    copy_column(direction)
  elseif mode == VOL_PAN_DELAY then
    copy_vol_pan_delay(direction)
  elseif mode == EFFECTS then
    copy_effects(direction)
  elseif mode == NOTE_ONLY then
    copy_note_only(direction)
  end
end

-------------------------------
-- Copy entire line and move --
-------------------------------
function copy_line(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selected_line = song.selected_line
  local step = (direction == DOWN) and 1 or -1

  if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  next_line:copy_from(selected_line)
  jump(direction)
end

--------------------------------
-- Copy column value and move --
--------------------------------
function copy_column(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selection = song.selected_note_column or song.selected_effect_column -- Selects either note or effect column

  if selection == nil then
    return
  end

  local step = (direction == DOWN) and 1 or -1

  if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  local next_column = next_line.note_columns[song.selected_note_column_index]

  -- If selection is not on the note column, then it must be on the effect column
  if (next_column == nil) then
    next_column = next_line.effect_columns[song.selected_effect_column_index]
  end
  next_column:copy_from(selection)
  jump(direction)
end

---------------------------
-- Copy vol, pan, delay  --
---------------------------

function copy_vol_pan_delay(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selection = song.selected_note_column

  if selection == nil then
    -- show_status_message("Attempting to copy volume, panning, and delay data, but no note column is selected.")
    return
  end

  local step = (direction == DOWN) and 1 or -1

  if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  local next_column = next_line.note_columns[song.selected_note_column_index]

  if (next_column ~= nil) then
    next_column.volume_value = selection.volume_value
    next_column.volume_string = selection.volume_string
    next_column.panning_value = selection.panning_value
    next_column.panning_string = selection.panning_string
    next_column.delay_value = selection.delay_value
    next_column.delay_string = selection.delay_string
  end
  jump(direction)
end

------------------
-- Copy effects --
------------------
function copy_effects(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selection

  local step = (direction == DOWN) and 1 or -1
    if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  local next_column = next_line.effect_columns

  for i = 1, 8 do
    selection = song.selected_line.effect_columns[i]
    next_column = next_line.effect_columns[i]
    next_column:copy_from(selection)
  end

  jump(direction)
end

------------------
-- Copy note only --
------------------
function copy_note_only(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selection = song.selected_note_column

  print("we made it here")
  if selection == nil then
    return
  end

  local step = (direction == DOWN) and 1 or -1

  if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  local next_column = next_line.note_columns[song.selected_note_column_index]

  if (next_column ~= nil) then
    next_column.note_value = selection.note_value
    next_column.note_string = selection.note_string
    next_column.instrument_value = selection.instrument_value
    next_column.instrument_string = selection.instrument_string
  end
  jump(direction)
end

--------------------------
-- Multi purpose duplicate   --
--------------------------
function multi_purpose_duplicate(number_of_lines)
  -- Multipurpose duplicate function that will duplicate 
  -- based on edit mode
  -- LINE: Duplicate entire line
  -- NOTE_OR_FX: Duplicate either the note column or the effects column
  -- VOL_PAN_DELAY: Duplicate only vol, pan, and delay
  -- EFFECTS: Duplicate everything except for the note
  -- NOTE_ONLY: Duplicate only the note
  
    if (EDIT_MODE == LINE) then
      duplicate_line(number_of_lines)
    -- elseif (EDIT_MODE == NOTE_OR_FX) then
    --   duplicate_selected_column(number_of_lines)
    -- elseif (EDIT_MODE == VOL_PAN_DELAY) then
    --   duplicate_vol_pan_delay(number_of_lines)
    -- elseif (EDIT_MODE == EFFECTS) then
    --   duplicate_vol_pan_delay(number_of_lines)
    --   duplicate_fx_column_data(number_of_lines)
    -- elseif (EDIT_MODE == NOTE_ONLY) then
    --   duplicate_single_selected(NOTE, number_of_lines)
    end
  end 
  
  --------------------------
  -- Duplicate entire line -- Moves your current selection down
  --------------------------
  function duplicate_line(number_of_lines)
    local song = renoise.song()
    local copy_range = get_pattern_block_range(number_of_lines)
    local next_section_start = find_block_start(number_of_lines) + number_of_lines
    local paste_range = get_pattern_block_range(number_of_lines, next_section_start)
    local new_pos = song.transport.edit_pos
  
    for i, line in pairs(paste_range) do
      line:copy_from(copy_range[i])
    end
  
    jump_to_line(next_section_start)
  end
  
  --------------------------
  -- Repeat pattern until last line, starting from current line
  --------------------------
  function repeat_pattern_of_size(pattern_size)
    local song = renoise.song()
    local start_location = song.selected_line_index
    local current_line_index
  
    repeat
      current_line_index = song.selected_line_index
      duplicate_line(pattern_size)
    until current_line_index == song.selected_pattern.number_of_lines
    jump_to_line(start_location)
  end
  
  --------------------------
  -- Set selection to first line within n number of lines
  --------------------------
  function find_block_start(block_size, starting_pos) --starting_pos optional, defaults to current line
    -- Let's assume block size is 4
    -- example 1:
    --   user selection is at arbitrary line 19
    --   This function will return 17 (beginning of the 4 line block)
    -- example 2:
    --   user selection is at arbitrary line 39
    --   This function will return 37 (beginning of the 4 line block)
    local song = renoise.song()
    local current_index = starting_pos or song.selected_line_index 
    while (current_index - 1) % block_size ~= 0 do
      current_index = current_index - 1
    end
    return current_index
  end
  
  --------------------------
  -- Get quantized range from current position --
  --------------------------
  -- Returns a table with the start and end of the quantized range
  function get_pattern_block_range(block_size, starting_pos) -- starting_pos optional, defaults to current line
    local song = renoise.song()
    local range_start = find_block_start(block_size, starting_pos)
    local range_end = range_start + block_size
    local range = song.selected_pattern_track:lines_in_range(range_start, range_end - 1)
    return range
  end