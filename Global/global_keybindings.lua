

--------------------------------------------------------------------------------
-- KEY BINDINGS
--------------------------------------------------------------------------------

renoise.tool():add_keybinding {
  name = "Global:Application:Switch to pattern editor",
  invoke = function() switch_to_sampler() end
}

--------------------------------------------------------------------------------
-- Switching windows functions
--------------------------------------------------------------------------------
function switch_to_pattern_editor()
  renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_PATTERN_EDITOR
end

function switch_to_mixer_window()
  renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_MIXER
end

function switch_to_phrase_editor()
  renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_PATTERN_EDITOR
end

function switch_to_sample_keyzones()
  renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_SAMPLE_KEYZONES
end

function switch_to_sampler()
  renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_SAMPLE_EDITOR
end

function switch_to_sample_modulation()
  renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_SAMPLE_MODULATION
end

function switch_to_sample_effects()
  renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_SAMPLE_EFFECTS
end

function switch_to_plugin_editor()
  renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_TRACK_DSPS
end

function switch_to_midi_editor()
  renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_PATTERN_EDITOR
end