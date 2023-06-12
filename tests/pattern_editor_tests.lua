luaunit = require("tests.luaunit")
require("Pattern_Editor.navigation_functions")
require("Pattern_Editor.delete_functions")
require("Pattern_Editor.constants")
-- -------------------------

local M = {}  -- create a new table

function M.nav_tests()
  testNavigation()
end

function M.copy_delete_tests()
  testCopyDelete()
end

function testNavigation()
  local assert = luaunit.assertEquals
  local song = renoise.song()
  local transport = song.transport
  local last_line = song.selected_pattern.number_of_lines

  local offset = 0
  local default_interval = 50

  print("------------------------- Navigation tests -------------------------")

  reset()
  
  local cases1 = {
    {function() reset() end, function() assert(transport.edit_pos.line, 1, "Reset") end},
    {function() jump_to_line(5) end, function() assert(transport.edit_pos.line, 5, "jump_to_line(5)") end},
    {function() jump_to_line(1) end, function() assert(transport.edit_pos.line, 1, "jump_to_line(1)") end},
    {function() jump_to_line(0) end, function() assert(transport.edit_pos.line, 1, "jump_to_line(0)") end},
    {function() jump_to_line(-1) end, function() assert(transport.edit_pos.line, 1, "jump_to_line(-1)") end},
    {function() jump_to_line(1000) end, function() assert(transport.edit_pos.line, last_line, "jump_to_line(1000)") end},
  }
  run_tests("Jump to line", cases1, default_interval)
  offset = calculate_offset(cases1, default_interval, offset)

  local cases2 = {
    {function() reset() end, function() assert(transport.edit_pos.line, 1, "Reset") end},
    {function() jump(UP) end, function() assert(transport.edit_pos.line, 1, "jump(UP)") end},
    {function() jump(DOWN) end, function() assert(transport.edit_pos.line, 2, "jump(DOWN)") end},
    {function() set_jump_step(1000) end, function() assert(JUMP_STEP, JUMP_MAX, "set_jump_step(1000)") end},
    {function() jump(DOWN) end, function() assert(transport.edit_pos.line, last_line, "jump(DOWN) 64 steps") end},
    {function() jump(UP) end, function() assert(transport.edit_pos.line, 1, "jump(UP) 64 steps") end},
    {function() jump(UP) end, function() assert(transport.edit_pos.line, 1, "jump(UP) 64 steps") end},
    {function() set_jump_step(5) end, function() assert(JUMP_STEP, 5, "set_jump_step(5)") end},
    {function() jump(DOWN) end, function() assert(transport.edit_pos.line, 6, "jump(DOWN) 5 steps") end},
    {function() jump(UP) end, function() assert(transport.edit_pos.line, 1, "jump(UP) 5 steps") end},
    {function() set_jump_step(1) end, function() assert(JUMP_STEP, 1, "set_jump_step(1)") end},
    {function() jump(DOWN) end, function() assert(transport.edit_pos.line, 2, "jump(DOWN) 1 step") end},
    {function() jump(UP) end, function() assert(transport.edit_pos.line, 1, "jump(UP) 1 step") end},
    {function() set_jump_step(0) end, function() assert(JUMP_STEP, 1, "set_jump_step(0)") end},
    {function() set_jump_step(-1) end, function() assert(JUMP_STEP, 1, "set_jump_step(-1)") end},
    {function() double_jump_step() end, function() assert(JUMP_STEP, 2, "double jump step from 1") end},
    {function() double_jump_step() end, function() assert(JUMP_STEP, 4, "double jump step from 2") end},
    {function() double_jump_step() end, function() assert(JUMP_STEP, 8, "double jump step from 4") end},
    {function() double_jump_step() end, function() assert(JUMP_STEP, 16, "double jump step from 8") end},
    {function() double_jump_step() end, function() assert(JUMP_STEP, 32, "double jump step from 16") end},
    {function() double_jump_step() end, function() assert(JUMP_STEP, 64, "double jump step from 32") end},
    {function() double_jump_step() end, function() assert(JUMP_STEP, 64, "double jump step from 64") end},
    {function() halve_jump_step() end, function() assert(JUMP_STEP, 32, "halve jump step from 64") end},
    {function() halve_jump_step() end, function() assert(JUMP_STEP, 16, "halve jump step from 32") end},
    {function() halve_jump_step() end, function() assert(JUMP_STEP, 8, "halve jump step from 16") end},
    {function() halve_jump_step() end, function() assert(JUMP_STEP, 4, "halve jump step from 8") end},
    {function() halve_jump_step() end, function() assert(JUMP_STEP, 2, "halve jump step from 4") end},
    {function() halve_jump_step() end, function() assert(JUMP_STEP, 1, "halve jump step from 2") end},
    {function() halve_jump_step() end, function() assert(JUMP_STEP, 1, "halve jump step from 1") end},
    {function() jump(DOWN, 4) end, function() assert(transport.edit_pos.line, 5, "jump(DOWN, 4)") end},
    {function() jump(UP, 4) end, function() assert(transport.edit_pos.line, 1, "jump(UP, 4)") end},
    {function() jump(UP, 4) end, function() assert(transport.edit_pos.line, 1, "jump(UP, 4)") end},
    {function() jump(DOWN, 8) end, function() assert(transport.edit_pos.line, 9, "jump(DOWN, 8)") end},
    {function() jump(UP, 8) end, function() assert(transport.edit_pos.line, 1, "jump(UP, 8)") end},
    {function() jump(DOWN, 16) end, function() assert(transport.edit_pos.line, 17, "jump(DOWN, 16)") end},
    {function() jump(UP, 16) end, function() assert(transport.edit_pos.line, 1, "jump(UP, 16)") end},
  }

  delay(function()
    run_tests("Set jump step and custom move", cases2, default_interval)
  end, offset)

  offset = calculate_offset(cases2, default_interval, offset)

  local cases3 = {
    {function() reset() end, function() assert(transport.edit_pos.line, 1, "Reset") end},
    {
      function() set_note(1) end,
      function()
        local note = song.selected_pattern_track:line(1).note_columns[1]
        assert(note.note_value, 30, "Note on first line")
      end
    },
    {
      function() set_note(last_line) end,
      function()
        local note = song.selected_pattern_track:line(last_line).note_columns[1]
        assert(note.note_value, 30, "Note on last line")
      end
    },
    {
      function() jump_to_last_note_in_track() end, 
      function() assert(transport.edit_pos.line, last_line, "Jump to last note in track") end
    },
    {
      function() jump_to_first_note_in_track() end, 
      function() assert(transport.edit_pos.line, 1, "Jump to last note in track") end
    },
    {
      function() set_note(5) end,
      function()
        local note = song.selected_pattern_track:line(5).note_columns[1]
        assert(note.note_value, 30, "Note on line 5")
      end
    },
    {
      function() set_note(7) end,
      function()
        local note = song.selected_pattern_track:line(7).note_columns[1]
        assert(note.note_value, 30, "Note on line 7")
      end
    },
    {
      function() enable_loop_block() end,
      function() assert(transport.loop_block_enabled, true, "Enable loop block") end
    },
    { 
      function() move_to_note_in_block_range(DOWN) end,
      function() assert(transport.edit_pos.line, 5, "Move to next note in loop block (1 to 5)") end
    },
    { 
      function() move_to_note_in_block_range(DOWN) end,
      function() assert(transport.edit_pos.line, 7, "Move to next note in loop block (5 to 7)") end
    },
    { 
      function() move_to_note_in_block_range(DOWN) end,
      function() assert(transport.edit_pos.line, 1, "Move to next note in loop block (7 to 1 wrap)") end
    },
    {
      function() move_to_note_in_block_range(UP) end,
      function() assert(transport.edit_pos.line, 7, "Move to previous note in loop block (1 to 7 wrap)") end
    },
    {
      function() move_to_note_in_block_range(UP) end,
      function() assert(transport.edit_pos.line, 5, "Move to previous note in loop block (7 to 5)") end
    },
    {
      function() move_to_note_in_block_range(UP) end,
      function() assert(transport.edit_pos.line, 1, "Move to previous note in loop block (5 to 1)") end
    },
  }

  delay(function()
    run_tests("Jump to specified notes", cases3, default_interval)
  end, offset)

  offset = calculate_offset(cases3, default_interval, offset)

  delay(function()
    reset()
    print("-------- Navigation tests complete --------")
  end, offset)
