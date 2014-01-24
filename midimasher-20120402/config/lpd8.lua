-------------------------------------------------------------------------------
-- connect devices
-------------------------------------------------------------------------------

open_midi_device("traktor", "traktor", "V:Traktor to MM", "V:MM to Traktor");
open_midi_device("lpd8", "lpd8", "LPD8", "LPD8", 6);

--
-- function layout:
--
-- +--------+--------+--------+--------+
-- | slicer | slicer | sync   | deck   |  
-- | on/off |loopmode|        | a/b    |  \
-- +--------+--------+----- --+--------+   * PAD mode
-- | play   | cue    | seek-  | seek+  |  /
-- |        |        |        |        |
-- +--------+--------+--------+--------+
-- | hot    | hot    | hot    | hot    |  
-- | cue 1  | cue 2  | cue 3  | cue 4  |  \
-- +--------+--------+--------+--------+   * CC mode
-- | loop   | loop-  | loop+  | shift  |  /
-- | active |        |        |        |
-- +--------+--------+--------+--------+
-- | beatjmp| beatjmp| beatmp | beatjmp|  
-- | -16    | -8     | +8     | +16    |  \
-- +--------+--------+--------+--------+   * PC mode
-- | beatjmp| beatmp | beatjmp| beatjmp|  /
-- | -4     | -2     | +2     | +4     |
-- +--------+--------+--------+--------+
--
-- * when 'deck' pad is lit, controls are for deck b
-- * when slicer is active CC mode pads become the slicer pads
-- * shift & hotcue to delete else they set/jump
-- * shift & loop+ or loop- to tempo bend
-- * pots control eq+levels for decks a+b
-- * slicer starts on the beat u activate it on
-- * nothing yet mapped on pads 0,2 and 1,3 
--
-- pad names:
--
-- +--------+--------+--------+--------+
-- |  0,0   |  0,1   |  0,2   |  0,3   |  \
-- +--------+--------+--------+--------+   * PAD mode
-- |  1,0   |  1,1   |  1,2   |  1,3   |  /
-- +--------+--------+--------+--------+
-- |  2,0   |  2,1   |  2,2   |  2,3   |  \
-- +--------+--------+--------+--------+   * CC mode
-- |  3,0   |  3,1   |  3,2   |  3,3   |  /
-- +--------+--------+--------+--------+
-- |  4,0   |  4,1   |  4,2   |  4,3   |  \
-- +--------+--------+--------+--------+   * PC mode
-- |  5,0   |  5,1   |  5,2   |  5,3   |  /
-- +--------+--------+--------+--------+
--
-- pages used:
--
-- page 0: global page, controls defined on page 0 will always be available
-- page 1: deck a
-- page 2: deck a / shift held (only cc mode)
-- page 3: deck a / slicer active
-- page 4: deck b
-- page 5: deck b / shift held (only cc mode)
-- page 6: deck b / slicer active
--

-------------------------------------------------------------------------------
-- a function to allow page changes on the lpd8
-------------------------------------------------------------------------------

function change_page()

	local page

	if deck_toggle == 0 then
		if slicer_a_active == 0 then
			if shift == 0 then
				page = 1
			else
				page = 2
			end
		else
			page = 3
		end
	else
		if slicer_b_active == 0 then
			if shift == 0 then
				page = 4
			else
				page = 5
			end
		else
			page = 6
		end
	end

	set_page("lpd8", page) -- change page and refresh leds
end

-------------------------------------------------------------------------------
-- a function to simplify assigning of hotcues
-- edit: should change code to call traktor.hotcues() instead
-------------------------------------------------------------------------------

