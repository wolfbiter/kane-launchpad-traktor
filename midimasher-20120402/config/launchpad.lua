-------------------------------------------------------------------------------
-- connect devices
-------------------------------------------------------------------------------

open_midi_device("lp", "launchpad", "Launchpad", "Launchpad", 4)
open_midi_device("traktor", "traktor", "V:Traktor to MM", "V:MM to Traktor")
open_midi_device("mf1", "generic", "V:MidiFighter1 Input", "V:MidiFighter1 Output")
open_midi_device("mf2", "generic", "V:MidiFighter2 Input", "V:MidiFighter2 Output")
open_midi_device("mf3", "generic", "V:MidiFighter3 Input", "V:MidiFighter3 Output")

--
-- test launchpad leds and clear them all
--

launchpad.init("lp")
launchpad.traktor_sync("lp") -- sync any flashing leds with traktor
enable_launchpad_led_fix("lp")

--
-- the colors we'll use for different hotcue types on the lp (1=normal, 6=loop, 2-5=?)
--

lp_hotcue_colors = { lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_red }

--
-- define the range of loop sizes for the loops page
--

loop_sizes = { "/8", "/4", "/2", "1", "2", "4", "8", "16" }

-------------------------------------------------------------------------------
-- page change buttons
-------------------------------------------------------------------------------

toggle_group("lp", { "session", "user1", "user2", "mixer" }, 0, lp_hi_yellow, lp_lo_red, "lp_page", function()
	launchpad.set_page("lp", get("lp_page"))
end)

--
-- a "shift" button on all pages
--

hold_modifier("lp", "arm", 0, lp_hi_yellow, lp_lo_red, "lp_shift")
toggle_modifier("lp", "solo", 0, lp_hi_yellow, lp_lo_red, "lp_shift")

-------------------------------------------------------------------------------
-- LAUNCHPAD PAGE 1
-------------------------------------------------------------------------------

--
-- define a "slicer shift" that will enable the slicer when pressed along with a hotcue
--

hold_modifier("lp", "trkon", 1, lp_hi_yellow, lp_lo_green, "lp_slicer_shift")

--
-- transport functions - top row
--

toggle("lp", "0,0", 1, lp_flash_hi_yellow, lp_hi_red, "traktor", "play_a")
button("lp", "0,1", 1, lp_hi_yellow, lp_hi_red, "traktor", "cue_a")
toggle("lp", "0,2", 1, lp_hi_green, lp_mi_green, "traktor", "beat_sync_a")
button_shift("lp", "0,3", 1, lp_hi_yellow, lp_lo_red, "traktor", "tempo_bend_up_a", "tempo_bend_down_a", "lp_shift")

toggle("lp", "0,4", 1, lp_flash_hi_yellow, lp_hi_red, "traktor", "play_b")
button("lp", "0,5", 1, lp_hi_yellow, lp_hi_red, "traktor", "cue_b")
toggle("lp", "0,6", 1, lp_hi_green, lp_mi_green, "traktor", "beat_sync_b")
button_shift("lp", "0,7", 1, lp_hi_yellow, lp_lo_red, "traktor", "tempo_bend_up_b", "tempo_bend_down_b", "lp_shift")

--
-- midi clock
--

send("traktor", "master_tempo_clock_send", ON)
button("lp", "vol", 1, lp_hi_yellow, lp_hi_red, "traktor", "master_tempo_clock_sync_midi")
toggle("lp", "pan", 1, lp_hi_yellow, lp_hi_red, "traktor", "master_tempo_clock_send")

hold_modifier("lp", "snda", 1, lp_hi_yellow, lp_lo_red, nil, function(d, e, v, p)
	if v > 0 then
		midi_clock_adjust(1)
	end
end)

hold_modifier("lp", "sndb", 1, lp_hi_yellow, lp_lo_red, nil, function(d, e, v, p)
	if v > 0 then
		midi_clock_adjust(-1)
	end
end)

--
-- virtual midifighter, top/left 4x4 grid, 4banks mode
--

virtual_midifighter_4banks("lp", 1, "mf1", 1, 0)

--
-- function to enable the slicer if a twitch area is changed to page 2, turn on/off slicer loop mode if the 
-- page 2 button is pressed while already in slicer mode and disable the slicer if a different page is selected
--

function twitch_change_page(d, e, v, p, is_new_page, parent)

	launchpad.set_page(d, p, parent)

	-- enable slicer if switched to page 2

	local sid

	if d == "twitch_a" then
		sid = 1
	else
		sid = 2
	end

	if is_new_page then
		if p == 2 then
			traktor.slicer_enable(sid)
		else
			traktor.slicer_disable(sid)
		end
	elseif p == 2 then
		if traktor.slicer[sid].loop_mode then
			traktor.slicer[sid].loop_mode = false
			send("lp", e, lp_hi_yellow, 1)
		else
			traktor.slicer[sid].loop_mode = true
			send("lp", e, lp_flash_hi_red, 1)
		end
	end
end

--
-- function to enable slicer and switch to page 2 if pressing slicer shift button with a hotcue
--

