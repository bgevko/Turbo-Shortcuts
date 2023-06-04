

-- This is the keybindings file for pattern editor -> Insert/Delete.
-- Individual functions are defined in separate files, based on categories
-- All constants defined in constants.lua

require "Pattern_Editor.copy_functions" -- All copy and nudge functions are defined here
require "Pattern_Editor.delete_functions" -- All delete functions are defined here
require "Pattern_Editor.fx_functions" -- All fx functions are defined here
require "Pattern_Editor.constants"


--------------------------------------------------------------------------------
-- COPY, NUDGE, AND FILL PATTERN KEYBINDINGS
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
-- DELETE KEYBINDINGS
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
-- NOTE EFFECTS
------------------------------------------------------------------------
renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note delay 25%",
  invoke = function() NoteEffects:set(DELAY_25) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note delay 50%",
  invoke = function() NoteEffects:set(DELAY_50) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note delay 75%",
  invoke = function() NoteEffects:set(DELAY_75) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note ARPEGGIO",
  invoke = function() NoteEffects:set(ARPEGGIO) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note SLIDE UP",
  invoke = function() NoteEffects:set(SLIDE_UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set note SLIDE DOWN",
  invoke = function() NoteEffects:set(SLIDE_DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set all notes ARPEGGIO",
  invoke = function() NoteEffects:set_all_notes(ARPEGGIO) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Set all notes in loop ARPEGGIO",
  invoke = function() NoteEffects:set_all_notes_in_loop(ARPEGGIO) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note FX left digit",
  invoke = function() NoteEffects:inc_left(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note FX left digit",
  invoke = function() NoteEffects:inc_left(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note FX right digit",
  invoke = function() NoteEffects:inc_right(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note FX right digit",
  invoke = function() NoteEffects:inc_right(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note FX",
  invoke = function() NoteEffects:inc(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note FX",
  invoke = function() NoteEffects:inc(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment all notes FX left digit",
  invoke = function() NoteEffects:inc_left_all(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement all notes FX left digit",
  invoke = function() NoteEffects:inc_left_all(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment all notes FX right digit",
  invoke = function() NoteEffects:inc_right_all(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement all notes FX right digit",
  invoke = function() NoteEffects:inc_right_all(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment all notes FX",
  invoke = function() NoteEffects:inc_all(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement all notes FX",
  invoke = function() NoteEffects:inc_all(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment all notes FX (loop) left digit",
  invoke = function() NoteEffects:inc_left_loop(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement all notes FX (loop) left digit",
  invoke = function() NoteEffects:inc_left_loop(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment all notes FX (loop) right digit",
  invoke = function() NoteEffects:inc_right_loop(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement all notes FX (loop) right digit",
  invoke = function() NoteEffects:inc_right_loop(-1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment all notes FX (loop)",
  invoke = function() NoteEffects:inc_all_loop(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement all notes FX (loop)",
  invoke = function() NoteEffects:inc_all_loop(-1) end
}

------------------------------------------------------------------
-- VOL, PAN, DELAY (note properties)
------------------------------------------------------------------
renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note delay (1)",
  invoke = function() NoteEffects:inc_prop(DELAY, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note delay (-1)",
  invoke = function() NoteEffects:inc_prop(DELAY, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note delay (16)",
  invoke = function() NoteEffects:inc_prop(DELAY, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note delay (-16)",
  invoke = function() NoteEffects:inc_prop(DELAY, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment note delay (64)",
  invoke = function() NoteEffects:inc_prop(DELAY, 64) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement note delay (-64)",
  invoke = function() NoteEffects:inc_prop(DELAY, -64) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment pan all notes (1)",
  invoke = function() NoteEffects:inc_prop_all(PAN, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement pan all notes (-1)",
  invoke = function() NoteEffects:inc_prop_all(PAN, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment pan all notes (8)",
  invoke = function() NoteEffects:inc_prop_all(PAN, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement pan all notes (-8)",
  invoke = function() NoteEffects:inc_prop_all(PAN, -8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume +8/-8",
  invoke = function() NoteEffects:randomize_prop(VOL, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume +16/-16",
  invoke = function() NoteEffects:randomize_prop(VOL, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume +32/-32",
  invoke = function() NoteEffects:randomize_prop(VOL, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan +8/-8",
  invoke = function() NoteEffects:randomize_prop(PAN, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan +16/-16",
  invoke = function() NoteEffects:randomize_prop(PAN, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan +32/-32",
  invoke = function() NoteEffects:randomize_prop(PAN, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize delay +8/-8",
  invoke = function() NoteEffects:randomize_prop(DELAY, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize delay +16/-16",
  invoke = function() NoteEffects:randomize_prop(DELAY, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize delay +32/-32",
  invoke = function() NoteEffects:randomize_prop(DELAY, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume all notes +8/-8",
  invoke = function() NoteEffects:randomize_prop_all(VOL, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume all notes +16/-16",
  invoke = function() NoteEffects:randomize_prop_all(VOL, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize volume all notes +32/-32",
  invoke = function() NoteEffects:randomize_prop_all(VOL, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan all notes +8/-8",
  invoke = function() NoteEffects:randomize_prop_all(PAN, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan all notes +16/-16",
  invoke = function() NoteEffects:randomize_prop_all(PAN, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Randomize pan all notes +32/-32",
  invoke = function() NoteEffects:randomize_prop_all(PAN, 32) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment VOL left digit",
  invoke = function() NoteEffects:inc_prop_left(VOL, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement VOL left digit",
  invoke = function() NoteEffects:inc_prop_left(VOL, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment VOL right digit",
  invoke = function() NoteEffects:inc_prop_right(VOL, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement VOL right digit",
  invoke = function() NoteEffects:inc_prop_right(VOL, -1) end
}

------------------------------------------------------------------
-- GROOVE EFFECTS
------------------------------------------------------------------
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

------------------------------------------------------------------
-- SET DEFAULT FX COLUMN FOR FOR MULTIPURPOSE FX COMMANDS
------------------------------------------------------------------
renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 1 for edits",
  invoke = function() set_default_fx_column(FX1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 2 for edits",
  invoke = function() set_default_fx_column(FX2) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 3 for edits",
  invoke = function() set_default_fx_column(FX3) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 4 for edits",
  invoke = function() set_default_fx_column(FX4) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 5 for edits",
  invoke = function() set_default_fx_column(FX5) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 6 for edits",
  invoke = function() set_default_fx_column(FX6) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 7 for edits",
  invoke = function() set_default_fx_column(FX7) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete: Set FX column 8 for edits",
  invoke = function() set_default_fx_column(FX8) end
}