

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
  name = "Pattern Editor:Insert/Delete:Copy note properties and move down",
  invoke = function() copy_note_properties(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy note properties and move up",
  invoke = function() copy_note_properties(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy effect column and move down",
  invoke = function() copy_all_but_note(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy effect column and move up",
  invoke = function() copy_all_but_note(UP) end
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
  name = "Pattern Editor:Insert/Delete:Copy effect only and move down",
  invoke = function() copy_effects_only(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Copy effect only and move up",
  invoke = function() copy_effects_only(UP) end
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
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to LINE",
  invoke = function() set_edit_mode(LINE) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to SELECTED COLUMN",
  invoke = function() set_edit_mode(COLUMN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to NOTE PROPERTIES",
  invoke = function() set_edit_mode(NOTE_PROPERTIES) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to ALL BUT NOTE",
  invoke = function() set_edit_mode(ALL_BUT_NOTE) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to NOTE ONLY",
  invoke = function() set_edit_mode(NOTE_ONLY) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set Edit Mode to EFFECTS ONLY",
  invoke = function() set_edit_mode(EFFECTS_ONLY) end
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
  invoke = function() delete_column_lines() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Delete entire column",
  invoke = function() delete_column_columns() end
}

------------------------------------------------------------------------
-- Note and track effects keybindings
------------------------------------------------------------------------
renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note delay 25%",
  invoke = function() set_track_effect(NOTE_DELAY_25) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note delay 50%",
  invoke = function() set_track_effect(NOTE_DELAY_50) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note delay 75%",
  invoke = function() set_track_effect(NOTE_DELAY_75) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX ARPEGGIO",
  invoke = function() set_track_effect(ARPEGGIO) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX SLIDE UP",
  invoke = function() set_track_effect(SLIDE_UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX SLIDE DOWN",
  invoke = function() set_track_effect(SLIDE_DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX all notes ARPEGGIO",
  invoke = function() set_track_effect_all_notes(ARPEGGIO) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set FX all notes in loop ARPEGGIO",
  invoke = function() set_track_effect_all_notes_in_loop_block(ARPEGGIO) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note delay (1)",
  invoke = function() increment_note_property(DELAY, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note delay (-1)",
  invoke = function() increment_note_property(DELAY, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note delay (16)",
  invoke = function() increment_note_property(DELAY, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note delay (-16)",
  invoke = function() increment_note_property(DELAY, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note delay (64)",
  invoke = function() increment_note_property(DELAY, 64) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note delay (-64)",
  invoke = function() increment_note_property(DELAY, -64) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment delay all 8th notes (1)",
  invoke = function() increment_groove(EIGHTH, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement delay all 8th notes (-1)",
  invoke = function() increment_groove(EIGHTH, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment delay all 8th notes (16)",
  invoke = function() increment_groove(EIGHTH, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement delay all 8th notes (-16)",
  invoke = function() increment_groove(EIGHTH, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment delay all 16th notes (1)",
  invoke = function() increment_groove(SIXTEENTH, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement delay all 16th notes (-1)",
  invoke = function() increment_groove(SIXTEENTH, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment delay all 16th notes (16)",
  invoke = function() increment_groove(SIXTEENTH, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement delay all 16th notes (-16)",
  invoke = function() increment_groove(SIXTEENTH, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment pan all notes (1)",
  invoke = function() increment_note_property_all_notes(PAN, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement pan all notes (-1)",
  invoke = function() increment_note_property_all_notes(PAN, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment pan all notes (8)",
  invoke = function() increment_note_property_all_notes(PAN, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement pan all notes (-8)",
  invoke = function() increment_note_property_all_notes(PAN, -8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume +8/-8",
  invoke = function() randomize_note_property(VOL, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume +16/-16",
  invoke = function() randomize_note_property(VOL, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume +32/-32",
  invoke = function() randomize_note_property(VOL, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan +8/-8",
  invoke = function() randomize_note_property(PAN, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan +16/-16",
  invoke = function() randomize_note_property(PAN, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan +32/-32",
  invoke = function() randomize_note_property(PAN, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize delay +8/-8",
  invoke = function() randomize_note_property(DELAY, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize delay +16/-16",
  invoke = function() randomize_note_property(DELAY, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize delay +32/-32",
  invoke = function() randomize_note_property(DELAY, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume all notes +8/-8",
  invoke = function() randomize_note_property_all_notes(VOL, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume all notes +16/-16",
  invoke = function() randomize_note_property_all_notes(VOL, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume all notes +32/-32",
  invoke = function() randomize_note_property_all_notes(VOL, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan all notes +8/-8",
  invoke = function() randomize_note_property_all_notes(PAN, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan all notes +16/-16",
  invoke = function() randomize_note_property_all_notes(PAN, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan all notes +32/-32",
  invoke = function() randomize_note_property_all_notes(PAN, 32) end
}

-- randomize groove all notes
renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize groove all notes +8/-8",
  invoke = function() randomize_note_property_all_notes(DELAY, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize groove all notes +16/-16",
  invoke = function() randomize_note_property_all_notes(DELAY, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize groove all notes +32/-32",
  invoke = function() randomize_note_property_all_notes(DELAY, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize groove 8th notes +8/-8",
  invoke = function() randomize_groove(EIGHTH, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize groove 8th notes +16/-16",
  invoke = function() randomize_groove(EIGHTH, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize groove 8th notes +32/-32",
  invoke = function() randomize_groove(EIGHTH, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize groove 16th notes +8/-8",
  invoke = function() randomize_groove(SIXTEENTH, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize groove 16th notes +16/-16",
  invoke = function() randomize_groove(SIXTEENTH, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize groove 16th notes +32/-32",
  invoke = function() randomize_groove(SIXTEENTH, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX left digit",
  invoke = function() inc_4bit_hex_fx(X, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX left digit",
  invoke = function() inc_4bit_hex_fx(X, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX right digit",
  invoke = function() inc_4bit_hex_fx(Y, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX right digit",
  invoke = function() inc_4bit_hex_fx(Y, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX",
  invoke = function() inc_8bit_hex_fx(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX",
  invoke = function() inc_8bit_hex_fx(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX all notes left digit",
  invoke = function() inc_4bit_fx_all_notes(X, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX all notes left digit",
  invoke = function() inc_4bit_fx_all_notes(X, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX all notes right digit",
  invoke = function() inc_4bit_fx_all_notes(Y, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX all notes right digit",
  invoke = function() inc_4bit_fx_all_notes(Y, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX all notes",
  invoke = function() inc_8bit_fx_all_notes(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX all notes",
  invoke = function() inc_8bit_fx_all_notes(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX loop block left digit",
  invoke = function() inc_4bit_fx_loop(X, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX loop block left digit",
  invoke = function() inc_4bit_fx_loop(X, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX loop block right digit",
  invoke = function() inc_4bit_fx_loop(Y, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX loop block right digit",
  invoke = function() inc_4bit_fx_loop(Y, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment FX loop block",
  invoke = function() inc_8bit_fx_loop(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement FX loop block",
  invoke = function() inc_8bit_fx_loop(-1) end
}

------------------------------------------------------------------
-- FX Keybindings
------------------------------------------------------------------

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note property left digit",
  invoke = function() inc_4bit_note_property(X, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note property left digit",
  invoke = function() inc_4bit_note_property(X, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note property right digit",
  invoke = function() inc_4bit_note_property(Y, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note property right digit",
  invoke = function() inc_4bit_note_property(Y, -1) end
}

------------------------------------------------------------------
-- Set Default FX column for edits
------------------------------------------------------------------
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