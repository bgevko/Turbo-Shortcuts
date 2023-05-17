

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
  local subdivision_start = find_block_start(block_size) -- function defined copy_functions.lua
  
  local current_pos = transport.edit_pos.line
  local loop_start = transport.loop_start.line
  local loop_end = transport.loop_end.line

  -- I set this up as a timer because renoise won't update the range correctly if it's performed too quickly
  local function update_loop()
    current_pos = transport.edit_pos.line
    loop_start = transport.loop_start.line
    loop_end = transport.loop_end.line
  
    if transport.loop_block_enabled and not (current_pos >= loop_start and current_pos <= loop_end) then
      if loop_start < subdivision_start then
        transport:loop_block_move_forwards()
      elseif loop_start > subdivision_start then
        transport:loop_block_move_backwards()
      end
    else
      renoise.tool():remove_timer(update_loop)
    end
  end

  renoise.tool():add_timer(update_loop, 1)
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

--------------------------
-- Get loop block range --
--------------------------
function get_loop_block_range()
  local transport = renoise.song().transport
  return transport.loop_start.line, transport.loop_end.line
end

--------------------------
-- Move to next/previous note in loop range
--------------------------
function move_to_note_in_block_range(direction)
  local song = renoise.song()
  local pos = song.transport.edit_pos
  local start_block, end_block = get_loop_block_range()
  local note_positions = get_note_positions_in_block_range(start_block, end_block)
  local note_column

  if song.transport.loop_block_enabled == false then
    return
  end

  if note_positions == nil then
    return
  end

  -- UP direction
  if direction == UP then
    for i = #note_positions, 1, -1 do
      if note_positions[i] < pos.line then
        pos.line = note_positions[i]
        break
      -- If we reach the first note in the loop, jump to the last note
      elseif i == 1 then
        pos.line = note_positions[#note_positions]
      end
    end
  
  -- DOWN direction
  elseif direction == DOWN then
    for i = 1, #note_positions do
      if note_positions[i] > pos.line then
        pos.line = note_positions[i]
        break
      -- If we reach the last note in the loop, jump to the first note
      elseif i == #note_positions then
        pos.line = note_positions[1]
      end
    end
  end

  -- if direction == UP then
  --   pos.line = pos.line - 1

  --   for i = pos.line, start_block, -1 do
  --     note_column = song.selected_pattern_track:line(i).note_columns[1]

  --     if note_column == nil then
  --       return
  --     end

  --     if (note_column.note_value ~= 121) and pos.line > start_block then
  --       pos.line = i
  --       break
  --     end
  --   end

  -- elseif direction == DOWN then
  --   if pos.line > end_block then
  --     pos.line = start_block
  --   end

  --   pos.line = pos.line + 1

  --   for i = pos.line, end_block do
  --     note_column = song.selected_pattern_track:line(i).note_columns[1]
  --     if note_column == nil then
  --       return
  --     end
  --     if (note_column.note_value ~= 121) then
  --       pos.line = i
  --       break
  --     end
  --   end
  -- end
  song.transport.edit_pos = pos
end

--------------------------
-- Get note positions in block range --
--------------------------
function get_note_positions_in_block_range(start_block, end_block)
  local song = renoise.song()
  local note_positions = {}
  local note_column

  for i = start_block, end_block do
    note_column = song.selected_pattern_track:line(i).note_columns[1]
    if note_column == nil then
      return
    end
    if (note_column.note_value ~= 121) then
      table.insert(note_positions, i)
    end
  end

  return note_positions
end