function hotcue(d, e, p, deck, cuenum)

	local set_hotcue = "select_set_store_hotcue_"..cuenum.."_"..deck
	local delete_hotcue = "delete_hotcue_"..cuenum.."_"..deck
	local hotcue_state = "hotcue"..cuenum.."_state_"..deck

	capture(d, e, ALL, p, function(d, e, v, p)

		-- either set/store or delete a hotcue if shift is pressed

		if shift == 0 then
			send("traktor", set_hotcue, v)
		else
			send("traktor", delete_hotcue, v)
		end

		-- the lpd8 turns the led off when u release, keep it on if hotcue is set

		if v == 0 then
			if get("traktor", hotcue_state) > 0 then
				send(d, e, ON, p)
			end
		end
	end)

	-- always send traktors hotcue events back to the pad led

	pipe("traktor", hotcue_state, 0, d, e, p)
end

-------------------------------------------------------------------------------
-- define our layout
-------------------------------------------------------------------------------

--
-- deck change toggle and shift button
--

toggle_modifier("lpd8", "0,3", 0, ON, OFF, "deck_toggle", "change_page")
hold_modifier("lpd8", "3,3", {1, 2, 4, 5}, ON, OFF, "shift", "change_page")

----------------------------------------------------------
-- PAD mode
----------------------------------------------------------

--
-- slicer for deck a
--

--  sid = traktor.slicer_create("lp", grid("6,0", "7,3"), 1, "a", lp_hi_red, lp_lo_red)
--  traktor.slicer_toggle("lp", "trkon", lp_hi_yellow, lp_lo_yellow, sid, "slicer_a_status")

local id = traktor.slicer_create("lpd8", grid("2,0", "3,3"), 3, "a", ON, OFF)
traktor.slicer_toggle("lpd8", "0,0", {1, 3}, ON, OFF, id, "slicer_a_active", "change_page")
traktor.slicer_loop_toggle("lpd8", "0,1", {1, 3}, ON, OFF, id)

capture("traktor", "play_a", OFF, 0, function(d, e, v, p)
	traktor.slicer_disable(id)
	change_page()
end)

--
-- slicer for deck b
--

--local id = traktor_slicer("lpd8", grid("2,0", "3,3"), 6, "b")
local id = traktor.slicer_create("lpd8", grid("2,0", "3,3"), 6, "b", ON, OFF)
--slicer.active_toggle("lpd8", "0,0", {4, 6}, id, "slicer_b_active", "change_page")
traktor.slicer_toggle("lpd8", "0,0", {4, 6}, ON, OFF, id, "slicer_b_active", "change_page")
--slicer.loop_toggle("lpd8", "0,1", {4, 6}, id)
traktor.slicer_loop_toggle("lpd8", "0,1", {4, 6}, ON, OFF, id)

capture("traktor", "play_b", OFF, 0, function(d, e, v, p)
	--slicer.disable(id)
	traktor.slicer_disable(id)
	change_page()
end)

-- 
-- deck a play/cue/sync/seek
--

toggle("lpd8", "0,2", {1, 3}, ON, OFF, "traktor", "beat_sync_a")
toggle("lpd8", "1,0", {1, 3}, ON, OFF, "traktor", "play_a")
button("lpd8", "1,1", {1, 3}, ON, OFF, "traktor", "cue_a")
pipe("lpd8", "1,2", {1, 3}, "traktor", "seek_dec_a")
pipe("lpd8", "1,3", {1, 3}, "traktor", "seek_inc_a")

-- 
-- deck b play/cue/sync/seek
--

toggle("lpd8", "0,2", {4, 6}, ON, OFF, "traktor", "beat_sync_b")
toggle("lpd8", "1,0", {4, 6}, ON, OFF, "traktor", "play_b")
button("lpd8", "1,1", {4, 6}, ON, OFF, "traktor", "cue_b")
pipe("lpd8", "1,2", {4, 6}, "traktor", "seek_dec_b")
pipe("lpd8", "1,3", {4, 6}, "traktor", "seek_inc_b")

----------------------------------------------------------
-- CC mode (when slicer not active)
----------------------------------------------------------

-- hot cues 1-4 on top row

