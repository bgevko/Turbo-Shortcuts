---@diagnostic disable: undefined-global
--[[============================================================================
com.renoise.TurboShortcuts.xrnx/main.lua
============================================================================]]--
-- This file contains settings and utility functions for the tool.
-- Keybindings are defined in seperate files, named after the category that they belong to
--    i.e. pattern_editor_insert_delete.lua contains keybinds for Pattern Editor: Insert/Delete, etc.
--    If you want to add keybindings, start with their respective category file. From there, you can
--    see which functions are used, which will be defined in their own files.

-- Includes
require "Pattern_Editor.navigation_keybindings"
require "Pattern_Editor.insert_delete_keybindings"
require "Global.global_keybindings"

pattern_editor_tests = require("tests.pattern_editor_tests")

--------------------------------------------------------------------------------
-- PREFERENCES
--------------------------------------------------------------------------------

local options = renoise.Document.create("TurboShortcutsPreferences") {
  show_debug_prints = true,
  run_tests_on_startup = true,
}

-- then we simply register this document as the main preferences for the tool:
renoise.tool().preferences = options

--------------------------------------------------------------------------------
-- MENU ENTRIES
--------------------------------------------------------------------------------

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Turbo Shortcuts",
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

-- renoise.tool().app_became_active_observable:add_notifier(function()
--   print("com.renoise.TurboShortcuts: app became active")
-- end)

if (options.show_debug_prints.value) then
  print("com.renoise.TurboShortcuts: script was loaded...")
end

--------------------------------------------------------------------------------
-- UTILITY FUNCTIONS
--------------------------------------------------------------------------------

-----------------
-- show_dialog --
-----------------
function show_dialog(message)
  renoise.app():show_warning(
    ("com.renoise.TurboShortcuts:".. message):format(message)
  )
end

-------------------------
-- show_status_message --
-------------------------
local status_message_count = 0

function show_status_message(message)
  local status_message_count = status_message_count + 1

  renoise.app():show_status(
    (message):format(
     status_message_count)
  )
end

-----------------------
-- Auto reload debug --
-----------------------
function handle_auto_reload_debug_notification()
  if (options.show_debug_prints.value) then
    print("com.renoise.TurboShortcuts: ** auto_reload_debug notification")
  end

  -- Run unit tests if enabled (Disabled by default)
  if (options.run_tests_on_startup.value) then
    print("Initializing tests...")

    -- If you choose to run tests, run these one at a time. Because renoise has a bit of latency when
    -- certain operations are performed, the tests are timed manually. If you run them all at once,
    -- some tests will fail. Until we get support for async/await, this is the best we can do.
    -- Test output is printed to Scripting Terminal/Editor upon loading the tool.


    -- pattern_editor_tests.nav_tests()
    pattern_editor_tests.copy_delete_tests()
  end
end