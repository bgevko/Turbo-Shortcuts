
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

  local line_index = selected_line_index + step
  if line_index < 1 or line_index > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[line_index]
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
  @param mode: LINE, COLUMN, VOL_PAN_DELAY, EFFECTS, NOTE_ONLY, EFFECTS_ONLY
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
    copy_all_but_note(direction)
  elseif mode == NOTE_ONLY then
    copy_note_only(direction)
  elseif mode == EFFECTS_ONLY then
    copy_effects_only(direction)
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
  direction, and moves the selection to the place where the data was copied to.
  @param direction: UP or DOWN
  -------------------------------------------------------------------------------------]]
function copy_note_properties(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local step

  if direction == DOWN then
    step = 1
  else
    step = -1
  end

  if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]

  for i = 1, 12 do
    local next_column = next_line.note_columns[i]
    next_column.volume_string = song.selected_pattern_track:line(selected_line_index).note_columns[i].volume_string
    next_column.panning_string = song.selected_pattern_track:line(selected_line_index).note_columns[i].panning_string
    next_column.delay_string = song.selected_pattern_track:line(selected_line_index).note_columns[i].delay_string
    next_column.effect_number_string = song.selected_pattern_track:line(selected_line_index).note_columns[i].effect_number_string
    next_column.effect_amount_string = song.selected_pattern_track:line(selected_line_index).note_columns[i].effect_amount_string
  end

  jump(direction)
end


--[[ COPY EVERYTHING BUT NOTE AND MOVE UP OR DOWN --------------------------------------------------
  Copies the contents of the current effect column in the given direction, and moves the
  selection to the place where the column was copied to.
  @param direction: UP or DOWN
  -------------------------------------------------------------------------------------]]
function copy_all_but_note(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selection

  local step = (direction == DOWN) and 1 or -1
    if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  local next_fx_column = next_line.effect_columns
  local next_note_column = next_line.note_columns

  for effect_column_index = 1, 8 do
    selection = song.selected_line.effect_columns[effect_column_index]
    next_fx_column = next_line.effect_columns[effect_column_index]
    next_fx_column:copy_from(selection)
  end

  for note_column_index = 1, 12 do
    selection = song.selected_line.note_columns[note_column_index]
    next_note_column = next_line.note_columns[note_column_index]
    next_note_column.volume_string = selection.volume_string
    next_note_column.panning_string = selection.panning_string
    next_note_column.delay_string = selection.delay_string
    next_note_column.effect_number_string = selection.effect_number_string
  end
  jump(direction)
end


--[[ COPY NOTE ONLY AND MOVE UP OR DOWN ------------------------------------------------
  Copies the note data of the current note column in the given direction, and moves the
  selection to the place where the data was copied to.
  @param direction: UP or DOWN
  -------------------------------------------------------------------------------------]]
function copy_note_only(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index

  local step = (direction == DOWN) and 1 or -1

  if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]

  for i = 1, 12 do
    local next_column = next_line.note_columns[i]
    next_column.note_string = song.selected_pattern_track:line(selected_line_index).note_columns[i].note_string
    next_column.instrument_string = song.selected_pattern_track:line(selected_line_index).note_columns[i].instrument_string
  end
  jump(direction)
end


--[[ COPY EFFECTS ONLY AND MOVE UP OR DOWN ------------------------------------------------
  Copies effects columns and moves up or down
  @param direction: UP or DOWN
  -------------------------------------------------------------------------------------]]
function copy_effects_only(direction)
  local song = renoise.song()
  local selected_line_index = song.selected_line_index
  local selection

  local step = (direction == DOWN) and 1 or -1
    if selected_line_index + step < 1 or selected_line_index + step > song.selected_pattern.number_of_lines then
    return
  end

  local next_line = song.selected_pattern_track.lines[selected_line_index + step]
  local next_fx_column = next_line.effect_columns

  for effect_column_index = 1, 8 do
    selection = song.selected_line.effect_columns[effect_column_index]
    next_fx_column = next_line.effect_columns[effect_column_index]
    next_fx_column:copy_from(selection)
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
  EFFECTS_ONLY: Duplicate column effects only
  @param number_of_lines: Number of lines to duplicate
  -------------------------------------------------------------------------------------]]
