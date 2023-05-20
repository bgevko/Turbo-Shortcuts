

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
  name = "Pattern Editor:Insert/Delete:Effect Set Arp",
  invoke = function() set_arp() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Effect Set Slide Up",
  invoke = function() set_slide(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Effect Set Slide Down",
  invoke = function() set_slide(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment fx first half",
  invoke = function() dual_increment_fx(X, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement fx first half",
  invoke = function() dual_increment_fx(X, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment fx second half",
  invoke = function() dual_increment_fx(Y, 1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement fx second half",
  invoke = function() dual_increment_fx(Y, -1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Increment fx",
  invoke = function() single_increment_fx(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Decrement fx",
  invoke = function() single_increment_fx(-1) end
}