end

function testCopyDelete()
  local assertEquals = luaunit.assertEquals
  local assertNotEquals = luaunit.assertNotEquals
  local song = renoise.song()
  local transport = song.transport
  local last_line = song.selected_pattern.number_of_lines

  local offset = 0
  local default_interval = 50

  print("------------------------- Copy / Delete tests -------------------------")

  reset()
  
  local cases1 = {
    {function() reset() end, function() assertEquals(transport.edit_pos.line, 1, "Reset") end},
    {
      function() set_line(1) end, 
      function()
        local note = song.selected_pattern_track:line(1).note_columns[1]
        local fx = song.selected_pattern_track:line(1).effect_columns[1]
        assertEquals(transport.edit_pos.line, 1, "Position is 1")
        assertEquals(note.note_value, 30, "Set line sets note to correct line")
        assertEquals(note.instrument_value, 30, "Set line sets instrument")
        assertEquals(note.volume_value, 30, "Set line sets volume")
        assertEquals(note.panning_value, 30, "Set line sets panning")
        assertEquals(note.delay_value, 30, "Set line sets delay")
        assertEquals(note.effect_number_value, 30, "Set line sets effect number")
        assertEquals(note.effect_amount_value, 30, "Set line sets effect amount")
        assertEquals(fx.number_value, 30, "Set line sets fx number")
        assertEquals(fx.amount_value, 30, "Set line sets fx amount")
      end
    },
    {
      function() nudge_line(DOWN) end,
      function()
        local note = song.selected_pattern_track:line(2).note_columns[1]
        local prev_note = song.selected_pattern_track:line(1).note_columns[1]
        local fx = song.selected_pattern_track:line(2).effect_columns[1]
        local prev_fx = song.selected_pattern_track:line(1).effect_columns[1]

        assertEquals(transport.edit_pos.line, 2, "Nudge line down moves selection down")
        assertNotEquals(prev_note.note_value, 30, "Nudge line down clears previous note")
        assertNotEquals(prev_note.instrument_value, 30, "Nudge line down clears previous instrument")
        assertNotEquals(prev_note.volume_value, 30, "Nudge line down clears previous volume")
        assertNotEquals(prev_note.panning_value, 30, "Nudge line down clears previous panning")
        assertNotEquals(prev_note.delay_value, 30, "Nudge line down clears previous delay")
        assertNotEquals(prev_note.effect_number_value, 30, "Nudge line down clears previous effect number")
        assertNotEquals(prev_note.effect_amount_value, 30, "Nudge line down clears previous effect amount") 
        assertNotEquals(prev_fx.number_value, 30, "Nudge line down clears previous fx number")
        assertNotEquals(prev_fx.amount_value, 30, "Nudge line down clears previous fx amount")

        assertEquals(note.note_value, 30, "Nudge line down sets note to correct line")
        assertEquals(note.instrument_value, 30, "Nudge line down sets instrument")
        assertEquals(note.volume_value, 30, "Nudge line down sets volume")
        assertEquals(note.panning_value, 30, "Nudge line down sets panning")
        assertEquals(note.delay_value, 30, "Nudge line down sets delay")
        assertEquals(note.effect_number_value, 30, "Nudge line down sets effect number")
        assertEquals(note.effect_amount_value, 30, "Nudge line down sets effect amount")
        assertEquals(fx.number_value, 30, "Nudge line down sets fx number")
        assertEquals(fx.amount_value, 30, "Nudge line down sets fx amount")
      end
    },
    {
      function() nudge_line(UP) end,
      function()
        local note = song.selected_pattern_track:line(1).note_columns[1]
        local prev_note = song.selected_pattern_track:line(2).note_columns[1]
        local fx = song.selected_pattern_track:line(1).effect_columns[1]
        local prev_fx = song.selected_pattern_track:line(2).effect_columns[1]

        assertEquals(transport.edit_pos.line, 1, "Nudge line up moves selection up")
        assertNotEquals(prev_note.note_value, 30, "Nudge line up clears previous note")
        assertNotEquals(prev_note.instrument_value, 30, "Nudge line up clears previous instrument")
        assertNotEquals(prev_note.volume_value, 30, "Nudge line up clears previous volume")
        assertNotEquals(prev_note.panning_value, 30, "Nudge line up clears previous panning")
        assertNotEquals(prev_note.delay_value, 30, "Nudge line up clears previous delay")
        assertNotEquals(prev_note.effect_number_value, 30, "Nudge line up clears previous effect number")
        assertNotEquals(prev_note.effect_amount_value, 30, "Nudge line up clears previous effect amount")
        assertNotEquals(prev_fx.number_value, 30, "Nudge line up clears previous fx number")
        assertNotEquals(prev_fx.amount_value, 30, "Nudge line down clears previous fx amount")

        assertEquals(note.note_value, 30, "Nudge line up sets note to correct line")
        assertEquals(note.instrument_value, 30, "Nudge line up sets instrument")
        assertEquals(note.volume_value, 30, "Nudge line up sets volume")
        assertEquals(note.panning_value, 30, "Nudge line up sets panning")
        assertEquals(note.delay_value, 30, "Nudge line up sets delay")
        assertEquals(note.effect_number_value, 30, "Nudge line up sets effect number")
        assertEquals(note.effect_amount_value, 30, "Nudge line up sets effect amount")
        assertEquals(fx.number_value, 30, "Nudge line up sets fx number")
        assertEquals(fx.amount_value, 30, "Nudge line up sets fx amount")
      end
    }
  }
  run_tests("Nudge tests", cases1, default_interval)
  offset = calculate_offset(cases1, default_interval, offset)

  local cases2 = {
    {
      function()
        nudge_line(UP)
      end,
      function()
        local note = song.selected_pattern_track:line(1).note_columns[1]
        assertEquals(transport.edit_pos.line, 1, "Nudge line up stays at first line")
        assertEquals(note.note_value, 30, "Nudge line from note 1 does not change note")
      end
    },
    {
      function()
        set_line(last_line)
        jump_to_line(last_line)
      end,
      function ()
        assertEquals(transport.edit_pos.line, last_line, "Jump to last line.")
        assertEquals(song.selected_pattern_track:line(last_line).note_columns[1].note_value, 30, "Set line on last line.")
      end
    },
    {
      function()
        copy_line(DOWN)
      end,
      function()
        assertEquals(transport.edit_pos.line, last_line, "Copy down beyond last line does not move selection")
        assertEquals(song.selected_pattern_track:line(last_line).note_columns[1].note_value, 30, "Copy down beyond last line does not change note")
      end
    },
    {
      function()
        jump_to_line(1)
      end,
      function()
        assertEquals(transport.edit_pos.line, 1, "Jump to first line.")
      end
    },
    {
      function()
        copy_line(DOWN)
      end,
      function()
        local note = song.selected_pattern_track:line(2).note_columns[1]
        local prev_note = song.selected_pattern_track:line(1).note_columns[1]
        local fx = song.selected_pattern_track:line(2).effect_columns[1]
        local prev_fx = song.selected_pattern_track:line(1).effect_columns[1]

        assertEquals(transport.edit_pos.line, 2, "Copy line down moves selection down")
        assertEquals(prev_note.note_value, 30, "Copy line down does not clear previous note")
        assertEquals(prev_note.instrument_value, 30, "Copy line down does not clear previous instrument")
        assertEquals(prev_note.volume_value, 30, "Copy line down does not clear previous volume")
        assertEquals(prev_note.panning_value, 30, "Copy line down does not clear previous panning")
        assertEquals(prev_note.delay_value, 30, "Copy line down does not clear previous delay")
        assertEquals(prev_note.effect_number_value, 30, "Copy line down does not clear previous effect number")
        assertEquals(prev_note.effect_amount_value, 30, "Copy line down does not clear previous effect amount")
        assertEquals(prev_fx.number_value, 30, "Copy line down does not clear previous fx number")
        assertEquals(prev_fx.amount_value, 30, "Copy line down does not clear previous fx amount")

        assertEquals(note.note_value, 30, "Copy line down sets note to correct line")
        assertEquals(note.instrument_value, 30, "Copy line down sets instrument")
        assertEquals(note.volume_value, 30, "Copy line down sets volume")
        assertEquals(note.panning_value, 30, "Copy line down sets panning")
        assertEquals(note.delay_value, 30, "Copy line down sets delay")
        assertEquals(note.effect_number_value, 30, "Copy line down sets effect number")
        assertEquals(note.effect_amount_value, 30, "Copy line down sets effect amount")
        assertEquals(fx.number_value, 30, "Copy line down sets fx number")
        assertEquals(fx.amount_value, 30, "Copy line down sets fx amount")
        delete_line(1)
      end
    },
    {
      function()
        copy_line(UP)
      end,
      function()
        local note = song.selected_pattern_track:line(1).note_columns[1]
        local prev_note = song.selected_pattern_track:line(2).note_columns[1]
        local fx = song.selected_pattern_track:line(1).effect_columns[1]
        local prev_fx = song.selected_pattern_track:line(2).effect_columns[1]

        assertEquals(transport.edit_pos.line, 1, "Copy line up moves selection up")
        assertEquals(prev_note.note_value, 30, "Copy line up does not clear previous note")
        assertEquals(prev_note.instrument_value, 30, "Copy line up does not clear previous instrument")
        assertEquals(prev_note.volume_value, 30, "Copy line up does not clear previous volume")
        assertEquals(prev_note.panning_value, 30, "Copy line up does not clear previous panning")
        assertEquals(prev_note.delay_value, 30, "Copy line up does not clear previous delay")
        assertEquals(prev_note.effect_number_value, 30, "Copy line up does not clear previous effect number")
        assertEquals(prev_note.effect_amount_value, 30, "Copy line up does not clear previous effect amount")
        assertEquals(prev_fx.number_value, 30, "Copy line up does not clear previous fx number")
        assertEquals(prev_fx.amount_value, 30, "Copy line up does not clear previous fx amount")

        assertEquals(note.note_value, 30, "Copy line up sets note to correct line")
        assertEquals(note.instrument_value, 30, "Copy line up sets instrument")
        assertEquals(note.volume_value, 30, "Copy line up sets volume")
        assertEquals(note.panning_value, 30, "Copy line up sets panning")
        assertEquals(note.delay_value, 30, "Copy line up sets delay")
        assertEquals(note.effect_number_value, 30, "Copy line up sets effect number")
        assertEquals(note.effect_amount_value, 30, "Copy line up sets effect amount")
        assertEquals(fx.number_value, 30, "Copy line up sets fx number")
        assertEquals(fx.amount_value, 30, "Copy line up sets fx amount")
      end
    }
  }

  delay(function()
    run_tests("Copy line tests", cases2, default_interval)
  end, offset)

  offset = calculate_offset(cases2, default_interval, offset)

  local cases3 = {
    {function() reset() end, function() assertEquals(transport.edit_pos.line, 1, "Reset") end},
    {
      function() set_line(1) end, 
      function() 
        local next_note = song.selected_pattern_track:line(2).note_columns[1]
        assertEquals(transport.edit_pos.line, 1, "Set line")
        assertEquals(next_note.note_value, 121, "Set line does not clear next note")
      end
    },
    {
      function() copy_note_properties(UP) end, 
      function()
        local note = song.selected_pattern_track:line(1).note_columns[1]
        assertEquals(transport.edit_pos.line, 1, "Copy note properties up when on first line does not move selection")
        assertEquals(note.volume_value, 30, "Copy up when on first line does not clear previous volume")
        assertEquals(note.panning_value, 30, "Copy up when on first line does not clear previous panning")
        assertEquals(note.delay_value, 30, "Copy up when on first line does not clear previous delay")
        assertEquals(note.effect_number_value, 30, "Copy up when on first line does not clear previous effect number")
        assertEquals(note.effect_amount_value, 30, "Copy up when on first line does not clear previous effect amount")
      end
    },
    {
      function() copy_note_properties(DOWN) end,
      function()
        local note = song.selected_pattern_track:line(2).note_columns[1]
        local prev_note = song.selected_pattern_track:line(1).note_columns[1]

        assertEquals(transport.edit_pos.line, 2, "Copy note properties down moves selection down")
        assertEquals(prev_note.volume_value, 30, "Copy down does not clear previous volume")
        assertEquals(prev_note.panning_value, 30, "Copy down does not clear previous panning")
        assertEquals(prev_note.delay_value, 30, "Copy down does not clear previous delay")
        assertEquals(prev_note.effect_number_value, 30, "Copy down does not clear previous effect number")
        assertEquals(prev_note.effect_amount_value, 30, "Copy down does not clear previous effect amount")

        assertEquals(note.volume_value, 30, "Copy down sets volume")
        assertEquals(note.panning_value, 30, "Copy down sets panning")
        assertEquals(note.delay_value, 30, "Copy down sets delay")
        assertEquals(note.effect_number_value, 30, "Copy down sets effect number")
        assertEquals(note.effect_amount_value, 30, "Copy down sets effect amount")
        jump_to_line(last_line)
        set_line(last_line)
      end
    },
    {
      function () copy_note_properties(DOWN) end,
      function ()
        -- Copying down from last line doesn't do anything
        local note = song.selected_pattern_track:line(last_line).note_columns[1]
        assertEquals(transport.edit_pos.line, last_line, "Copy note properties down from last line does not move selection")
        assertEquals(note.volume_value, 30, "Copy down from last line does not clear previous volume")
        assertEquals(note.panning_value, 30, "Copy down from last line does not clear previous panning")
        assertEquals(note.delay_value, 30, "Copy down from last line does not clear previous delay")
        assertEquals(note.effect_number_value, 30, "Copy down from last line does not clear previous effect number")
        assertEquals(note.effect_amount_value, 30, "Copy down from last line does not clear previous effect amount")
      end
    },
    {
      function() copy_note_properties(UP) end,
      function()
        -- Copying up copies from previous line, moves selection up, and does not clear previous line
        local note = song.selected_pattern_track:line(last_line - 1).note_columns[1]
        local prev_note = song.selected_pattern_track:line(last_line).note_columns[1]

        assertEquals(transport.edit_pos.line, last_line - 1, "Copy note properties up moves selection up")
        assertEquals(prev_note.volume_value, 30, "Copy up does not clear previous volume")
        assertEquals(prev_note.panning_value, 30, "Copy up does not clear previous panning")
        assertEquals(prev_note.delay_value, 30, "Copy up does not clear previous delay")
        assertEquals(prev_note.effect_number_value, 30, "Copy up does not clear previous effect number")
        assertEquals(prev_note.effect_amount_value, 30, "Copy up does not clear previous effect amount")

        assertEquals(note.volume_value, 30, "Copy up sets volume")
        assertEquals(note.panning_value, 30, "Copy up sets panning")
        assertEquals(note.delay_value, 30, "Copy up sets delay")
        assertEquals(note.effect_number_value, 30, "Copy up sets effect number")
        assertEquals(note.effect_amount_value, 30, "Copy up sets effect amount")
      end
    }
  }

  delay(function()
    run_tests("Copy note properties tests", cases3, default_interval)
  end, offset)

  offset = calculate_offset(cases2, default_interval, offset)

  delay(function()
    reset()
    print("-------- Copy / Delete tests complete --------")
  end, offset)
