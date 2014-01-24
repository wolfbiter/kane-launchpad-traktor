-------------------------------------------------------------------------------
-- connect devices
-------------------------------------------------------------------------------

open_midi_device("lp", "launchpad", "Launchpad", "Launchpad", 0)
open_midi_device("traktor", "traktor", "V:Traktor to MM", "V:MM to Traktor")

--
-- test launchpad leds and clear them all
--

launchpad.init("lp")
launchpad.traktor_sync("lp") -- sync any flashing leds with traktor
enable_launchpad_led_fix("lp")

--
-- midi clock
--

send("traktor", "master_tempo_clock_send", ON)

--
-- a "shift" button on all pages
--

toggle_modifier("lp", "solo", 0, lp_flash_hi_yellow, lp_lo_red, "lp_shift")
hold_modifier("lp", "arm", 0, lp_flash_hi_yellow, lp_lo_red, "lp_shift")

-------------------------------------------------------------------------------
-- Device Colors
-------------------------------------------------------------------------------

lp_colors = {} -- Launchpad
qn_colors = {} -- Quneo

-- regions
lp_colors.top_deck = lp_black
lp_colors.bottom_deck = lp_lo_amber

-- hotcues
lp_colors.hotcue_colors = { lp_hi_green, lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_orange }
lp_colors.hotcue_off = lp_lo_red

-- fx enable
lp_colors.fx_on = lp_hi_yellow
lp_colors.fx_off = lp_black

-- play
lp_colors.play_on = lp_flash_hi_green
lp_colors.play_off = lp_lo_green

-- cue
lp_colors.cue_on = lp_hi_red
lp_colors.cue_off = lp_lo_red

-- sync
lp_colors.sync_on = lp_lo_yellow
lp_colors.sync_off = lp_black

-- eq kills
lp_colors.eq_kill_on = lp_hi_red
lp_colors.eq_kill_off = lp_black

-- jumping
lp_colors.jumping_forward = lp_lo_green
lp_colors.jumping_backward = lp_lo_red

-- looping
lp_colors.loop_on = lp_hi_orange
lp_colors.looping_on = lp_hi_orange
lp_colors.looping_off = lp_black
lp_colors.reloop_on = lp_flash_hi_orange
lp_colors.reloop_off = lp_black

-- grid cue place/delete
lp_colors.grid_place = lp_hi_orange
lp_colors.grid_delete = lp_hi_red
lp_colors.grid_off = lp_black

-- load selected
lp_colors.load_selected = lp_hi_green
lp_colors.copy_focus = lp_hi_amber
lp_colors.load_off = lp_lo_green

-------------------------------------------------------------------------------
-- Define Region
-------------------------------------------------------------------------------

