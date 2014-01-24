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
lp_colors.jump_on = lp_hi_red
lp_colors.jump_off = lp_lo_green

-- looping
lp_colors.loop_on = lp_hi_orange
lp_colors.loop_off = lp_colors.jump_off
lp_colors.looping_on = lp_hi_orange
lp_colors.looping_off = lp_black
lp_colors.reloop_on = lp_flash_hi_orange
lp_colors.reloop_off = lp_black

-- copy/reset
lp_colors.reset_on = lp_hi_red
lp_colors.copy_on = lp_hi_green
lp_colors.copy_or_reset_off = lp_lo_yellow

-- grid cue place/delete
lp_colors.grid_place = lp_hi_orange
lp_colors.grid_delete = lp_hi_red
lp_colors.grid_off = lp_black

-- load selected
lp_colors.load_selected_on = lp_hi_green
lp_colors.load_selected_off = lp_lo_green

-------------------------------------------------------------------------------
-- Define Regions
-------------------------------------------------------------------------------

function cue_region(d, box, side, colors, shift)
	local region = d..box[0][0]
	local region_event = box[0][3]
	toggle_modifier(d, region_event, 0, colors.bottom_deck,
		colors.top_deck, region)
	set(region, 0)
	capture(d, region_event, NOFF, 0, function(d, e, v, p)
		print("RESETTING REGION", region, get_deck(region, side))
		reset_region(d, box, get_deck(region, side))
	end)

	-- hotcues - top 2 rows
	-- TODO: lo on hotcue exists, hi on hotcue press and hold
	r_hotcue(region, side, d, box[0][0], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 1)
	r_hotcue(region, side, d, box[1][0], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 2)
	r_hotcue(region, side, d, box[2][0], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 3)
	r_hotcue(region, side, d, box[3][0], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 4)
	r_hotcue(region, side, d, box[0][1], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 5)
	r_hotcue(region, side, d, box[1][1], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 6)
	r_hotcue(region, side, d, box[2][1], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 7)
	r_hotcue(region, side, d, box[3][1], 0, colors.hotcue_colors,
		colors.hotcue_off, shift, 8)

	-- deck fx enables - bottom right quadrant
	r_toggle(region, side, d, box[2][2], 0, colors.fx_on, colors.fx_off,
		"traktor", "effect_unit_1_on")
	r_toggle(region, side, d, box[3][2], 0, colors.fx_on, colors.fx_off,
		"traktor", "effect_unit_2_on")
	r_toggle(region, side, d, box[2][3], 0, colors.fx_on, colors.fx_off,
		"traktor", "effect_unit_3_on")
	r_toggle(region, side, d, box[3][3], 0, colors.fx_on, colors.fx_off,
		"traktor", "effect_unit_4_on")

	-- grid cues
	r_button_shift(region, side, d, box[0][2], 0, 
		colors.grid_place, colors.grid_delete, colors.grid_off,
		"traktor", "set_grid_marker", "delete_grid_marker", shift)

	-- load selected
	r_button(region, side, d, box[1][2], 0, colors.load_selected_on,
		colors.load_selected_off, "traktor", "load_selected")

	-- deck reset / on shift, copy focused deck TODO
	r_copy_or_reset(region, side, d, box[1][3], 0,
		colors.reset_on, colors.copy_on, colors.copy_or_reset_off, shift)

end