function slicer_check(d, v, sid, hotcue)
	if v > 0 and get("lp_slicer_shift") > 0 then
		traktor.slicer_enable(sid, hotcue)

		-- fake a button press to change the twitch page
		-- device name will be twitch_a or twitch_b

		if d == "twitch_a" then
			create("lp", "5,1", ON, 1)
		else
			create("lp", "5,5", ON, 1)
		end
	end
end

--
-- create 2 areas on the bottom 3 rows with their own 4 banks (ala twitch)
--

toggled_layers("lp", 1, "twitch_a", grid("6,0", "7,3"), grid("5,0", "5,3"), lp_hi_yellow, lp_hi_red, "twitch_change_page")
toggled_layers("lp", 1, "twitch_b", grid("6,4", "7,7"), grid("5,4", "5,7"), lp_hi_yellow, lp_hi_red, "twitch_change_page")

-------------------------------------------------------------------------------
-- TWITCH PERFORMANCE PADS LEFT
-------------------------------------------------------------------------------


--
-- PAGE 1 - hotcues
--

traktor.hotcue("twitch_a", "6,0", 1, lp_hotcue_colors, lp_black, "lp_shift", "a", 1, function(d,e,v,p) slicer_check(d, v, 1, 1) end)
traktor.hotcue("twitch_a", "6,1", 1, lp_hotcue_colors, lp_black, "lp_shift", "a", 2, function(d,e,v,p) slicer_check(d, v, 1, 2) end)
traktor.hotcue("twitch_a", "6,2", 1, lp_hotcue_colors, lp_black, "lp_shift", "a", 3, function(d,e,v,p) slicer_check(d, v, 1, 3) end)
traktor.hotcue("twitch_a", "6,3", 1, lp_hotcue_colors, lp_black, "lp_shift", "a", 4, function(d,e,v,p) slicer_check(d, v, 1, 4) end)
traktor.hotcue("twitch_a", "7,0", 1, lp_hotcue_colors, lp_black, "lp_shift", "a", 5, function(d,e,v,p) slicer_check(d, v, 1, 5) end)
traktor.hotcue("twitch_a", "7,1", 1, lp_hotcue_colors, lp_black, "lp_shift", "a", 6, function(d,e,v,p) slicer_check(d, v, 1, 6) end)
traktor.hotcue("twitch_a", "7,2", 1, lp_hotcue_colors, lp_black, "lp_shift", "a", 7, function(d,e,v,p) slicer_check(d, v, 1, 7) end)
traktor.hotcue("twitch_a", "7,3", 1, lp_hotcue_colors, lp_black, "lp_shift", "a", 8, function(d,e,v,p) slicer_check(d, v, 1, 8) end)

--
-- PAGE 2 - slicer
--

traktor.slicer_create("twitch_a", grid("6,0", "7,3"), 2, "a", lp_hi_yellow, lp_lo_red)

--
-- PAGE 3 - loops
--

traktor.loops("twitch_a", grid("6,0", "7,3"), 3, lp_hi_green, lp_lo_green, "a", "lp_shift", loop_sizes)

--
-- PAGE 4 - beatjumps first row
--

button_shift("twitch_a", "6,0", 4, lp_hi_yellow, lp_lo_yellow, "traktor", "beatjump_-4_a", "beatjump_+4_a", "lp_shift")
button_shift("twitch_a", "6,1", 4, lp_hi_yellow, lp_lo_yellow, "traktor", "beatjump_-8_a", "beatjump_+8_a", "lp_shift")
button_shift("twitch_a", "6,2", 4, lp_hi_yellow, lp_lo_yellow, "traktor", "beatjump_-16_a", "beatjump_+16_a", "lp_shift")
button_shift("twitch_a", "6,3", 4, lp_hi_yellow, lp_lo_yellow, "traktor", "beatjump_-32_a", "beatjump_+32_a", "lp_shift")


-------------------------------------------------------------------------------
-- TWITCH PERFORMANCE PADS RIGHT
-------------------------------------------------------------------------------

--
-- PAGE 1 - hotcues
--

traktor.hotcue("twitch_b", "6,4", 1, lp_hotcue_colors, lp_black, "lp_shift", "b", 1, function(d,e,v,p) slicer_check(d, v, 2, 1) end)
traktor.hotcue("twitch_b", "6,5", 1, lp_hotcue_colors, lp_black, "lp_shift", "b", 2, function(d,e,v,p) slicer_check(d, v, 2, 2) end)
traktor.hotcue("twitch_b", "6,6", 1, lp_hotcue_colors, lp_black, "lp_shift", "b", 3, function(d,e,v,p) slicer_check(d, v, 2, 3) end)
traktor.hotcue("twitch_b", "6,7", 1, lp_hotcue_colors, lp_black, "lp_shift", "b", 4, function(d,e,v,p) slicer_check(d, v, 2, 4) end)
traktor.hotcue("twitch_b", "7,4", 1, lp_hotcue_colors, lp_black, "lp_shift", "b", 5, function(d,e,v,p) slicer_check(d, v, 2, 5) end)
traktor.hotcue("twitch_b", "7,5", 1, lp_hotcue_colors, lp_black, "lp_shift", "b", 6, function(d,e,v,p) slicer_check(d, v, 2, 6) end)
traktor.hotcue("twitch_b", "7,6", 1, lp_hotcue_colors, lp_black, "lp_shift", "b", 7, function(d,e,v,p) slicer_check(d, v, 2, 7) end)
traktor.hotcue("twitch_b", "7,7", 1, lp_hotcue_colors, lp_black, "lp_shift", "b", 8, function(d,e,v,p) slicer_check(d, v, 2, 8) end)

