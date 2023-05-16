
-- In this file, you'll find all functions that relate to deleting note and effects in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua

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

  if (type == LINE) then
    delete_line()
  elseif (type == COLUMN) then
    delete_selected_column()
  elseif (type == VOL_PAN_DELAY) then
    delete_vol_pan_delay()
  elseif (type == EFFECTS) then
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
  elseif mode == COLUMN then
    show_status_message("Edit mode set to column")
  elseif mode == VOL_PAN_DELAY then
    show_status_message("Edit mode set to Volume, Pan, Delay")
  elseif mode == EFFECTS then
    show_status_message("Edit mode set to All but Note")
  elseif mode == NOTE_ONLY then
    show_status_message("Edit mode set to Note Only")
  end
end