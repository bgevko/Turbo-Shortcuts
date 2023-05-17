

-- This is the keybindings file for pattern editor -> Navigation.
-- Individual functions are defined in separate files, based on categories
-- All constants defined in constants.lua

require "Pattern_Editor.navigation_functions" -- All navigation functions are defined here
require "Pattern_Editor.constants"

--------------------------------------------------------------------------------
-- KEY BINDINGS
--------------------------------------------------------------------------------

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Custom Jump Up",
  invoke = function() jump(UP) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Custom Jump Down",
  invoke = function() jump(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Set Jump Step to 1",
  invoke = function() set_jump_step(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Set Jump Step to 2",
  invoke = function() set_jump_step(2) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Set Jump Step to 3",
  invoke = function() set_jump_step(3) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Set Jump Step to 4",
  invoke = function() set_jump_step(4) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Set Jump Step to 5",
  invoke = function() set_jump_step(5) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Set Jump Step to 6",
  invoke = function() set_jump_step(6) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Set Jump Step to 7",
  invoke = function() set_jump_step(7) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Set Jump Step to 8",
  invoke = function() set_jump_step(8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Set Jump Step to 9",
  invoke = function() set_jump_step(9) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Double Jump Step",
  invoke = function() double_jump_step() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Half Jump Step",
  invoke = function() half_jump_step() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump Down 4 Lines",
  invoke = function() jump(DOWN, 4) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump Up 4 Lines",
  invoke = function() jump(UP, -4) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump Down 8 Lines",
  invoke = function() jump(DOWN, 8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump Up 8 Lines",
  invoke = function() jump(UP, -8) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump Down 16 Lines",
  invoke = function() jump(DOWN, 16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump Up 16 Lines",
  invoke = function() jump(UP, -16) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump to last note in selected track",
  invoke = function() jump_to_last_note_in_track() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump to first note in selected track",
  invoke = function() jump_to_first_note_in_track() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Move loop to current position",
  invoke = function() move_loop_to_current_pos() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump to next note in loop block",
  invoke = function() move_to_note_in_block_range(DOWN) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Navigation:Jump to previous note in loop block",
  invoke = function() move_to_note_in_block_range(UP) end
}