function nav_region(d, box, side, colors, shift)
	local region = d..box[0][0]
	local region_event = box[0][3]
	toggle_modifier(d, region_event, 0, colors.bottom_deck,
		colors.top_deck, region)
	set(region, 0)
	capture(d, region_event, NOFF, 0, function(d, e, v, p)
		print("RESETTING REGION", region, get_deck(region, side))
		reset_region(d, box, get_deck(region, side))
	end)

	--
	-- deck transport
	--
	r_toggle(region, side, d, box[3][3], 0, colors.play_on, colors.play_off,
		"traktor", "play")
	r_button(region, side, d, box[2][3], 0, colors.cue_on, colors.cue_off,
		"traktor", "cue")
	-- TODO: set as master sync on shift
	r_toggle(region, side, d, box[1][3], 0, colors.sync_on, colors.sync_off,
		"traktor", "beat_sync")

	--
	-- jumping/looping
	--

	-- toggles
	local jumping_event = box[0][2]
	local looping_event = box[1][2]
	local reloop_event = box[2][2]
	-- TODO: make loop go off when pressing jumping
	r_toggle_modifier(region, side, d, jumping_event, 0, colors.jumping_forward,
		colors.jumping_backward, "jumping", 1)
	r_toggle_modifier(region, side, d, looping_event, 0, colors.looping_on,
		colors.looping_off,	"looping", 0)
	r_toggle(region, side, d, reloop_event, 0, colors.reloop_on, colors.reloop_off,
		"traktor", "loop_active", 0)

	function jump_loops(box)
		-- track loop_size and loop_active
		-- TODO: fix async error with loop_size and loop_active
		r_capture(region, side, "traktor", "loop_size", ALL,
			function(d2, e2, v2, p2, deck)
			print("loop_size".."_"..deck, v2)
			r_set("loop_size", v2, deck)
			update_beat_leds(deck)
		end)
		r_capture(region, side, "traktor", "loop_active", ALL,
			function(d2, e2, v2, p2, deck)
			print("loop_active".."_"..deck, v2)
			if v2 == 0 then r_set("loop_active", 0, deck)
			else r_set("loop_active", 1, deck)	end
			update_beat_leds(deck)
		end)

		-- beat jump buttons
		-- TODO: jump auto-repeat
		function jump_loop(e, num_beats)
			capture(d, e, ALL, 0, function(d, e, v, p)
				local deck = get_deck(region, side)
				-- looping, so do loop
				if get("looping"..deck) == 1 then
					print("looping", deck, num_beats, v)
					-- TODO: does this need to be r_send? i do not think so
					r_send(region, side, "traktor", "loop_size_set_"..num_beats.."_"..deck,
						v, 0, deck)
				-- not looping, so do jump
				else
					-- figure out direction
					local direction = "+"
					print("jumping", deck, num_beats, v)
					if get("jumping"..deck) == 0 then
						direction = "-"
					end
					-- send beatjump event
					-- TODO: LED on beatjump press
					-- TODO: does this need to be r_send? i do not think so
					r_send(region, side, "traktor", "beatjump_"..direction..num_beats.."_"..deck,
						v, 0, deck)
				end		
			end)
		end

		-- update beat leds based on loop_size and loop_active
		function update_beat_leds(deck)
			if deck == nil then deck = get_deck(region, side) end
			r_send(region, side, d, box[0][0], colors.loop_off, 0, deck)
			r_send(region, side, d, box[1][0], colors.loop_off, 0, deck)
			r_send(region, side, d, box[0][1], colors.loop_off, 0, deck)
			r_send(region, side, d, box[1][1], colors.loop_off, 0, deck)
			if get("loop_active"..deck) == 1 then
				local loop_size = get("loop_size"..deck)
				print("UPDATING LEDS", loop_size, deck)
				if loop_size == 6 then -- 1 beat loop
					r_send(region, side, d, box[0][0], colors.loop_on, 0, deck)
				elseif loop_size == 8 then -- 4 beat loop
					r_send(region, side, d, box[1][0], colors.loop_on, 0, deck)
				elseif loop_size == 9 then -- 8 beat loop
					r_send(region, side, d, box[0][1], colors.loop_on, 0, deck)
				elseif loop_size == 10 then -- 16 beat loop
					r_send(region, side, d, box[1][1], colors.loop_on, 0, deck)
				end
			end
		end

		jump_loop(box[0][0], 1)
		jump_loop(box[1][0], 4)
		jump_loop(box[0][1], 8)
		jump_loop(box[1][1], 16)
		update_beat_leds("a")
		update_beat_leds("b")
	end
	jump_loops(get_box(box[0][0]))

	-- loop double/halve
	r_button(region, side, d, box[2][0], 0, colors.looping_on, colors.reloop_off,
		"traktor", "loop_size_inc")
	r_button(region, side, d, box[2][1], 0, colors.looping_on, colors.reloop_off,
		"traktor", "loop_size_dec")

	--
	-- eq kills
	--
	r_toggle(region, side, d, box[3][0], 0, colors.eq_kill_on, colors.eq_kill_off,
		"traktor", "eq_high_kill")
	r_toggle(region, side, d, box[3][1], 0, colors.eq_kill_on, colors.eq_kill_off,
		"traktor", "eq_mid_kill")
	r_toggle(region, side, d, box[3][2], 0, colors.eq_kill_on, colors.eq_kill_off,
		"traktor", "eq_low_kill")

end

-------------------------------------------------------------------------------
-- Init Regions
-------------------------------------------------------------------------------

-- function that returns the 4x4 box starting with top_left_corner
function get_box(top_left_corner)
	x0 = tonumber(string.match(string.match(top_left_corner, ",%d+"), "%d+"))
	y0 = tonumber(string.match(string.match(top_left_corner, "%d+,"), "%d+"))

	box = {}
	for x = 0, 3 do
		box[x] = {}
		for y = 0, 3 do
			box[x][y] = (y0 + y)..","..(x0 + x)
		end
	end

	return box
end

-- Launchpad
cue_region("lp", get_box("0,0"), "left", lp_colors, "lp_shift")
cue_region("lp", get_box("0,4"), "right", lp_colors, "lp_shift")
nav_region("lp", get_box("4,0"), "left", lp_colors, "lp_shift")
nav_region("lp", get_box("4,4"), "right", lp_colors, "lp_shift")

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
