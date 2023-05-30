
-- In this file, you'll find all functions that relate to deleting note and effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua

--------------------------------------------------------------------------------
-- DELETE FUNCTIONS
--------------------------------------------------------------------------------

--[[ MULTI PURPOSE DELETE ------------------------------------------------------
Deletes different things, depending on what edit mode is selected. The intention
is to map this function to the general delete key and then switch modes depending
on what you need.
@params: mode - the edit mode that is currently selected
--------------------------------------------------------------------------------]]
function multi_purpose_delete(mode)
  if (mode == LINE) then
    delete_line()
  elseif (mode == COLUMN) then
    delete_selected_column()
  elseif (mode == NOTE_PROPERTIES) then
    delete_note_properties()
  elseif (mode == ALL_BUT_NOTE) then
    delete_note_properties()
    delete_fx_column_data()
    delete_note_fx()
  elseif (mode == NOTE_ONLY) then
    delete_note_only()
  elseif (mode == EFFECTS_ONLY) then
    delete_fx_column_data()
  end
end


--[[ MULTI PURPOSE COLUMN DELETE ------------------------------------------------------
  This is a quick way to clear the entire vertical column of the pattern editor. Each
  edit mode will clear different things.
  @params: mode - the edit mode that is currently selected
--------------------------------------------------------------------------------]]
function multi_purpose_column_delete(mode)
  if (mode == LINE) then
    delete_column_lines()
  elseif (mode == COLUMN) then
    delete_column_columns()
  elseif (mode == NOTE_PROPERTIES) then
    delete_column_note_properties()
  elseif (mode == ALL_BUT_NOTE) then
    delete_column_effects()
    delete_column_note_properties()
  elseif (mode == NOTE_ONLY) then
    delete_column_note_only()
  elseif (mode == EFFECTS_ONLY) then
    delete_column_effects()
  end
end


--[[ DELETE LINE ------------------------------------------------------
  Deletes the currently selected line in the pattern editor.
--------------------------------------------------------------------------------]]
function delete_line()
  local song = renoise.song()
  song.selected_line:clear()
end


--[[ DELETE VOL PAN DELAY AND NOTE FX -------------------------------------------
  Deletes the current line volume, panning, delay and note fx values in the pattern editor.
--------------------------------------------------------------------------------]]
function delete_note_properties()
  local song = renoise.song()
  for i = 1, 12 do
    local note_column = song.selected_line.note_columns[i]
    delete_single_selected(VOL, note_column)
    delete_single_selected(PAN, note_column)
    delete_single_selected(DELAY, note_column)
    delete_single_selected(NOTE_FX, note_column)
  end
end


--[[ DELETE NOTE EFFECTS ------------------------------------------------------
  Deletes the currently line note effects in the pattern editor.
  --------------------------------------------------------------------------------]]
function delete_note_fx()
  local song = renoise.song()
  for i = 1, 12 do
    local note_column = song.selected_line.note_columns[i]
    delete_single_selected(NOTE_FX, note_column)
  end
end


--[[ DELETE NOTE ONLY ------------------------------------------------------
  Deletes the current line notes in the pattern editor.
  --------------------------------------------------------------------------------]]
function delete_note_only()
  local song = renoise.song()
  for i = 1, 12 do
    local note_column = song.selected_line.note_columns[i]
    delete_single_selected(NOTE, note_column)
  end
end


--[[ DELETE SINGLE SELECTED PARAMETER ------------------------------------------------------
  Deletes the given note parameter (note, volume, panning, delay, or effect) from the given
  note column. If no note column is given, it will delete from the currently selected note
  @params: parameter - the parameter to delete
  @params: note_column - the note column to delete from
  --------------------------------------------------------------------------------]]
function delete_single_selected(parameter, note_column)
  local song = renoise.song()
  note_column = note_column or song.selected_note_column
  local selection = note_column
  if selection == nil then
    return
  end

  if parameter == NOTE then
    selection.note_string = '---'
    selection.instrument_string = '..'
  elseif parameter == VOL then
    selection.volume_string = '..'
  elseif parameter == PAN then
    selection.panning_string = '..'
  elseif parameter == DELAY then
    selection.delay_string = '..'
  elseif parameter == NOTE_FX then
    selection.effect_number_string = '..'
    selection.effect_amount_string = '..'
  end