hotcue("lpd8", "2,0", {1, 2}, "a", 1)
hotcue("lpd8", "2,1", {1, 2}, "a", 2)
hotcue("lpd8", "2,2", {1, 2}, "a", 3)
hotcue("lpd8", "2,3", {1, 2}, "a", 4)

hotcue("lpd8", "2,0", {4, 5}, "b", 1)
hotcue("lpd8", "2,1", {4, 5}, "b", 2)
hotcue("lpd8", "2,2", {4, 5}, "b", 3)
hotcue("lpd8", "2,3", {4, 5}, "b", 4)

-- loop on/off and loop size

local modifier = lpd8_trigger("lpd8", "3,0", 1, ON, OFF, "traktor", "loop_set_a")
pipe_modifier("traktor", "loop_active_a", 0, ON, OFF, modifier)
pipe("lpd8", "3,1", 1, "traktor", "loop_size_dec_a")
pipe("lpd8", "3,2", 1, "traktor", "loop_size_inc_a")

local modifier = lpd8_trigger("lpd8", "3,0", 4, ON, OFF, "traktor", "loop_set_b")
pipe_modifier("traktor", "loop_active_b", 0, ON, OFF, modifier)
pipe("lpd8", "3,1", 4, "traktor", "loop_size_dec_b")
pipe("lpd8", "3,2", 4, "traktor", "loop_size_inc_b")

-- when shift pressed loop+/- pads become pitch bends

pipe("lpd8", "3,1", 2, "traktor", "tempo_bend_down_a")
pipe("lpd8", "3,2", 2, "traktor", "tempo_bend_up_a")
pipe("lpd8", "3,1", 5, "traktor", "tempo_bend_down_b")
pipe("lpd8", "3,2", 5, "traktor", "tempo_bend_up_b")

----------------------------------------------------------
-- PC mode 
----------------------------------------------------------

pipe("lpd8", "4,0", {1, 3}, "traktor", "beatjump_-16_a")
pipe("lpd8", "4,1", {1, 3}, "traktor", "beatjump_-8_a")
pipe("lpd8", "4,2", {1, 3}, "traktor", "beatjump_+8_a")
pipe("lpd8", "4,3", {1, 3}, "traktor", "beatjump_+16_a")

pipe("lpd8", "5,0", {1, 3}, "traktor", "beatjump_-4_a")
pipe("lpd8", "5,1", {1, 3}, "traktor", "beatjump_-2_a")
pipe("lpd8", "5,2", {1, 3}, "traktor", "beatjump_+2_a")
pipe("lpd8", "5,3", {1, 3}, "traktor", "beatjump_+4_a")

pipe("lpd8", "4,0", {4, 6}, "traktor", "beatjump_-16_b")
pipe("lpd8", "4,1", {4, 6}, "traktor", "beatjump_-8_b")
pipe("lpd8", "4,2", {4, 6}, "traktor", "beatjump_+8_b")
pipe("lpd8", "4,3", {4, 6}, "traktor", "beatjump_+16_b")

pipe("lpd8", "5,0", {4, 6}, "traktor", "beatjump_-4_b")
pipe("lpd8", "5,1", {4, 6}, "traktor", "beatjump_-2_b")
pipe("lpd8", "5,2", {4, 6}, "traktor", "beatjump_+2_b")
pipe("lpd8", "5,3", {4, 6}, "traktor", "beatjump_+4_b")

----------------------------------------------------------
-- Pots
----------------------------------------------------------

pipe("lpd8", "fader1", 0, "traktor", "eq_low_a")
pipe("lpd8", "fader2", 0, "traktor", "eq_mid_a")
pipe("lpd8", "fader3", 0, "traktor", "eq_high_a")
pipe("lpd8", "fader4", 0, "traktor", "volume_fader_a")
pipe("lpd8", "fader5", 0, "traktor", "eq_low_b")
pipe("lpd8", "fader6", 0, "traktor", "eq_mid_b")
pipe("lpd8", "fader7", 0, "traktor", "eq_high_b")
pipe("lpd8", "fader8", 0, "traktor", "volume_fader_b")















