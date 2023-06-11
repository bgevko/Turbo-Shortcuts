

-- In this file, you'll find all functions that relate to navigation in the pattern editor.
-- Keybindings for these functions are located in pattern_editor_insert_delete.lua
-- All constants defined in constants.lua

require "Pattern_Editor.constants"

--[[ CUSTOM NAVIGATION ------------------------------------------------------------
  This function offers a replacement for the default jump in Renoise, allowing users to move around the pattern editor in customizable steps (default of 1) independent of the step length in the patter editor. It's beneficial for users who prefer a zero step length while editing, preventing the selection from moving down when entering a note. The function also prevents wraparound, enhancing the ease of editing notes at the top and bottom of the pattern. You can turn wraparound back on by setting the wraparound variable to true.
  
  @params: direction - the direction to jump (UP or DOWN)
           specified_amount - the amount to jump (optional)
  --------------------------------------------------------------------------------]]
function jump(direction, specified_amount)
  local song = renoise.song()
  local new_pos = song.transport.edit_pos
  local amount = 1 -- Amount to jump (set later)
  local wraparound = false

  -- Jump by specified amount, or by JUMP_STEP if specified_amount is not set
  if (direction == UP) then
    amount = specified_amount or (-1 * JUMP_STEP)
    if amount == 0 then
      amount = -1
    elseif amount > 0 then
      amount = amount * -1
    end
  else -- JUMP_DOWN
    amount = specified_amount or (1 * JUMP_STEP)
    if amount == 0 then
      amount = 1
    elseif amount < 0 then
      amount = amount * -1
    end
  end
  
  -- Jump execution
  new_pos.line = new_pos.line + amount
  -- Prevent wraparound (stop at bottom of pattern and at top of pattern)
  if not wraparound then
    if (new_pos.line > song.selected_pattern.number_of_lines) then
      new_pos.line = song.selected_pattern.number_of_lines
    elseif (new_pos.line < 1) then
      new_pos.line = 1
    end
  end

  -- Execute the jump
  song.transport.edit_pos = new_pos
end


--[[ SET JUMP STEP ----------------------------------------------------
  Sets the global jump step to the specified value. This the the value
  that the jump function will use to navigate the pattern editor.
  @params: amount - the step to set the jump step to
  --------------------------------------------------------------------]]
function set_jump_step(amount)
  JUMP_STEP = amount
  if JUMP_STEP < 1 then
    JUMP_STEP = 1
  elseif JUMP_STEP > JUMP_MAX then
    JUMP_STEP = JUMP_MAX
  end
  show_status_message("Jump step set to " .. amount)
end


--[[ DOUBLE JUMP STEP -------------------------------------------------
  Doubles the global jump step value.
  --------------------------------------------------------------------]]
function double_jump_step()
  if (JUMP_STEP < JUMP_MAX) then
    JUMP_STEP = JUMP_STEP * 2
    show_status_message("Jump step doubled to " .. JUMP_STEP)
  else
    show_status_message("Jump step is at maximum value.")
  end
end


--[[ HALF JUMP STEP ---------------------------------------------------
  Halves the global jump step value.
  --------------------------------------------------------------------]]
function halve_jump_step()
  if (JUMP_STEP > 1) then
    JUMP_STEP = JUMP_STEP / 2
    show_status_message("Jump step halved to " .. JUMP_STEP)
  else
    show_status_message("Jump step is at minimum value.")
  end
end


--[[ JUMP TO LAST NOTE ------------------------------------------------
  Jumps to the last note in the pattern.
  --------------------------------------------------------------------]]
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


--[[ JUMP TO FIRST NOTE ------------------------------------------------
  Jumps to the first note in the pattern.
  --------------------------------------------------------------------]]
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


--[[ JUMP TO SPECIFIC LINE --------------------------------------------
  Jumps to the specified line in the pattern. Mostly used as a helper.
  @params: line - the line to jump to
  --------------------------------------------------------------------]]
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


--[[ MOVE LOOP TO CURRENT POSITION -------------------------------------
  This function moves the loop block to your current position. It works 
  by moving in increments of whatever the current loop block size is
  until the selected position is within the loop block. It's a bit of a
  hack, but it works.
--------------------------------------------------------------------]]
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


--[[ GET LOOP BLOCK RANGE ----------------------------------------------
  Returns the start and end lines of the loop block.
  @returns: start_line, end_line]]
function get_loop_block_range()
  local transport = renoise.song().transport
  return transport.loop_start.line, transport.loop_end.line
end


--[[ MOVE TO NOTE IN BLOCK RANGE ---------------------------------------
  This function is meant to making editing notes in a loop block easier.
  When the loop block is enabled, it will move the cursor to the closest
  note in the loop block. Once inside, this function will move the cursor
  to the next or previous note in the loop block, wrapping around if
  when reaching the loop boundaries.
  @params: direction - the direction to move the cursor in
  --------------------------------------------------------------------]]
function move_to_note_in_block_range(direction)
  local song = renoise.song()
  local pos = song.transport.edit_pos
  local note_positions = get_notes_in_loop_block()

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
  song.transport.edit_pos = pos
end


--[[ GET NOTES IN PATTERN ----------------------------------------------
  Returns a table of all the note positions in the pattern.
  @returns: note_positions - a table of all the note positions in the pattern
  --------------------------------------------------------------------]]
function get_notes_in_pattern()
  return get_notes_in_block(1, renoise.song().selected_pattern.number_of_lines)
end


--[[ GET NOTES IN SPECIFIED BLOCK -------------------------------------
  Returns a table of all the note positions in the specified block range.
  Mostly used as a helper.
  @params: start_block - the starting block
           end_block - the ending block
  @returns: note_positions - a table of all the note positions in the block
  --------------------------------------------------------------------]]
  function get_notes_in_block(start_block, end_block)
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


--[[ GET NOTES IN LOOP BLOCK -------------------------------------------
  Returns a table of all the note positions inside the loop block.
  --------------------------------------------------------------------]]
function get_notes_in_loop_block()
  local start_block, end_block = get_loop_block_range()
  return get_notes_in_block(start_block, end_block)
end