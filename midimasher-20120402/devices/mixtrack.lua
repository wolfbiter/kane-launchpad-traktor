------------------------------------------------------
-- Deck A Controls -----------------------------------
------------------------------------------------------
-- Mixer
add_control("decka_volume",		1, "cc", 8)
add_control("decka_monitorcue",		1, "note", 101)

add_control("decka_eq_low",		1, "cc", 20)
add_control("decka_eq_mid",		1, "cc", 18)
add_control("decka_eq_high",		1, "cc", 16)

add_control("decka_eqkill_low",		1, "note", 90)
add_control("decka_eqkill_mid",		1, "note", 91)
add_control("decka_eqkill_high",	1, "note", 92)

-- Transport
add_control("decka_sync",		1, "note", 64)
add_control("decka_cue",		1, "note", 51)
add_control("decka_play",		1, "note", 59)
add_control("decka_cueplay",		1, "note", 74)

add_control("decka_platter_touch",	1, "note", 78)
add_control("decka_platter",		1, "cc", 25)

add_control("decka_pitch_fader",	1, "cc", 13)
add_control("decka_pitch_down",		1, "note", 67)
add_control("decka_pitch_up",		1, "note", 68)

-- Looping
add_control("decka_loop1",		1, "note", 97)
add_control("decka_loop2",		1, "note", 83)
add_control("decka_loop3",		1, "note", 84)
add_control("decka_loop4",		1, "note", 85)

-- Effects
add_control("decka_fx_button",		1, "note", 99)
add_control("decka_fx_knob2",		1, "cc", 29)
add_control("decka_fx_knob1",		1, "cc", 28)
add_control("decka_fx_select",		1, "cc", 27)
add_control("decka_fx_select_push",	1, "note", 104)

-- Misc
add_control("decka_keylock",		1, "note", 81)
add_control("decka_scratch",		1, "note", 72)
add_control("decka_button1",		1, "note", 89)

------------------------------------------------------
-- Deck B Controls -----------------------------------
------------------------------------------------------
-- Mixer
add_control("deckb_volume",		1, "cc", 9)
add_control("deckb_monitorcue",		1, "note", 102)

add_control("deckb_eq_low",		1, "cc", 21)
add_control("deckb_eq_mid",		1, "cc", 19)
add_control("deckb_eq_high",		1, "cc", 17)

add_control("deckb_eqkill_low",		1, "note", 94)
add_control("deckb_eqkill_mid",		1, "note", 95)
add_control("deckb_eqkill_high",	1, "note", 96)

-- Transport
add_control("deckb_sync",		1, "note", 71)
add_control("deckb_cue",		1, "note", 60)
add_control("deckb_play",		1, "note", 66)
add_control("deckb_cueplay",		1, "note", 76)

add_control("deckb_platter_touch",	1, "note", 77)
add_control("deckb_platter",		1, "cc", 24)

add_control("deckb_pitch_fader",	1, "cc", 14)
add_control("deckb_pitch_down",		1, "note", 69)
add_control("deckb_pitch_up",		1, "note", 70)

-- Looping
add_control("deckb_loop1",		1, "note", 98)
add_control("deckb_loop2",		1, "note", 86)
add_control("deckb_loop3",		1, "note", 87)
add_control("deckb_loop4",		1,"note", 88)

-- Effects
add_control("deckb_fx_button",		1, "note", 100)
add_control("deckb_fx_select",		1, "cc", 30)
add_control("deckb_fx_select_push",	1, "note", 103)
add_control("deckb_fx_knob1",		1, "cc", 31)
add_control("deckb_fx_knob2",		1, "cc", 32)

-- Misc
add_control("deckb_scratch",		1, "note", 80)
add_control("deckb_keylock",		1, "note", 82)
add_control("deckb_button1",		1, "note", 93)

------------------------------------------------------
--Global/Misc Controls
------------------------------------------------------
add_control("crossfader",		1, "cc", 10)
add_control("mastervolumefader",	1, "cc", 23)
add_control("monitorcuegain",		1, "cc", 11)
add_control("monitorcuemix",		1, "cc", 12)

add_control("browserknob",		1, "cc", 26)
add_control("browserknobpush",		1, "note", 79)
add_control("browserloada",		1, "note", 75)
add_control("browserloadb",		1, "note", 52)
add_control("browserback",		1, "note", 105)

-- Other LEDs
add_control("decka_pitch_led",		1, "note", 124)
add_control("deckb_pitch_led",		1, "note", 125)
add_control("browserfile",		1, "note", 126)
add_control("browserfolder",		1, "note", 127)

-- Note: The LEDs of the looping sections have three states:
-- 0 = Off
-- 1 = Red
-- 2-127 = Orange