function multi_purpose_duplicate(number_of_lines)
  
    if (EDIT_MODE == LINE) then
      duplicate_line(number_of_lines)
    elseif (EDIT_MODE == COLUMN) then
      duplicate_selected_column(number_of_lines)
    elseif (EDIT_MODE == NOTE_PROPERTIES) then
      duplicate_note_properties(number_of_lines)
    elseif (EDIT_MODE == ALL_BUT_NOTE) then
      duplicate_all_but_note(number_of_lines)
    elseif (EDIT_MODE == NOTE_ONLY) then
      duplicate_single_selected(NOTE, number_of_lines)
    elseif (EDIT_MODE == EFFECTS_ONLY) then
      duplicate_effects_only(number_of_lines)
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
  
  
  --[[ DUPLICATE SELECTED COLUMN --------------------------------------------------------------------
  Duplicate specified number of lines down for note column or effect column.
  @param number_of_lines: Number of lines to duplicate ---------------------------------------------------------------------]]
  function duplicate_selected_column(number_of_lines)
    local song = renoise.song()
    local copy_range = get_pattern_block_range(number_of_lines)
    local next_section_start = find_block_start(number_of_lines) + number_of_lines
    local paste_range = get_pattern_block_range(number_of_lines, next_section_start)

    local note_column = song.selected_note_column_index
    local effect_column = song.selected_effect_column_index

    for i, line in pairs(paste_range) do
      if note_column == 1 then
        line.note_columns[note_column]:copy_from(copy_range[i].note_columns[note_column])
      elseif effect_column == 1 then
        line.effect_columns[effect_column]:copy_from(copy_range[i].effect_columns[effect_column])
      end
    end

    jump_to_line(next_section_start)
  end


  --[[ DUPLICATE NOTE PROPERTIES --------------------------------------------------------------------
  Duplicate note properties (vol, pan, delay, note effects) for specified number of lines down.
  @param number_of_lines: Number of lines to duplicate ---------------------------------------------------------------------]]
  function duplicate_note_properties(number_of_lines)
    local song = renoise.song()
    local copy_range = get_pattern_block_range(number_of_lines)
    local next_section_start = find_block_start(number_of_lines) + number_of_lines
    local paste_range = get_pattern_block_range(number_of_lines, next_section_start)

    local note_column = song.selected_note_column_index
    if note_column == 0 then
      note_column = 1
    end

    for i, line in pairs(paste_range) do
      line.note_columns[note_column].volume_string = copy_range[i].note_columns[note_column].volume_string
      line.note_columns[note_column].panning_string = copy_range[i].note_columns[note_column].panning_string
      line.note_columns[note_column].delay_string = copy_range[i].note_columns[note_column].delay_string
      line.note_columns[note_column].effect_number_string = copy_range[i].note_columns[note_column].effect_number_string
    end

    jump_to_line(next_section_start)
  end


  --[[ DUPLICATE ALL BUT NOTE --------------------------------------------------------------------
  Duplicate entire line except for note for specified number of lines down.
  @param number_of_lines: Number of lines to duplicate ---------------------------------------------------------------------]]
  function duplicate_all_but_note(number_of_lines)
    local copy_range = get_pattern_block_range(number_of_lines)
    local next_section_start = find_block_start(number_of_lines) + number_of_lines
    local paste_range = get_pattern_block_range(number_of_lines, next_section_start)

    for line_index, line in pairs(paste_range) do
      for note_col = 1, 12 do
        line.note_columns[note_col].volume_string = copy_range[line_index].note_columns[note_col].volume_string
        line.note_columns[note_col].panning_string = copy_range[line_index].note_columns[note_col].panning_string
        line.note_columns[note_col].delay_string = copy_range[line_index].note_columns[note_col].delay_string
        line.note_columns[note_col].effect_number_string = copy_range[line_index].note_columns[note_col].effect_number_string
      end
      for fx_col = 1, 8 do
        line.effect_columns[fx_col]:copy_from(copy_range[line_index].effect_columns[fx_col])
      end
    end

    jump_to_line(next_section_start)
  end


   --[[ DUPLICATE EFFECTS ONLY --------------------------------------------------------------------
  Duplicate all effects columns a specified number of lines.
  @param number_of_lines: Number of lines to duplicate ---------------------------------------------------------------------]]
  function duplicate_effects_only(number_of_lines)
    local copy_range = get_pattern_block_range(number_of_lines)
    local next_section_start = find_block_start(number_of_lines) + number_of_lines
    local paste_range = get_pattern_block_range(number_of_lines, next_section_start)

    for line_index, line in pairs(paste_range) do
      for fx_col = 1, 8 do
        line.effect_columns[fx_col]:copy_from(copy_range[line_index].effect_columns[fx_col])
      end
    end

    jump_to_line(next_section_start)
  end


  --[[ DUPLICATE SINGLE PROPERTY ---------------------------------------
  Duplicate just a single property specified number of lines down.
  @param number_of_lines: Number of lines to duplicate ---------------------------------------------------------------------]]
  function duplicate_single_selected(property, number_of_lines)
    local song = renoise.song()
    local copy_range = get_pattern_block_range(number_of_lines)
    local next_section_start = find_block_start(number_of_lines) + number_of_lines
    local paste_range = get_pattern_block_range(number_of_lines, next_section_start)

    local note_column = song.selected_note_column_index
    if note_column == 0 then
      note_column = 1
    end

    for i, line in pairs(paste_range) do
      if property == NOTE then
        line.note_columns[note_column].note_string = copy_range[i].note_columns[note_column].note_string
        line.note_columns[note_column].instrument_string = copy_range[i].note_columns[note_column].instrument_string
      elseif property == VOL then
        line.note_columns[note_column].volume_string = copy_range[i].note_columns[note_column].volume_string
      elseif property == PAN then
        line.note_columns[note_column].panning_string = copy_range[i].note_columns[note_column].panning_string
      elseif property == DELAY then
        line.note_columns[note_column].delay_string = copy_range[i].note_columns[note_column].delay_string
      elseif property == NOTE_FX then
        line.note_columns[note_column].effect_number_string = copy_range[i].note_columns[note_column].effect_number_string
      else
        error('Invalid property')
      end
    end
    jump_to_line(next_section_start)
  end


  --[[ REPEAT PATTERN OF A GIVEN SIZE ----------------------------------------------------
    Repeats the current pattern pattern of given size until the pattern track is full, 
    starting from the selection. For example, if pattern_size is 4, and the current
    selection is on line 1, then all content on lines 1-4 will be repeated until the end
    of the pattern track. (content is copied in accordance to the edit modes)
    @param pattern_size: Size of the pattern to repeat
  -------------------------------------------------------------------------------------]]
  function repeat_pattern_of_size(pattern_size)
    local song = renoise.song()
    local start_location = song.selected_line_index
    local current_line_index
  
    repeat
      current_line_index = song.selected_line_index
      if EDIT_MODE == LINE then
        duplicate_line(pattern_size)
      elseif EDIT_MODE == COLUMN then
        duplicate_selected_column(pattern_size)
      elseif EDIT_MODE == NOTE_PROPERTIES then
        duplicate_note_properties(pattern_size)
      elseif EDIT_MODE == ALL_BUT_NOTE then
        duplicate_all_but_note(pattern_size)
      elseif EDIT_MODE == NOTE_ONLY then
        duplicate_single_selected(NOTE, pattern_size)
      elseif EDIT_MODE == EFFECTS_ONLY then
        duplicate_effects_only(pattern_size)
      end
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
    Returns a table of line objects with the start and end of the given block, in block_size increments.
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