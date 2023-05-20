

-- This file contains all the global variables for all Pattern Editor functions. 

-- Navigation constants
UP = 1
DOWN = 2
JUMP_STEP = 1
JUMP_MAX = 64

-- Edit modes
LINE = 1
COLUMN = 2
VOL_PAN_DELAY = 3
EFFECTS = 4
NOTE_ONLY = 5

-- Default edit mode
EDIT_MODE = COLUMN

-- Note parameters 
NOTE = 1
VOL = 2
PAN = 3
DELAY = 4
FX = 5

-- FX parameters
X = "x"
Y = "y"

-- FX columns
FX1 = 1
FX2 = 2
FX3 = 3
FX4 = 4
FX5 = 5
FX6 = 6
FX7 = 7
FX8 = 8
SELECTED_FX_COLUMN = 1

-- General FX Types
ARPEGGIO = 1
SLIDE_UP = 2
SLIDE_DOWN = 3
GLIDE_TO_NOTE = 4
VIBRATO = 5
FADE_VOLUME_IN = 6
FADE_VOLUME_OUT = 7
TREMOLO = 8
CUT_VOLUME = 9
TRIGGER_SAMPLE = 10
PLAY_SAMPLE_BACKWARDS = 11
SET_ENVELOPE_POSITION = 12
AUTO_PAN = 13

-- Renoise specific FX types
TRIGGER_PHRASE = 14
PLAY_PHRASE_BACKWARDS = 15

-- Instrument Commands
MUTE_CHANNEL = 16
TRIGGER_PHRASE_NUMBER = 17
DELAY_LINE_PLAYBACK = 18
MAYBE_TRIGGER = 19
RETRIGGER_INSTRUMENT = 20

-- Device commands
MUTE_PREMIXER = 21
PAN_PREMIXER = 22
WIDTH_PREMIXER = 23
STOP_ALL_NOTES = 24

-- Global commands
SET_BPM = 25
SET_LINES_PER_BEAT = 26
SET_TPL = 27
TOGGLE_SONG_GROOVE = 28
BREAK_PATTERN = 29
DELAY_PATTERN = 30

-- Note commands
FADE_VOLUME_IN_NOTE = 31
FADE_VOLUME_OUT_NOTE = 32
PANNING_SLIDE_LEFT = 33
PANNING_SLIDE_RIGHT = 34
NOTE_SLIDE_UP = 35
NOTE_SLIDE_DOWN = 36
NOTE_GLIDE_TO_NOTE = 37
NOTE_CUT_VOLUME = 38
NOTE_PLAY_SAMPLE_BACKWARDS = 39
NOTE_SET_DELAY = 40
NOTE_MAYBE_TRIGGER = 41
NOTE_RETRIGGER_INSTRUMENT = 42

