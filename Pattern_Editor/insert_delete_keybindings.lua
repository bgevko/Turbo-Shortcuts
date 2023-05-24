

-- This is the keybindings file for pattern editor -> Insert/Delete.
-- Individual functions are defined in separate files, based on categories
-- All constants defined in constants.lua

require "Pattern_Editor.copy_functions" -- All copy and nudge functions are defined here
require "Pattern_Editor.delete_functions" -- All delete functions are defined here
require "Pattern_Editor.fx_functions" -- All fx functions are defined here
require "Pattern_Editor.constants"


--------------------------------------------------------------------------------
-- Copy, nudge, duplicate keybindings
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

------------------------------------------------------------------------
-- Note and track effects keybindings
------------------------------------------------------------------------
renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note delay 25%",
  invoke = function() set_effect(NOTE_DELAY_25) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note delay 50%",
  invoke = function() set_effect(NOTE_DELAY_50) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note delay 75%",
  invoke = function() set_effect(NOTE_DELAY_75) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX ARPEGGIO",
  invoke = function() set_effect(ARPEGGIO) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX SLIDE UP",
  invoke = function() set_effect(SLIDE_UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX SLIDE DOWN",
  invoke = function() set_effect(SLIDE_DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX all notes ARPEGGIO",
  invoke = function() set_effect_all_notes(ARPEGGIO) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX all notes in loop ARPEGGIO",
  invoke = function() set_effect_all_notes_in_loop_block(ARPEGGIO) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note delay 10%",
  invoke = function() increment_note_property(DELAY, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note delay 10%",
  invoke = function() increment_note_property(DELAY, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note delay 25%",
  invoke = function() increment_note_property(DELAY, 64) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note delay 25%",
  invoke = function() increment_note_property(DELAY, -64) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment delay all eighth notes 10%",
  invoke = function() inc_note_property_multiple(DELAY, EIGHTH, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement delay all eighth notes 10%",
  invoke = function() inc_note_property_multiple(DELAY, EIGHTH, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment delay all sixteenth notes 10%",
  invoke = function() inc_note_property_multiple(DELAY, SIXTEENTH, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement delay all sixteenth notes 10%",
  invoke = function() inc_note_property_multiple(DELAY, SIXTEENTH, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX xx--",
  invoke = function() dual_increment_fx(X, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX xx--",
  invoke = function() dual_increment_fx(X, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX --yy",
  invoke = function() dual_increment_fx(Y, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX --yy",
  invoke = function() dual_increment_fx(Y, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX xxxx",
  invoke = function() single_increment_fx(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX xxxx",
  invoke = function() single_increment_fx(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX all notes xx--",
  invoke = function() dual_increment_fx_all_notes(X, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX all notes xx--",
  invoke = function() dual_increment_fx_all_notes(X, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX all notes --yy",
  invoke = function() dual_increment_fx_all_notes(Y, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX all notes --yy",
  invoke = function() dual_increment_fx_all_notes(Y, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX all notes xxxx",
  invoke = function() single_increment_fx_all_notes(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX all notes xxxx",
  invoke = function() single_increment_fx_all_notes(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX loop block xx--",
  invoke = function() dual_increment_fx_in_loop(X, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX loop block xx--",
  invoke = function() dual_increment_fx_in_loop(X, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX loop block --yy",
  invoke = function() dual_increment_fx_in_loop(Y, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX loop block --yy",
  invoke = function() dual_increment_fx_in_loop(Y, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX loop block xxxx",
  invoke = function() single_increment_fx_in_loop(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX loop block xxxx",
  invoke = function() single_increment_fx_in_loop(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 1 for edits",
  invoke = function() set_fx_column(FX1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 2 for edits",
  invoke = function() set_fx_column(FX2) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 3 for edits",
  invoke = function() set_fx_column(FX3) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 4 for edits",
  invoke = function() set_fx_column(FX4) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 5 for edits",
  invoke = function() set_fx_column(FX5) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 6 for edits",
  invoke = function() set_fx_column(FX6) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 7 for edits",
  invoke = function() set_fx_column(FX7) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 8 for edits",
  invoke = function() set_fx_column(FX8) end
}