--
-- PAGE 2 - slicer
--

traktor.slicer_create("twitch_b", grid("6,4", "7,7"), 2, "b", lp_hi_yellow, lp_lo_red)

--
-- PAGE 3 - loops
--

traktor.loops("twitch_b", grid("6,4", "7,7"), 3, lp_hi_green, lp_lo_green, "lp_shift", "b", loop_sizes)

--
-- PAGE 4 - beatjumps first row
--

button_shift("twitch_b", "6,4", 4, lp_hi_yellow, lp_lo_yellow, "traktor", "beatjump_-4_b", "beatjump_+4_b", "lp_shift")
button_shift("twitch_b", "6,5", 4, lp_hi_yellow, lp_lo_yellow, "traktor", "beatjump_-8_b", "beatjump_+8_b", "lp_shift")
button_shift("twitch_b", "6,6", 4, lp_hi_yellow, lp_lo_yellow, "traktor", "beatjump_-16_b", "beatjump_+16_b", "lp_shift")
button_shift("twitch_b", "6,7", 4, lp_hi_yellow, lp_lo_yellow, "traktor", "beatjump_-32_b", "beatjump_+32_b", "lp_shift")

-------------------------------------------------------------------------------
-- LAUNCHPAD PAGE 2 
-------------------------------------------------------------------------------

--
-- create a couple of "normal mode" virtual midi fighters
--

virtual_midifighter("lp", 2, "mf2", 0, 0)
virtual_midifighter("lp", 2, "mf3", 4, 0)

-------------------------------------------------------------------------------
-- LAUNCHPAD PAGE 3
-------------------------------------------------------------------------------

-- ???

-------------------------------------------------------------------------------
-- LAUNCHPAD PAGE 4 - MIXER
-------------------------------------------------------------------------------

--
-- toggle modifier to switch a/b levels between normal and vumeter mode
--

toggle_modifier("lp", "vol", 4, lp_hi_yellow, lp_lo_red, "lp_vu_toggle")

--
-- eq kills for decks A+B
--

toggle("lp", "0,0", 4, lp_flash_hi_red, lp_lo_red, "traktor", "eq_low_kill_a")
toggle("lp", "0,1", 4, lp_flash_hi_red, lp_lo_red, "traktor", "eq_mid_kill_a")
toggle("lp", "0,2", 4, lp_flash_hi_red, lp_lo_red, "traktor", "eq_high_kill_a")

toggle("lp", "0,5", 4, lp_flash_hi_red, lp_lo_red, "traktor", "eq_low_kill_b")
toggle("lp", "0,6", 4, lp_flash_hi_red, lp_lo_red, "traktor", "eq_mid_kill_b")
toggle("lp", "0,7", 4, lp_flash_hi_red, lp_lo_red, "traktor", "eq_high_kill_b")

--
-- eq levels deck A
--

virtual_yfader("lp", 7, 0, 4, "traktor", "eq_low_a", 0, 7, lp_hi_orange, lp_lo_green, 0, 127, true)
virtual_yfader("lp", 7, 1, 4, "traktor", "eq_mid_a", 0, 7, lp_hi_orange, lp_lo_green, 0, 127, true)
virtual_yfader("lp", 7, 2, 4, "traktor", "eq_high_a", 0, 7, lp_hi_orange, lp_lo_green, 0, 127, true)

--
-- levels and vumeters for decks A+B
--

virtual_yfader("lp", 7, 3, 4, "traktor", "volume_fader_a", 0, 8, lp_hi_yellow, lp_lo_red, 0, 127, true, "traktor", "monitor_deck_afl_mono_a", 0, "lp_vu_toggle")
virtual_yfader("lp", 7, 4, 4, "traktor", "volume_fader_b", 0, 8, lp_hi_yellow, lp_lo_red, 0, 127, true, "traktor", "monitor_deck_afl_mono_b", 0, "lp_vu_toggle")

--
-- eq levels deck B
--

virtual_yfader("lp", 7, 5, 4, "traktor", "eq_low_b", 0, 7, lp_hi_orange, lp_lo_green, 0, 127, true)
virtual_yfader("lp", 7, 6, 4, "traktor", "eq_mid_b", 0, 7, lp_hi_orange, lp_lo_green, 0, 127, true)
virtual_yfader("lp", 7, 7, 4, "traktor", "eq_high_b", 0, 7, lp_hi_orange, lp_lo_green, 0, 127, true)


