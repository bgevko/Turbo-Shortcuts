_AUTO_RELOAD_DEBUG = true

-- Navigation directions
local UP = 1
local DOWN = 2

-- Edit modes
local LINE = 1
local NOTE_OR_FX = 2
local VOL_PAN_DELAY = 3
local ALL_BUT_NOTE = 4
local NOTE_ONLY = 5

-- Note parameters (for deleting)
local NOTE = 1
local VOL = 2
local PAN = 3
local DELAY = 4
local FX = 5

-- Default delete mode
local EDIT_MODE = LINE


--------------------------------------------------------------------------------
-- KEY BINDINGS
--------------------------------------------------------------------------------

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Nudge note up",
  invoke = function() nudge_note(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Nudge note down",
  invoke = function() nudge_note(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy line and move down",
  invoke = function() copy_line(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy line and move up",
  invoke = function() copy_line(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy column and move down",
  invoke = function() copy_column(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy column and move up",
  invoke = function() copy_column(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy vol, pan, delay and move down",
  invoke = function() copy_vol_pan_delay(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy vol, pan, delay and move up",
  invoke = function() copy_vol_pan_delay(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy effect column and move down",
  invoke = function() copy_effects(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy effect column and move up",
  invoke = function() copy_effects(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Duplicate 4 lines",
  invoke = function() multi_purpose_duplicate(4) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Duplicate 8 lines",
  invoke = function() multi_purpose_duplicate(8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Duplicate 16 lines",
  invoke = function() multi_purpose_duplicate(16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Duplicate 32 lines",
  invoke = function() multi_purpose_duplicate(32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Fill 4-line pattern (from current line)",
  invoke = function() repeat_pattern_of_size(4) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Fill 8-line pattern (from current line)",
  invoke = function() repeat_pattern_of_size(8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Fill 16-line pattern (from current line)",
  invoke = function() repeat_pattern_of_size(16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Fill 32-line pattern (from current line)",
  invoke = function() repeat_pattern_of_size(32) end
}

--------------------------------------------------
-- Delete keybindings
--------------------------------------------------
renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Multi purpose delete (uses delete modes)",
  invoke = function() multi_purpose_delete(EDIT_MODE) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Delete Mode to Line",
  invoke = function() set_edit_mode(LINE) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Delete Mode to Full note or FX",
  invoke = function() set_edit_mode(NOTE_OR_FX) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Delete Mode to volume, pan, delay only",
  invoke = function() set_edit_mode(VOL_PAN_DELAY) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Delete Mode to delete all but note data",
  invoke = function() set_edit_mode(ALL_BUT_NOTE) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Delete Mode to delete note only",
  invoke = function() set_edit_mode(NOTE_ONLY) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Delete entire line",
  invoke = function() delete_line() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Delete only selected note",
  invoke = function() delete_single_selected(NOTE) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Delete selected column",
  invoke = function() delete_selected_column() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Delete FX column for current line",
  invoke = function() delete_fx_column_data() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Delete entire track",
  invoke = function() delete_entire_track() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Delete entire column",
  invoke = function() delete_entire_column() end
}

--------------------------------------------------------------------------------
-- COPYING FUNCTIONS
--------------------------------------------------------------------------------

-- Note: The jump() function used below is in another file, pattern_editor_navigation.lua

---------------------------
-- Nudge note up or down --
---------------------------
function nudge_note(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selected_line = song.selected_line
  local step = (direction == DOWN) and 1 or -1
  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  next_line:copy_from(selected_line)
  selected_line:clear()
  jump(direction)
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


--------------------------------------------------------------------------------
-- DELETE FUNCTIONS
--------------------------------------------------------------------------------

-----------------------------------------
-- Delete function with multiple modes --
-----------------------------------------
function multi_purpose_delete(type)
  -- Intended use: 
  -- Map this function to a keybinding, and 
  -- map changing the edit mode to another keybinding. Then,
  -- you can change the edit mode and delete different things, 
  -- depending on what you're working on
  -- 
  -- LINE: Delete entire line
  -- NOTE_OR_FX: Deletes the column that's selected, including vol, pan, and delay (either note or effect)
  -- VOL_PAN_DELAY: Deletes only vol, pan, and delay
  -- ALL_BUT_NOTE: Deletes vol, pan, delay, and all effect columns. Preserves note data
  -- NOTE_ONLY: Deletes only the note data, leaving vol, pan, delay, and effect columns intact

  if (type == LINE) then
    delete_line()
  elseif (type == NOTE_OR_FX) then
    delete_selected_column()
  elseif (type == VOL_PAN_DELAY) then
    delete_vol_pan_delay()
  elseif (type == ALL_BUT_NOTE) then
    delete_vol_pan_delay()
    delete_fx_column_data()
  elseif (type == NOTE_ONLY) then
    delete_single_selected(NOTE)
  end
end

------------------------
-- Delete entire line --
------------------------
function delete_line()
  local song = renoise.song()
  song.selected_line:clear()
end

-------------------------
-- Delete vol pan and delay --
-------------------------
function delete_vol_pan_delay()
  local song = renoise.song()
  delete_single_selected(VOL)
  delete_single_selected(PAN)
  delete_single_selected(DELAY)
end

-----------------------------
-- Delete single parameter --
-----------------------------
function delete_single_selected(parameter)
  local song = renoise.song()
  local selection = song.selected_note_column
  if selection == nil then
    return
  end

  if parameter == NOTE then
    selection.note_value = 121
    selection.note_string = '---'
  elseif parameter == VOL then
    selection.volume_value = 0
    selection.volume_string = '..'
  elseif parameter == PAN then
    selection.panning_value = 0
    selection.panning_string = '..'
  elseif parameter == DELAY then
    selection.delay_value = 0
    selection.delay_string = '..'
  elseif parameter == FX then
    selection.effect_value = 0
    selection.effect_string = '..'
  end

end
-------------------------
-- Delete delete note column or effect column (based on what is selected)
-------------------------
function delete_selected_column()
  local song = renoise.song()
  local selection = song.selected_note_column or song.selected_effect_column

  if (selection == nil) then
    return
  end

  selection:clear()
end 

---------------------------
-- Delete FX column data --
---------------------------
function delete_fx_column_data()
  local song = renoise.song()
  local selection
  for i = 1, 8 do
    selection = song.selected_line.effect_columns[i]
    selection:clear()
  end
end

---------------------------
-- Delete entire track  --
---------------------------
function delete_entire_track() 
  local song = renoise.song()
  local line_index = 1
  local current_line = song.selected_pattern_track.lines[line_index]

  while (current_line ~= nil) do
    current_line:clear()
    line_index = line_index + 1
    current_line = song.selected_pattern_track.lines[line_index]
  end
end

---------------------------
-- Delete entire column  --
---------------------------
function delete_entire_column()
  local song = renoise.song()
  local note_column_index = song.selected_note_column_index
  local effect_column_index = song.selected_effect_column_index

  if (note_column_index ~= 0) then
    for i = 1, song.selected_pattern.number_of_lines do
      song.selected_pattern_track:line(i).note_columns[note_column_index]:clear()
    end
    return

  elseif (effect_column_index ~= 0) then
    for i = 1, song.selected_pattern.number_of_lines do
      song.selected_pattern_track:line(i).effect_columns[effect_column_index]:clear()
    end
    return
  end
end

--------------------------
-- Set edit mode type   --
--------------------------
function set_edit_mode(mode) 
  EDIT_MODE = mode
  if mode == LINE then
    show_status_message("Edit mode set to Line")
  elseif mode == NOTE_OR_FX then
    show_status_message("Edit mode set to Note or FX")
  elseif mode == VOL_PAN_DELAY then
    show_status_message("Edit mode set to Volume, Pan, Delay")
  elseif mode == ALL_BUT_NOTE then
    show_status_message("Edit mode set to All but Note")
  elseif mode == NOTE_ONLY then
    show_status_message("Edit mode set to Note Only")
  end
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
-- ALL_BUT_NOTE: Duplicate everything except for the note
-- NOTE_ONLY: Duplicate only the note

  if (EDIT_MODE == LINE) then
    duplicate_line(number_of_lines)
  -- elseif (EDIT_MODE == NOTE_OR_FX) then
  --   duplicate_selected_column(number_of_lines)
  -- elseif (EDIT_MODE == VOL_PAN_DELAY) then
  --   duplicate_vol_pan_delay(number_of_lines)
  -- elseif (EDIT_MODE == ALL_BUT_NOTE) then
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