

-- This is the keybindings file for pattern editor -> Insert/Delete.
-- Individual functions are defined in separate files, based on categories
-- All constants defined in constants.lua

require "Pattern_Editor.copy_functions" -- All copy and nudge functions are defined here
require "Pattern_Editor.delete_functions" -- All delete functions are defined here
require "Pattern_Editor.fx_functions" -- All fx functions are defined here
require "Pattern_Editor.constants"


--------------------------------------------------------------------------------
-- KEY BINDINGS
--------------------------------------------------------------------------------
renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Nudge note up",
  invoke = function() nudge_line(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Nudge note down",
  invoke = function() nudge_line(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Nudge column up",
  invoke = function() nudge_column(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Nudge column down",
  invoke = function() nudge_column(DOWN) end
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
  name = "Pattern Editor:Insert/Delete:Copy note and move down",
  invoke = function() copy_note_only(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy note and move up",
  invoke = function() copy_note_only(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Multipurpose copy and move down",
  invoke = function() multi_purpose_copy(EDIT_MODE, DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Multipurpose copy and move up",
  invoke = function() multi_purpose_copy(EDIT_MODE, UP) end
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
  name = "Pattern Editor:Insert/Delete:Multipurpose delete (uses edit modes)",
  invoke = function() multi_purpose_delete(EDIT_MODE) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Multipurpose column delete",
  invoke = function() multi_purpose_column_delete(EDIT_MODE) end
}
renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to Line",
  invoke = function() set_edit_mode(LINE) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to Full note or FX",
  invoke = function() set_edit_mode(COLUMN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to volume, pan, delay only",
  invoke = function() set_edit_mode(VOL_PAN_DELAY) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to delete all but note data",
  invoke = function() set_edit_mode(EFFECTS) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to delete note only",
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

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Sample Command Set Arp",
  invoke = function() set_arp() end
}

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