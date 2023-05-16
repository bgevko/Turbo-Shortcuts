

-- In this file, you'll find all functions that relate to navigation in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua

require "Pattern_Editor.constants"

-----------------------
-- Custom navigation --
-----------------------

function jump(direction, specified_amount)
  local song = renoise.song()
  local new_pos = song.transport.edit_pos
  local amount = 1 -- Amount to jump (set later)
  -- show_status_message("Jumping " .. amount .. " lines")

  -- Jump by specified amount, or by JUMP_STEP if specified_amount is not set
  if (direction == UP) then
    amount = specified_amount or (-1 * JUMP_STEP)
  else -- JUMP_DOWN
    amount = specified_amount or (1 * JUMP_STEP)
  end

  -- Jump execution
  new_pos.line = new_pos.line + amount
  -- Prevent wraparound (stop at bottom of pattern and at top of pattern)
  if (new_pos.line > song.selected_pattern.number_of_lines) then
    new_pos.line = song.selected_pattern.number_of_lines
  elseif (new_pos.line < 1) then
    new_pos.line = 1
  end

  -- Execute the jump
  song.transport.edit_pos = new_pos
end

-------------------
-- set jump step --
-------------------
function set_jump_step(step)
  JUMP_STEP = step
  show_status_message("Jump step set to " .. step)
end

----------------------
-- double jump step --
----------------------
function double_jump_step()
  if (JUMP_STEP < JUMP_MAX) then
    JUMP_STEP = JUMP_STEP * 2
    show_status_message("Jump step doubled to " .. JUMP_STEP)
  else
    show_status_message("Jump step is at maximum value.")
  end
end

--------------------
-- half jump step --
--------------------
function half_jump_step()
  if (JUMP_STEP > 1) then
    JUMP_STEP = JUMP_STEP / 2
    show_status_message("Jump step halved to " .. JUMP_STEP)
  else
    show_status_message("Jump step is at minimum value.")
  end
end

------------------------
-- Jump to last note  -- Based on the first index of the selected track
------------------------
function jump_to_last_note_in_track()
  local song = renoise.song()
  local new_pos = song.transport.edit_pos
  local note_column

  -- Find the last note in the pattern
  for i = 1, song.selected_pattern.number_of_lines do
    note_column = song.selected_pattern_track:line(i).note_columns[1]
    if (note_column.note_value ~= 121) then
      new_pos.line = i
    end
  end
  song.transport.edit_pos = new_pos
end

------------------------
-- Jump to first note --
------------------------
function jump_to_first_note_in_track()
  local song = renoise.song()
  local new_pos = song.transport.edit_pos
  local note_column

  -- Find the first note in the pattern
  for i = song.selected_pattern.number_of_lines, 1, -1 do
    note_column = song.selected_pattern_track:line(i).note_columns[1]
    if (note_column.note_value ~= 121) then
      new_pos.line = i
    end
  end
  song.transport.edit_pos = new_pos
end

--------------------
-- Jump to specific line --
--------------------
function jump_to_line(line)
  if (line < 1) then
    line = 1
  elseif (line > renoise.song().selected_pattern.number_of_lines) then
    line = renoise.song().selected_pattern.number_of_lines
  end

  local song = renoise.song()
  local new_pos = song.transport.edit_pos
  new_pos.line = line
  song.transport.edit_pos = new_pos
end

--------------------
-- Create a loop around the current block --
--------------------
function move_loop_to_current_pos()
  local transport = renoise.song().transport
  local block_size = transport.loop_end.line - transport.loop_start.line
  local subdivision_start = find_block_start(block_size) -- function defined in pattern_editor_insert_delete.lua
  local loop_start = transport.loop_start.line
  print(subdivision_start)
  print(block_size)
  if loop_start < subdivision_start then
    while loop_start < subdivision_start do
      transport:loop_block_move_forwards()
      loop_start = transport.loop_start.line
    end
  elseif loop_start > subdivision_start then
    while loop_start > subdivision_start do
      transport:loop_block_move_backwards()
      loop_start = transport.loop_start.line
    end
  end
end

--------------------------
-- Get quantized loop range from current position --
--------------------------
function get_loop_block_range(block_size, starting_pos) -- starting_pos optional, defaults to current line
  local song = renoise.song()
  local range_start = find_block_start(block_size, starting_pos) -- function defined in pattern_editor_insert_delete.lua
  local range_end = range_start + block_size
  local range = song.selected_pattern_track:lines_in_range(range_start, range_end - 1)
  return range
end