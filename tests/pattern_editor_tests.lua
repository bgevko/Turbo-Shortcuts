luaunit = require("tests.luaunit")
require("Pattern_Editor.navigation_functions")
require("Pattern_Editor.constants")
-- -------------------------

local M = {}  -- create a new table

function M.run_tests()
  testNavigation()
end

function testNavigation()
  local assert = luaunit.assertEquals
  local song = renoise.song()
  local transport = song.transport
  local last_line = song.selected_pattern.number_of_lines
  local tests_ran = 0
  local default_interval = 40

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

  tests_ran = tests_ran + (#cases1 * 2)

  local offset = set_offset(tests_ran, default_interval)
  delay(function()
    run_tests("Set jump step and custom move", cases2, default_interval)
  end, offset)

end

function set_offset(tests_ran, default_interval)
  local offset = tests_ran * (default_interval + 3)
  return offset
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
  print("Song state reset.")
end

return M