function setup_region(d, side, region, colors, shift)
	local deck_switch = region[0][3]
	toggle_modifier(d, deck_switch, 0, colors.bottom_deck,
		colors.top_deck, side)
	set(side, 0)
	capture(d, deck_switch, NOFF, 0, function(d, e, v, p)
		--print("RESETTING REGION", side, get_deck(side))
		reset_region(d, side, region)
	end)

	-- hotcues - top 2 rows
	-- TODO: lo on hotcue exists, hi on hotcue press and hold
	r_hotcue(side, d, region[0][0], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 1)
	r_hotcue(side, d, region[1][0], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 2)
	r_hotcue(side, d, region[2][0], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 3)
	r_hotcue(side, d, region[3][0], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 4)
	r_hotcue(side, d, region[0][1], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 5)
	r_hotcue(side, d, region[1][1], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 6)
	r_hotcue(side, d, region[2][1], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 7)
	r_hotcue(side, d, region[3][1], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 8)

	-- deck fx enables - bottom right quadrant
	r_toggle(side, d, region[2][2], 0, colors.fx_on, colors.fx_off,
		"traktor", "effect_unit_1_on")
	r_toggle(side, d, region[3][2], 0, colors.fx_on, colors.fx_off,
		"traktor", "effect_unit_2_on")
	r_toggle(side, d, region[2][3], 0, colors.fx_on, colors.fx_off,
		"traktor", "effect_unit_3_on")
	r_toggle(side, d, region[3][3], 0, colors.fx_on, colors.fx_off,
		"traktor", "effect_unit_4_on")

	-- grid cues
	r_button_shift(side, d, region[0][2], 0, 
		colors.grid_place, colors.grid_delete, colors.grid_off,
		"traktor", "set_grid_marker", "delete_grid_marker", shift)

	-- load selected / on shift, copy focus
	r_button_shift(side, d, region[1][3], 0, 
		colors.load_selected, colors.copy_focus, colors.load_off,
		"traktor", "load_selected", "copy_focus", shift)

	--
	-- deck transport
	--
	r_toggle(side, d, region[3][7], 0, colors.play_on, colors.play_off,
		"traktor", "play")
	r_button(side, d, region[2][7], 0, colors.cue_on, colors.cue_off,
		"traktor", "cue")
	-- TODO: set as master sync on shift
	r_toggle(side, d, region[1][7], 0, colors.sync_on, colors.sync_off,
		"traktor", "beat_sync")

	--
	-- jumping/looping
	--
	local function jump_loops(box)
		local jumping = "jumping"..side
		local looping = "looping"..side

		-- update beat leds based on loop_size and loop_active
		local function update_beat_leds(deck)

			-- if deck is nil, do both sides
			if deck == nil then
				deck = get_deck(side)
				update_beat_leds(get_deck2(side))
			end

			-- decide off color
			local color = colors.jumping_forward
			if get(jumping) == 0 then color = colors.jumping_backward end
			
			r_send(side, d, box[0][0], color, 0, deck)
			r_send(side, d, box[1][0], color, 0, deck)
			r_send(side, d, box[0][1], color, 0, deck)
			r_send(side, d, box[1][1], color, 0, deck)
			print("LED UPDATE", "loop active", get("loop_active"..deck))
			if get("loop_active"..deck) == 1 then
				local loop_size = get("loop_size"..deck)
				print("loop size", loop_size)
				--print("UPDATING LEDS", loop_size, deck)
				if loop_size == 6 then -- 1 beat loop
					r_send(side, d, box[0][0], colors.loop_on, 0, deck)
				elseif loop_size == 8 then -- 4 beat loop
					r_send(side, d, box[1][0], colors.loop_on, 0, deck)
				elseif loop_size == 9 then -- 8 beat loop
					r_send(side, d, box[0][1], colors.loop_on, 0, deck)
				elseif loop_size == 10 then -- 16 beat loop
					r_send(side, d, box[1][1], colors.loop_on, 0, deck)
				end
			end
		end

		-- beat jump buttons
		-- TODO: jump auto-repeat
		local function jump_loop(e, num_beats)
			capture(d, e, ALL, 0, function(d, e, v, p)
				-- if shift is held, apply to all decks
				local decks = {}
				if get(shift) > 0 then
					decks = { "a", "b", "c", "d" }
				else
					decks = { get_deck(side) }
				end
				-- looping, so do loop
				if get(looping) == 1 then
					--print("looping", deck, num_beats, v)
					send_multi("traktor", "loop_size_set_"..num_beats, v, decks)
				-- not looping, so do jump
				else
					-- figure out direction
					local direction = "+"
					if get(jumping) == 0 then	direction = "-"	end
					-- send beatjump event
					-- TODO: LED on beatjump press
					--print("jumping", deck, num_beats, v)
					send_multi("traktor", "beatjump_"..direction..num_beats, v, decks)
				end		
			end)
		end

		-- jumping toggle
		local jumping_event = box[0][2]
		toggle_modifier(d, jumping_event, 0, colors.jumping_forward,
			colors.jumping_backward, jumping)
		-- toggle looping off when jumping
		capture(d, jumping_event, NOFF, 0, function(d, e, v, p)
			set(looping, 0)
			-- update beat LEDs
			update_beat_leds()
		end)
		set(jumping, 1)
		-- looping toggle
		toggle_modifier(d, box[1][2], 0, colors.looping_on,
			colors.looping_off, looping)
		-- reloop toggle
		r_toggle(side, d, box[2][2], 0, colors.reloop_on, colors.reloop_off,
			"traktor", "loop_active", 0)

		-- track loop_size and loop_active
		-- TODO: fix async error with loop_size and loop_active
		r_capture(side, "traktor", "loop_size", ALL,
			function(d2, e2, v2, p2, deck)
			--print("loop_size".."_"..deck, v2)
			r_set("loop_size", v2, deck)
			update_beat_leds(deck)
		end)
		r_capture(side, "traktor", "loop_active", ALL,
			function(d2, e2, v2, p2, deck)
			--print("loop_active".."_"..deck, v2)
			if v2 == 0 then r_set("loop_active", 0, deck)
			else r_set("loop_active", 1, deck)	end
			update_beat_leds(deck)
		end)

		jump_loop(box[0][0], 1)
		jump_loop(box[1][0], 4)
		jump_loop(box[0][1], 8)
		jump_loop(box[1][1], 16)
		update_beat_leds()
	end
	jump_loops(get_box(region[0][4]))

	-- loop double/halve
	r_button(side, d, region[2][4], 0, colors.looping_on, colors.reloop_off,
		"traktor", "loop_size_inc")
	r_button(side, d, region[2][5], 0, colors.looping_on, colors.reloop_off,
		"traktor", "loop_size_dec")

	--
	-- eq kills
	--
	r_toggle(side, d, region[3][4], 0, colors.eq_kill_on, colors.eq_kill_off,
		"traktor", "eq_high_kill")
	r_toggle(side, d, region[3][5], 0, colors.eq_kill_on, colors.eq_kill_off,
		"traktor", "eq_mid_kill")
	r_toggle(side, d, region[3][6], 0, colors.eq_kill_on, colors.eq_kill_off,
		"traktor", "eq_low_kill")