end


--[[ DELETE SELECTED COLUMN ------------------------------------------------------
  Deletes the currently selected note or effect column in the pattern editor.
  --------------------------------------------------------------------------------]]
function delete_selected_column()
  local song = renoise.song()
  local selection = song.selected_note_column or song.selected_effect_column

  if (selection == nil) then
    return
  end

  selection:clear()
end 


--[[ DELETE FX COLUMN DATA ------------------------------------------------------
  Deletes effects from every effect column in the currently selected line
  --------------------------------------------------------------------------------]]
function delete_fx_column_data()
  local song = renoise.song()
  local selection
  for i = 1, 8 do
    selection = song.selected_line.effect_columns[i]
    selection:clear()
  end
end


--[[ DELETE ENTIRE TRACK ------------------------------------------------------
  Deletes all notes and effects from the currently selected pattern track.
  --------------------------------------------------------------------------------]]
function delete_column_lines() 
  local song = renoise.song()
  local line_index = 1
  local current_line = song.selected_pattern_track.lines[line_index]

  while (current_line ~= nil) do
    current_line:clear()
    line_index = line_index + 1
    current_line = song.selected_pattern_track.lines[line_index]
  end
end


--[[ DELETE COLUMNS (VERTICALLY)
  If you're in note column mode, this will delete all note columns from the current 
  line down. If you're in effect column mode, this will delete all effect
  columns from the current line down
--------------------------------------------------------------------------------]]
function delete_column_columns()
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


--[[ DELETE VOL PAN DELAY and FX (VERTICALLY)
  If you're in note column mode, this will delete all volume, panning, delay
  and note effects values from the current line down.
--------------------------------------------------------------------------------]]
function delete_column_note_properties()
  local song = renoise.song()
  local note_column_index = song.selected_note_column_index
  if note_column_index == 0 then
    -- if no note column is selected, use the first one
    note_column_index = 1
  end
  for i = 1, song.selected_pattern.number_of_lines do
    local current_column = song.selected_pattern_track:line(i).note_columns[note_column_index]
    delete_single_selected(VOL, current_column)
    delete_single_selected(PAN, current_column)
    delete_single_selected(DELAY, current_column)
    delete_single_selected(NOTE_FX, current_column)
  end
end


--[[ DELETE NOTE ONLY (VERTICALLY)
  If you're in note column mode, this will delete all note values from the current
  line down.
--------------------------------------------------------------------------------]]
function delete_column_note_only()
  local song = renoise.song()
  local note_column_index = song.selected_note_column_index
  if note_column_index == 0 then
    -- if no note column is selected, use the first one
    note_column_index = 1
  end
  
  for i = 1, song.selected_pattern.number_of_lines do
    local current_column = song.selected_pattern_track:line(i).note_columns[note_column_index]
    delete_single_selected(NOTE, current_column)
  end
end


--[[ DELETE EFFECTS ONLY (VERTICALLY)
  If you're in effect column mode, this will delete all effect values from the current
  line down.
--------------------------------------------------------------------------------]]
function delete_column_effects()
  local song = renoise.song()

  for i = 1, song.selected_pattern.number_of_lines do
    for effect_column_index = 1, 8 do
      song.selected_pattern_track:line(i).effect_columns[effect_column_index]:clear()
    end
  end
end


--[[ SET EDIT MODE --------------------------------------------------------------
  Sets the edit mode to the given mode.
--------------------------------------------------------------------------------]]
function set_edit_mode(mode) 
  EDIT_MODE = mode
  if mode == LINE then
    show_status_message("Edit mode set to LINE")
  elseif mode == COLUMN then
    show_status_message("Edit mode set to COLUMN")
  elseif mode == NOTE_PROPERTIES then
    show_status_message("Edit mode set to NOTE PROPERTIES")
  elseif mode == ALL_BUT_NOTE then
    show_status_message("Edit mode set to ALL BUT NOTE")
  elseif mode == NOTE_ONLY then
    show_status_message("Edit mode set to NOTE ONLY")
  elseif mode == EFFECTS_ONLY then
    show_status_message("Edit mode set to EFFECTS ONLY")
  else
    error("Invalid edit mode")
  end
end