---@diagnostic disable: undefined-global
--[[============================================================================
com.renoise.ExampleTool.xrnx/main.lua
============================================================================]]--

-- Includes
require "pattern_editor_navigation"
require "pattern_editor_insert_delete"
require "switching_windows"

--------------------------------------------------------------------------------
-- PREFERENCES
--------------------------------------------------------------------------------

local options = renoise.Document.create("ExampleToolPreferences") {
  show_debug_prints = true
}

-- then we simply register this document as the main preferences for the tool:
renoise.tool().preferences = options

--------------------------------------------------------------------------------
-- MENU ENTRIES
--------------------------------------------------------------------------------

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Custom Jump",
  invoke = function()
    show_dialog()
  end
}

--------------------------------------------------------------------------------
-- debug hook
--------------------------------------------------------------------------------

_AUTO_RELOAD_DEBUG = function()
  handle_auto_reload_debug_notification()
end


if (options.show_debug_prints.value) then
  print("com.renoise.ExampleTool: script was loaded...")
end

--------------------------------------------------------------------------------
-- UTILITY FUNCTIONS
--------------------------------------------------------------------------------

-----------------
-- show_dialog --
-----------------
function show_dialog(message)
  renoise.app():show_warning(
    ("com.renoise.ExampleTool:".. message):format(message)
  )
end

-------------------------
-- show_status_message --
-------------------------
local status_message_count = 0

function show_status_message(message)
  local status_message_count = status_message_count + 1

  renoise.app():show_status(
    ("com.renoise.ExampleTool: ".. message):format(
     status_message_count)
  )
end


-----------------------
-- Auto reload debug --
-----------------------
function handle_auto_reload_debug_notification()
  if (options.show_debug_prints.value) then
    print("com.renoise.ExampleTool: ** auto_reload_debug notification")
  end
end