end

-------------------------------------------------------------------------------
-- Init Regions
-------------------------------------------------------------------------------

-- function that returns the 4x4 box starting with top_left_corner
function get_box(top_left_corner)
	x0 = tonumber(string.match(string.match(top_left_corner, ",%d+"), "%d+"))
	y0 = tonumber(string.match(string.match(top_left_corner, "%d+,"), "%d+"))

	local box = {}
	for x = 0, 3 do
		box[x] = {}
		for y = 0, 3 do
			box[x][y] = (y0 + y)..","..(x0 + x)
		end
	end

	return box
end

-- function that returns the 4x8 region starting with top_left_corner
function get_region(top_left_corner)
	x0 = tonumber(string.match(string.match(top_left_corner, ",%d+"), "%d+"))
	y0 = tonumber(string.match(string.match(top_left_corner, "%d+,"), "%d+"))

	local region = {}
	for x = 0, 3 do
		region[x] = {}
		for y = 0, 7 do
			region[x][y] = (y0 + y)..","..(x0 + x)
		end
	end
	return region
end

-- Launchpad
setup_region("lp", "lp_left", get_region("0,0"), lp_colors, "lp_shift")
setup_region("lp", "lp_right", get_region("0,4"), lp_colors, "lp_shift")

-------------------------------------------------------------------------------
-- Global Functions
-------------------------------------------------------------------------------

-- waiting on adding controls:
-- 6. library stuff
-- 7. cue play

--
-- Launchpad
--

-- up/down arrows
-- TODO: autonudge tempo
tempo_or_pitch("lp", "up", 0, lp_hi_yellow, lp_hi_amber, lp_lo_yellow,
	"inc", "lp_shift")
tempo_or_pitch("lp", "down", 0, lp_hi_yellow, lp_hi_amber, lp_lo_yellow,
	"dec", "lp_shift")

-- left/right arrows
focus_switch("lp", "right", "left", 0, lp_hi_yellow, lp_lo_yellow)

-- session
toggle("lp", "session", 0, lp_hi_red, lp_black, "traktor", "record_master")

-- user1
button("lp", "user1", 0, lp_hi_green, lp_black, "traktor", "load_last_record")

-- user2
toggle("lp", "user2", 0, lp_hi_amber, lp_lo_amber, "traktor", "browser")

-- mixer
button("lp", "mixer", 0, lp_hi_green, lp_lo_red, "traktor", "search")