end

function calculate_offset(previous_test_cases, default_interval, current_offset)
  current_offset = current_offset or 0
  local offset = (#previous_test_cases * 2) * (default_interval + 3)
  return offset + current_offset
end

function delay(func, ms)
  local timer_func
  timer_func = function()
    func()
    renoise.tool():remove_timer(timer_func)
  end
  renoise.tool():add_timer(timer_func, ms)
end

function run_tests(test_title, test_cases, inteval_ms)
  local function_num = 1

  for i, test_case in ipairs(test_cases) do
    local test_function = test_case[1]
    local assert_function = test_case[2]

    if i == 1 then
      print("-------- " .. test_title .. " --------")
    end
    
    delay(function()
      test_function()
    end, inteval_ms * function_num)

    function_num = function_num + 1

    delay(function()
      assert_function()
      print("Test " .. i .. " passed")
      function_num = function_num + 1
    end, inteval_ms * function_num)

    function_num = function_num + 1

  end
end

function reset()
  local song = renoise.song()
  local transport = song.transport

  jump_to_line(1)
  set_jump_step(1)
  delete_column_columns()
  delete_column_effects()
  transport.loop_block_enabled = false
  print("Song state reset.")
end

-- Test function helpers
function set_note(line_num)
  local song = renoise.song()
  song.selected_pattern_track:line(line_num).note_columns[1].note_value = 30
end

function set_line(line_num)
  local song = renoise.song()
  local note = song.selected_pattern_track:line(line_num).note_columns[1]
  local fx = song.selected_pattern_track:line(line_num).effect_columns[1]
  note.note_value = 30
  note.instrument_value = 30
  note.volume_value = 30
  note.panning_value = 30
  note.delay_value = 30
  note.effect_number_value = 30
  note.effect_amount_value = 30
  fx.amount_value = 30
  fx.number_value = 30
end
-- Enable loop block and set loop block to first line
function enable_loop_block()
  local song = renoise.song()
  local transport = song.transport
  transport.loop_block_enabled = true
  move_loop_to_current_pos()
end

return M