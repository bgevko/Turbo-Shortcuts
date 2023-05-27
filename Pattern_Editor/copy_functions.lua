
-- In this file, you'll find all functions that relate to copying and pasting notes and effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua
-- jump() function defined in navigation.lua

require "Pattern_Editor.constants"
--------------------------------------------------------------------------------
-- COPYING FUNCTIONS
--------------------------------------------------------------------------------

--[[ NUDGE LINE UP OR DOWN ------------------------------------------------------------
  Nudges the line up or down, copying the contents of the current line to the next line
  and clearing the current line.
  @param direction: UP or DOWN 
-------------------------------------------------------------------------------------]]
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


--[[ NUDGE COLUMN UP OR DOWN ----------------------------------------------------------
  Nudges the column up or down, copying the contents of either the notes or effects
  column to the next line, and clearing the current column.
  @param direction: UP or DOWN 
  -------------------------------------------------------------------------------------]]
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


--[[ MULTI PURPOSE COPY ---------------------------------------------------------------
  Copies the contents of the current line or column to the next line or column. The 
  behavior is different depending on the selected mode.
  @param mode: LINE, COLUMN, VOL_PAN_DELAY, EFFECTS, NOTE_ONLY
  @param direction: UP or DOWN
-------------------------------------------------------------------------------------]]
function multi_purpose_copy(mode, direction)
  if mode == LINE then
    copy_line(direction)
  elseif mode == COLUMN then
    copy_column(direction)
  elseif mode == NOTE_PROPERTIES then
    copy_note_properties(direction)
  elseif mode == ALL_BUT_NOTE then
    copy_effects(direction)
  elseif mode == NOTE_ONLY then
    copy_note_only(direction)
  end
end


--[[ COPY LINE AND MOVE UP OR DOWN ----------------------------------------------------
  Copies the contents of the current in the given direction, and moves the selection
  to the place where the line was copied to.
  @param direction: UP or DOWN
  -------------------------------------------------------------------------------------]]
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


--[[ COPY COLUMN AND MOVE UP OR DOWN ----------------------------------------------------
  Copies the contents of the current column in the given direction, and moves the selection
  to the place where the column was copied to.
  @param direction: UP or DOWN
  -------------------------------------------------------------------------------------]]
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


--[[ COPY VOL PAN AND DELAY AND MOVE UP OR DOWN ----------------------------------------
  Copies the volume, panning, and delay data of the current note column in the given
  direction, and moves the selection to the place where the data was copied to. Selection
  must be over a note column
  @param direction: UP or DOWN
  -------------------------------------------------------------------------------------]]
function copy_note_properties(direction)
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


--[[ COPY EFFECTS AND MOVE UP OR DOWN --------------------------------------------------
  Copies the contents of the current effect column in the given direction, and moves the
  selection to the place where the column was copied to. Selection must be on an effect
  column.
  @param direction: UP or DOWN
  -------------------------------------------------------------------------------------]]
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


--[[ COPY NOTE ONLY AND MOVE UP OR DOWN ------------------------------------------------
  Copies the note data of the current note column in the given direction, and moves the
  selection to the place where the data was copied to. Selection must be over a note column
  @param direction: UP or DOWN
  -------------------------------------------------------------------------------------]]
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


--[[ MULTI PURPOSE DUPLICATE -----------------------------------------------------------
  Multipurpose duplicate function that will duplicate based on edit mode
  LINE: Duplicate entire line
  NOTE_OR_FX: Duplicate either the note column or the effects column
  VOL_PAN_DELAY: Duplicate only vol, pan, and delay
  EFFECTS: Duplicate everything except for the note
  NOTE_ONLY: Duplicate only the note
  @param number_of_lines: Number of lines to duplicate
  -------------------------------------------------------------------------------------]]
function multi_purpose_duplicate(number_of_lines)
  
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
  

--[[ DUPLICATE LINE --------------------------------------------------------------------
  Duplicate range starting from current line, up to the given number of lines. For example,
  if the current line is 1, and the number of lines is 4, then lines 1-4 will be duplicated
  on lines 5-8. 
  @param number_of_lines: Number of lines to duplicate
  -------------------------------------------------------------------------------------]]
  function duplicate_line(number_of_lines)
    local copy_range = get_pattern_block_range(number_of_lines)
    local next_section_start = find_block_start(number_of_lines) + number_of_lines
    local paste_range = get_pattern_block_range(number_of_lines, next_section_start)
  
    for i, line in pairs(paste_range) do
      line:copy_from(copy_range[i])
    end
  
    jump_to_line(next_section_start)
  end
  

  --[[ REPEAT PATTERN OF A GIVEN SIZE ----------------------------------------------------
    Repeats the current pattern pattern of given size until the pattern track is full, 
    starting from the selection. For example, if pattern_size is 4, and the current
    selection is on line 1, then all content on lines 1-4 will be repeated until the end
    of the pattern track.
    @param pattern_size: Size of the pattern to repeat
  -------------------------------------------------------------------------------------]]
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
  

  --[[ FIND BLOCK START -----------------------------------------------------------------
    Finds the start of a block of a given size, starting from the current line. For example,
    if the current line is 19, and the block size is 4, then this function will return 17, which
    is the beginning of the 4 line block. Used mostly as a helper function for other functions.
    @param block_size: Size of the block to find
    @param starting_pos: Optional, defaults to current line
  -------------------------------------------------------------------------------------]]
  function find_block_start(block_size, starting_pos)
    local song = renoise.song()
    local current_index = starting_pos or song.selected_line_index 
    while (current_index - 1) % block_size ~= 0 do
      current_index = current_index - 1
    end
    return current_index
  end
  

  --[[ GET PATTERN BLOCK RANGE -----------------------------------------------------------
    Returns a table with the start and end of the given block, in block_size increments.
    i.e. if starting_pos is 2, and block_size is 4, the range will be 1-4. If starting_pos
    is 5, the range will be 5-8, etc. Used mostly as a helper function for other functions.
    @param block_size: Size of the block to find
    @param starting_pos: Optional, defaults to current line
  -------------------------------------------------------------------------------------]]
  function get_pattern_block_range(block_size, starting_pos)
    local song = renoise.song()
    local range_start = find_block_start(block_size, starting_pos)
    local range_end = range_start + block_size
    local range = song.selected_pattern_track:lines_in_range(range_start, range_end - 1)
    return range
  end