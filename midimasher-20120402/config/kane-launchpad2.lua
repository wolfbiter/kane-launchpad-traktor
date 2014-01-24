-------------------------------------------------------------------------------
-- Utility
-------------------------------------------------------------------------------

-- make a toggle and hold out of given shift and events
function make_shift(d, e1, e2, p, on_color, off_color, shift)
	toggle_modifier(d, e1, p, on_color, off_color, shift)
	hold_modifier(d, e2, p, on_color, off_color, shift)
end

-- send message to d from all decks in table decks
function send_multi(d, e, v, decks)
	--print("SEND MULTI")
	for i, deck in ipairs(decks) do
		--print(e.."_"..deck)
		send(d, e.."_"..deck, v)
	end
end

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

-- multi-mode toggle button
function mode_button(d, e, name, colors, max_val, cb)
	-- init
	set(name, 0)
	-- capture
	capture(d, e, NOFF, 0, function(d, e, v, p)
		-- update toggle
		local val = (get(name) + 1) % max_val

		set(name, val)
		-- update led
		send(d, e, colors[val + 1])
    -- call callback
    if cb ~= nil then cb(d, e, v, p) end
	end)
end

-- adds 2nd color to preexisting shift
function button_shift2(d1, e1, p1, no_shift_color, shift_color, off_color, d2, e2, e2s, shift, p2, cb, cb1, cb2)

	if p2 == nil then p2 = 0 end

	capture(d1, e1, ALL, p1, function(d, e, v, p)

		-- light appropriate LED color
		if v > 0 then
			if get(shift) > 0 then
				send(d1, e1, shift_color, p1)
			else
				send(d1, e1, no_shift_color, p1)
			end
		else
			send(d1, e1, off_color, p1)
		end

		-- handle send
		local called = ""
		if get(shift) > 0 then
			if cb2 ~= nil then
				v = call(cb2, d, e, v, p)
			end
			called = e2s
			send(d2, e2s, v, p2)
		else
			if cb1 ~= nil then
				v = call(cb2, d, e, v, p)
			end
			called = e2
			send(d2, e2, v, p2)
		end

		if cb ~= nil then
			call(cb, d, e, v, p, string.sub(called, 1, -3))
		end

	end)

	-- send initial LED message
	send(d1, e1, off_color, p1)
end

-- toggle button with no shift, button on shift
function toggle_button_shift(d1, e1, p1, no_shift_color, shift_color, off_color, d2, e2, e2s, shift, p2, cb, cb1, cb2)
	if p2 == nil then p2 = 0 end

	local state = 0
	local function assert_led()
		-- if state on, light LED
		if state == 1 then
			send(d1, e1, no_shift_color, p1)
		else
			send(d1, e1, off_color, p1)
		end
	end

	-- setup event capture for leds
	capture(d2, e2, ALL, 0,
		function(d2, e2, v2, p2)
			-- update state and assert LED
			if (v2 == 127) then	state = 1
			else state = 0
			end
			assert_led()
		end)

	capture(d1, e1, ALL, p1, function(d, e, v, p)
		local called = ""

		-- button
		if get(shift) > 0 then

			-- light LED with button press
			if v > 0 then
				send(d1, e1, shift_color, p1)
			elseif v == 0 then
				assert_led()
			end	

			-- handle press
			if cb2 ~= nil then
				v = call(cb2, d, e, v, p)
			end
			called = e2s
			send(d2, e2s, v, p2)

		-- toggle
		elseif v > 0 then
			-- update state
			state = (state + 1) % 2
			if cb1 ~= nil then
				v = call(cb2, d, e, v, p)
			end
			called = e2
			v = v * state 
			--print("sending", d2, e2, v, p2)
			send(d2, e2, v, p2)
		else assert_led()
		end

		if cb ~= nil then
			call(cb, d, e, v, p, string.sub(called, 1, -3), state)
		end
	end)

	-- send initial LED message
	send(d1, e1, off_color, p1)
end
	
-- TODO: turn into button_shift2
function tempo_or_pitch(d1, e1, p1, no_shift_color, shift_color, off_color, direction, shift, p2, cb, cb1, cb2)

	if p2 == nil then p2 = 0 end

	-- capture button presses
	capture(d1, e1, ALL, p1, function(d, e, v, p)

		-- light appropriate LED color
		if v > 0 then
			if get(shift) > 0 then
				send(d1, e1, shift_color, p1)
			else
				send(d1, e1, no_shift_color, p1)
			end
		else
			send(d1, e1, off_color, p1)
		end

		-- handle send
		if get(shift) > 0 then
			if cb2 ~= nil then
				v = call(cb2, d, e, v, p)
			end
			send("traktor", "pitch_"..direction.."_focus", v, p2)
		else
			if cb1 ~= nil then
				v = call(cb2, d, e, v, p)
			end
			if (v > 0) then
				-- if it's already on, this is a cancel
				if autonudge.on then
					stop_autonudge()
				-- otherwise, start the autonudge
				else
					start_autonudge(d, e, v, p, direction)
				end
			end
		end
		if cb ~= nil then
			call(cb, d, e, v, p)
		end

	end)

	-- capture heartbeat
	--capture("traktor", "clock_send_master", ALL, 0, function(d, e, v, p, deck)
	--	print("HEARTBEAT:", v)
	--end)

	-- send initial LED message
	send(d1, e1, off_color, p1)
end

-- TODO: move to appropriate spot
function focus_switch(d, e1, e2, p, on_color, off_color)

	function set_capture(e, direction)
		capture(d, e, ALL, p, function(d, e, v, p)

			-- light appropriate LED color
			if v > 0 then
				send(d, e, on_color, p)
			else
				send(d, e, off_color, p)
			end

			-- handle send
			send("traktor", direction.."_focus", v, p)

		end)
	end

	-- init captures
	set_capture(e1, "inc")
	set_capture(e2, "dec")

	-- send initial LED messages
	send(d, e1, off_color, p)
	send(d, e2, off_color, p)
end

-------------------------------------------------------------------------------
-- Connect Devices
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
-- autonudge
--
-- TODO: led when autonudging
autonudge = {	['on'] = false, }

function stop_autonudge()
  --print("STOPPING AUTONUDGE")
  -- unpress tempo inc button
  send("traktor", "tempo_"..autonudge['direction'].."_master", 0, 0)
  autonudge.on = false
end

function start_autonudge(d, e, v, p, direction)
  --print("STARTING AUTONUDGE", d, e, v, p, direction)
  autonudge = {
    ['on'] = true,
    ['d'] = d,
    ['e'] = e,
    ['v'] = v,
    ['p'] = p,
    ['direction'] = direction,
  }
end

capture("traktor", "tempo_fader_focus", NOFF, 0, function(d, e, v, p)
	if autonudge.on and (v == 63) then
		stop_autonudge()
	end
end)

-- 
-- autoloop
--
-- TODO: led when autolooping, function for start/cancel
autoloop = {	['on'] = false, }
autoloops = {
	[1] = { [8] = true, [12] = true, ['last'] = 16, },
	[2] = { [8] = true, [12] = true, ['last'] = 16, },
	[4] = { [16] = true, [24] = true, [28] = true, ['last'] = 32, },
	[8] = { [16] = true, [24] = true, [28] = true, ['last'] = 32, },
}

--
-- autofade
--
autofade = {
  ['on'] = false,
  ['off_decks'] = {},
  ['on_decks'] = {},
  ['curr_beat'] = 0,
  ['length'] = 32,
}

function stop_autofade()
  print("STOPPING autofade")
  autofade = {
    ['on'] = false,
    ['off_decks'] = {},
    ['on_decks'] = {},
    ['curr_beat'] = 0,
    ['length'] = 32,
  }
  set("autofade_mode", 0)
  send("lp", "mixer", lp_black)
end

function start_autofade()
  print("STARTING autofade")
  print(unpack(autofade.off_decks))
  print(unpack(autofade.on_decks))
  autofade.on = true
end

--
-- global beat monitors
--
capture("traktor", "beat_monitor_focus", NOFF, 0, function(d, e, v, p)
	
	if autoloop.on then
		-- update curr_beat
		local curr_beat = autoloop['curr_beat'] + 1
		autoloop['curr_beat'] = curr_beat
		print("curr_beat", curr_beat)

		-- figure out if we should loop_dec
		if autoloops[autoloop['start_loop']][curr_beat] then
			print("SENDING AUTOLOOP")
			send("traktor", "loop_size_dec_"..autoloop['deck'], 127, 0)
		elseif curr_beat == autoloop['end_beat'] then
			print("ENDING AUTOLOOP")
			autoloop.on = false
		end
		
	end

	if autonudge.on then
		--print("autonudge", "tempo_"..autonudge['direction'].."_master")
		send("traktor", "tempo_"..autonudge['direction'].."_master", 127, 0)
	end

  if autofade.on then 
    -- update curr_beat
    local curr_beat = autofade['curr_beat'] + 1
    autofade['curr_beat'] = curr_beat
    print("curr_beat", curr_beat)
    local on_val = math.ceil((curr_beat / autofade.length) * 63)
    local off_val = 63 - on_val

    -- handle off decks
    for i, deck in ipairs(autofade.off_decks) do
      send("traktor", "eq_low_"..deck, off_val, 0)
    end
    
    -- handle on decks
    for i, deck in ipairs(autofade.on_decks) do
      send("traktor", "eq_low_"..deck, on_val, 0)
    end

    -- stop autofade when finished
    if curr_beat == autofade.length then
      stop_autofade()
    end
  end


end)

--[[
capture("traktor", "beat_phase_monitor_focus", ALL, 0, function(d, e, v, p)

  if autofade.on then 
    print("autofade on", d, e, v, p)
    -- handle off decks
    for i, deck in ipairs(autofade.off_decks) do
      send("traktor", "eq_low_"..deck, 0, 0)
      -- do stuff
    end
    -- handle on decks
    for i, deck in ipairs(autofade.on_decks) do
      -- do stuff
    end
  end

end)
]]

-------------------------------------------------------------------------------
-- Device Colors
-------------------------------------------------------------------------------

lp_colors = {} -- Launchpad
qn_colors = {} -- Quneo

-- shifts
lp_colors.all_shift_on = lp_flash_hi_yellow
lp_colors.all_shift_off = lp_lo_orange
lp_colors.vert_shift_on = lp_flash_hi_yellow
lp_colors.vert_shift_off = lp_lo_green
lp_colors.horiz_shift_on = lp_flash_hi_yellow
lp_colors.horiz_shift_off = lp_lo_yellow
lp_colors.shift_on = lp_flash_hi_yellow
lp_colors.shift_off = lp_lo_red

-- regions
lp_colors.top_deck = lp_black
lp_colors.bottom_deck = lp_lo_amber

-- hotcues
lp_colors.hotcue_colors = { lp_hi_green, lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_orange }
lp_colors.hotcue_off = lp_lo_red

-- fx enable
lp_colors.fx_on = lp_hi_yellow
lp_colors.fx_off = lp_black

-- duplicate deck
lp_colors.duplicate_deck = lp_hi_orange

-- play
lp_colors.play_on = lp_flash_hi_green
lp_colors.play_off = lp_lo_green

-- cue
lp_colors.cue_on = lp_hi_red
lp_colors.cue_off = lp_lo_red

-- sync
lp_colors.sync_master = lp_hi_yellow
lp_colors.sync_on = lp_lo_yellow
lp_colors.sync_off = lp_black

-- monitor cue
lp_colors.monitor_cue_on = lp_hi_amber
lp_colors.monitor_cue_off = lp_black

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
lp_colors.grid_place = lp_hi_yellow
lp_colors.grid_delete = lp_hi_red
lp_colors.grid_off = lp_lo_yellow

-- load selected
lp_colors.load_selected = lp_hi_green
lp_colors.copy_focus = lp_hi_amber
lp_colors.load_off = lp_lo_green

-- recording
lp_colors.record_on = lp_hi_red
lp_colors.record_off = lp_lo_green
lp_colors.load_last_record = lp_hi_green

-- browsing
lp_colors.browser_on = lp_hi_amber
lp_colors.browser_off = lp_lo_amber

-- tempo and pitch
lp_colors.tempo = lp_hi_yellow
lp_colors.pitch = lp_hi_amber
lp_colors.tempo_or_pitch_off = lp_lo_yellow

-- focus switch
lp_colors.focus_on = lp_hi_yellow
lp_colors.focus_off = lp_lo_yellow

-- cueing modes
lp_colors.cueing = { lp_black, lp_lo_green, lp_lo_red, lp_lo_orange }

-- autofade
lp_colors.autofade = { lp_black, lp_hi_red, lp_hi_green, lp_hi_yellow, }

-- midi clock
lp_colors.clock_on = lp_lo_red
lp_colors.clock_off = lp_flash_hi_yellow
lp_colors.clock_sync = lp_hi_orange

-------------------------------------------------------------------------------
-- Init Devices
-------------------------------------------------------------------------------

function init_device(d, colors, events)
	-- each side controls 2 decks. left is A/C, right is B/D
  local cueing_mode = d.."_cueing"
	local curr_deck = {}
	curr_deck["left"] = 0
	curr_deck["right"] = 0

	-- a "shift" button on all pages
	local shift = d.."_shift"
	make_shift(d, events['shift_toggle'], events['shift_hold'],
		0, colors.shift_on, colors.shift_off, shift)

	-- on vert shift, activate button for both decks on this side
	local vert_shift = d.."_vert_shift"
	make_shift(d, events['vert_shift_toggle'], events['vert_shift_hold'],
		0, colors.vert_shift_on, colors.vert_shift_off, vert_shift)

	-- on horiz shift, activate button for both decks on this side
	local horiz_shift = d.."horiz_shift"
	make_shift(d, events['horiz_shift_toggle'], events['horiz_shift_hold'],
		0, colors.horiz_shift_on, colors.horiz_shift_off, horiz_shift)

	-- on all shift, activate button for all decks
	local all_shift = d.."_all_shift"
	make_shift(d, events['all_shift_toggle'], events['all_shift_hold'],
		0, colors.all_shift_on, colors.all_shift_off, all_shift)

	local function init_layer(side, layer_grid, region)

		--
		-- deck toggle
		--
		-- figure out which decks this side uses
		local decks = {}
		if side == "left" then 
			decks[0] = "a"; decks[1] = "c"; decks[2] = "b"; decks[3] = "d";
		elseif side == "right" then
			decks[0] = "b"; decks[1] = "d"; decks[2] = "a"; decks[3] = "c"; 
		else
			print("ERROR: unknown side given to init_layer", side)
			return 
		end
		-- make toggle button
		local layer = d.."_"..side
		-- "8,8" is a fake button to make it so layer has 2 pages
		toggled_layers(d, 0, layer, layer_grid, { region[0][7], "8,8" },
			colors.top_deck, colors.bottom_deck,
			function(d, e, v, p, is_new_page, parent)
		  -- update deck
			curr_deck[side] = (curr_deck[side] + 1) % 2
			-- set led
			local color = colors.top_deck
			if (curr_deck[side] == 1) then color = colors.bottom_deck end
			--print("prev page", curr_deck[side])
			--print(d, e, v, p, is_new_page, parent, color)
			send(parent, e, color)
			-- set page
		  set_page(d, curr_deck[side] + 1, parent)
		end)

		--
		-- dbl functions (on shift, press for dbl/all decks)
		--
		local function get_dbl_cb(d2, e2, deck, type)

			-- determine deck-specific stuff
			local multi_decks = {}
			local vert_event = ""
			local horiz_event = ""
			if (deck == "a") or (deck == "b") then
				multi_decks = { decks[1], decks[2], decks[3] }
				vert_event = "_"..decks[1]
				horiz_event = "_"..decks[2]
			elseif (deck == "c") or (deck == "d") then
				multi_decks = { decks[0], decks[2], decks[3] }
				vert_event = "_"..decks[0]
				horiz_event = "_"..decks[3]
			else
				print("ERROR: unknown deck given to get_dbl_cb", deck)
				return
			end

      -- return appropriate callback
      if type == nil then
        return function(d, e, v, p)
          if get(all_shift) > 0 then
            send_multi(d2, e2, v, multi_decks)
          else
            if get(vert_shift) > 0 then
              send(d2, e2..vert_event, v)
            end
            if get(horiz_shift) > 0 then
              send(d2, e2..horiz_event, v)
            end
          end
        end
      else
        return function(d, e, v, p, called)
          if get(all_shift) > 0 then
            send_multi("traktor", called, v, multi_decks)
          else
            if get(vert_shift) > 0 then
              send("traktor", called..vert_event, v)
            end
            if get(horiz_shift) > 0 then
              send("traktor", called..horiz_event, v)
            end
          end
        end
      end
    end

		local function dbl_toggle(e1, on_color, off_color, d2, e2)
			local e20 = e2.."_"..decks[0]
			local e21 = e2.."_"..decks[1]
			toggle(layer, e1, 1, on_color, off_color, d2, e20, 0,
				get_dbl_cb(d2, e2, decks[0]))
			toggle(layer, e1, 2, on_color, off_color, d2, e21, 0,
				get_dbl_cb(d2, e2, decks[1]))
		end

		local function dbl_button(e1, on_color, off_color, d2, e2)
			local e20 = e2.."_"..decks[0]
			local e21 = e2.."_"..decks[1]
			button(layer, e1, 1, on_color, off_color, d2, e20, 0,
				get_dbl_cb(d2, e2, decks[0]))
			button(layer, e1, 2, on_color, off_color, d2, e21, 0,
				get_dbl_cb(d2, e2, decks[1]))
		end

		local function dbl_button_shift2(e1, shift_off_color, shift_on_color, off_color, d2, e2off, e2on, shift)
			local e20off = e2off.."_"..decks[0]
			local e21off = e2off.."_"..decks[1]
			local e20on = e2on.."_"..decks[0]
			local e21on = e2on.."_"..decks[1]
			button_shift2(layer, e1, 1, shift_off_color, shift_on_color,
				off_color, d2, e20off, e20on, shift, 0,
				get_dbl_cb(d2, e1, decks[0], true))
			button_shift2(layer, e1, 2, shift_off_color, shift_on_color,
				off_color, d2, e21off, e21on, shift, 0,
				get_dbl_cb(d2, e1, decks[1], true))
		end

		local function dbl_toggle_button_shift(e1, shift_off_color, shift_on_color, off_color, d2, e2off, e2on, shift)
			local e20off = e2off.."_"..decks[0]
			local e21off = e2off.."_"..decks[1]
			local e20on = e2on.."_"..decks[0]
			local e21on = e2on.."_"..decks[1]
			toggle_button_shift(layer, e1, 1, shift_off_color, shift_on_color,
				off_color, d2, e20off, e20on, shift, 0,
				get_dbl_cb(d2, e1, decks[0], true))
			toggle_button_shift(layer, e1, 2, shift_off_color, shift_on_color,
				off_color, d2, e21off, e21on, shift, 0,
				get_dbl_cb(d2, e1, decks[1], true))
		end

		local function dbl_hotcue(d, e, p, on_colors, off_color, shift, deck, cuenum)
			--print(d, e, p, on_colors, off_color, shift, cuenum)
			traktor.hotcue(d, e, 1, on_colors, off_color,
				shift, decks[0], cuenum,
				get_dbl_cb(d2, e, decks[0], true))
			traktor.hotcue(d, e, 2, on_colors, off_color,
				shift, decks[1], cuenum,
				get_dbl_cb(d2, e, decks[1], true))
		end

		local function dbl_capture(d2, e2, v2, handler, d1, e1, off_color)
			-- capture both decks; give deck as addt'l arg to handler
			capture(d2, e2.."_"..decks[0], v2, 0, function(d, e, v, p)
				handler(d1, e1, v, 1, decks[0])
			end)	
			capture(d2, e2.."_"..decks[1], v2, 0, function(d, e, v, p)
				handler(d1, e1, v, 2, decks[1])
			end)

			-- send initial d1 (out) message
			if (d1 ~= nil and e1 ~= nil and off_color ~= nil) then
				send(d1, e1, off_color, 0)
			end
		end

		--
		-- hotcues
		--
		traktor.hotcues(layer, grid(region[0][0], region[3][1]), 1,
			colors.hotcue_colors, colors.hotcue_off,
			shift, decks[0], 1, dbl_hotcue)

		--
		-- deck fx enables
		--
		dbl_toggle_button_shift(region[2][2],
			colors.fx_on, colors.duplicate_deck, colors.fx_off,
			"traktor", "effect_unit_1_on", "duplicate_deck_a", shift, 0)
		dbl_toggle_button_shift(region[3][2],
			colors.fx_on, colors.duplicate_deck, colors.fx_off,
			"traktor", "effect_unit_2_on", "duplicate_deck_b", shift, 0)
		dbl_toggle_button_shift(region[2][3],
			colors.fx_on, colors.duplicate_deck, colors.fx_off,
			"traktor", "effect_unit_3_on", "duplicate_deck_c", shift, 0)
		dbl_toggle_button_shift(region[3][3],
			colors.fx_on, colors.duplicate_deck, colors.fx_off,
			"traktor", "effect_unit_4_on", "duplicate_deck_d", shift, 0)

    --
    -- deck autofade
    --
    capture(layer, region[1][2], NOFF, 1, function(d, e, v, p)
      local mode = get("autofade_mode")
      -- if in mode 1, set this as an off deck
      if mode == 1 then
        print("adding deck to autofade_off", decks[0])
        table.insert(autofade.off_decks, decks[0])
        send("traktor", "eq_low_"..decks[0], 63)
      -- if in mode 2, set this as an on deck
      elseif mode == 2 then
        print("adding deck to autofade_on", decks[0])
        table.insert(autofade.on_decks, decks[0])
        send("traktor", "eq_low_"..decks[0], 0)
      end
    end)
    capture(layer, region[1][2], NOFF, 2, function(d, e, v, p)
      local mode = get("autofade_mode")
      -- if in mode 1, set this as an off deck
      if mode == 1 then
        print("adding deck to autofade_off", decks[1])
        table.insert(autofade.off_decks, decks[1])
        send("traktor", "eq_low_"..decks[1], 63)
      -- if in mode 2, set this as an on deck
      elseif mode == 2 then
        print("adding deck to autofade_on", decks[1])
        table.insert(autofade.on_decks, decks[1])
        send("traktor", "eq_low_"..decks[1], 0)
      end
    end)

		--
		-- deck monitor
		--
		dbl_toggle(region[1][3], colors.monitor_cue_on,
			colors.monitor_cue_off, "traktor", "monitor_cue")

		--
		-- grid cue place / on shift, grid cue delete
		--
		dbl_button_shift2(region[0][2],
			colors.grid_place, colors.grid_delete, colors.grid_off,
			"traktor", "set_grid_marker", "delete_grid_marker", shift)

		--
		-- load selected track
		--
		dbl_button(region[0][3], colors.load_selected, colors.load_off,
			"traktor", "load_selected")

		--
		-- deck transport
		--
		dbl_toggle(region[3][7], colors.play_on, colors.play_off,
			"traktor", "play")
		dbl_button(region[2][7], colors.cue_on, colors.cue_off,
			"traktor", "cue")

		--
		-- sync / on shift, set as tempo master
		--
		dbl_toggle_button_shift(region[1][7],
			colors.sync_on, colors.sync_master, colors.sync_off,
			"traktor", "beat_sync", "tempo_master", shift)

		--
		-- eq kills
		--
		dbl_toggle(region[3][4], colors.eq_kill_on, colors.eq_kill_off,
			"traktor", "eq_high_kill")
		dbl_toggle(region[3][5], colors.eq_kill_on, colors.eq_kill_off,
			"traktor", "eq_mid_kill")
		dbl_toggle(region[3][6], colors.eq_kill_on, colors.eq_kill_off,
			"traktor", "eq_low_kill")

		--
		-- loop doubling/halving, active/inactive
		--
		dbl_button(region[2][4], colors.looping_on, colors.reloop_off,
			"traktor", "loop_size_inc")
		dbl_button(region[2][5], colors.looping_on, colors.reloop_off,
			"traktor", "loop_size_dec")
		dbl_toggle(region[2][6], colors.reloop_on, colors.reloop_off,
			"traktor", "loop_active")

		--
		-- jumping/looping
		--
		local function jump_loops(box)
			local jumping = "jumping_"..layer
			local looping = "looping_"..layer

			-- update beat leds based on loop_size and loop_active
			local function update_beat_leds(p)

				-- if p is nil, do both of this layer's pages
				if p == nil then
					p = 2
					update_beat_leds(1)
				end
				local deck = decks[p - 1]
				local loop_active = "loop_active_"..deck
				local loop_size = "loop_size_"..deck

				-- decide off color
				local color = colors.jumping_forward
				if get(jumping) == 0 then color = colors.jumping_backward end
				
				send(layer, box[0][0], color, p)
				send(layer, box[1][0], color, p)
				send(layer, box[0][1], color, p)
				send(layer, box[1][1], color, p)
				--print("LED UPDATE", "loop active", get(loop_active))
				if get(loop_active) == 1 then
					local size = get(loop_size)
					if size == 6 then -- 1 beat loop
						send(layer, box[0][0], colors.loop_on, p)
					elseif size == 8 then -- 4 beat loop
						send(layer, box[1][0], colors.loop_on, p)
					elseif size == 9 then -- 8 beat loop
						send(layer, box[0][1], colors.loop_on, p)
					elseif size == 10 then -- 16 beat loop
						send(layer, box[1][1], colors.loop_on, p)
					end
				end
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

			-- track loop_size and loop_active
			-- TODO: fix async error with loop_size and loop_active
			dbl_capture("traktor", "loop_size", ALL,
				function(d, e, v, p, deck)
				--print("loop_size".."_"..deck, v)
				set("loop_size_"..deck, v)
				update_beat_leds(p)
			end)
			dbl_capture("traktor", "loop_active", ALL,
				function(d, e, v, p, deck)
				--print("loop_active".."_"..deck, v)
				if v == 0 then set("loop_active_"..deck, 0)
				else set("loop_active_"..deck, 1)	end
				update_beat_leds(p)
			end)

			-- beat jump buttons
			-- TODO: jump auto-repeat
			-- TODO: LED on beatjump press
			local function jump_loop(e, p, num_beats)
				local deck = decks[p - 1]
				local cb = get_dbl_cb("traktor", e, deck, true)

				local done_event = {}
				local function do_event(event, d, e, v, p)
					done_event = { event, d, e, 0, p }
					send("traktor", event.."_"..deck, v, 0)
					call(cb, d, e, v, p, event)
				end

				capture(layer, e, ALL, p, function(d, e, v, p)

					-- streamline off functionality
					if v == OFF then
						return do_event(unpack(done_event))
					end

					--
					-- looping
					--
					if get(looping) == 1 then

						-- if shift, this is an autoloop
						if get(shift) > 0 then
							-- if it's already on, this is a cancel
							if autoloop.on then
								print("CANCELLING AUTOLOOP")
								autoloop.on = false
							-- otherwise, halve and start the autoloop
							else
								do_event("loop_size_dec", d, e, v, p)
								autoloop = {
									['on'] = true,
									['deck'] = deck,
									['start_loop'] = num_beats,
									['curr_beat'] = -1,
									['end_beat'] = autoloops[num_beats]['last'],
								}
							end

						-- else do regular loop
						else
							do_event("loop_size_set_"..num_beats, d, e, v, p)
						end

					--
					-- jumping
					-- 
					else
						-- if shift is held, set _num_beats = 32
						local _num_beats = num_beats
						if get(shift) > 0 then
							_num_beats = 32
						end
						-- figure out direction
						local direction = "+"
						if get(jumping) == 0 then	direction = "-"	end
						-- send beatjump event
						--print("jumping", _num_beats)
						do_event("beatjump_"..direction.._num_beats, d, e, v, p)
					end		

				end)
			end

			jump_loop(box[0][0], 1, 1)
			jump_loop(box[1][0], 1, 4)
			jump_loop(box[0][1], 1, 8)
			jump_loop(box[1][1], 1, 16)

			jump_loop(box[0][0], 2, 1)
			jump_loop(box[1][0], 2, 4)
			jump_loop(box[0][1], 2, 8)
			jump_loop(box[1][1], 2, 16)

			update_beat_leds()
		end

		jump_loops(get_box(region[0][4]))
	end

	--
	-- globals
	--

	-- recording
	toggle_button_shift(d, events['record'], 0,
		colors.record_on, colors.load_last_record, colors.record_off,
		"traktor", "record_master", "load_last_record", shift, 0)

	-- cueing
	--mode_button(d, events['cueing'], cueing_mode, colors.cueing, 4)

	-- midi clock
	toggle_button_shift(d, events['clock'], 0,
		colors.clock_on, colors.clock_sync, colors.clock_off,
		"traktor", "master_clock_tempo_mode", "master_tempo_clock_sync_midi",
		shift, 0, function(d, e, v, p, called, state)
		-- also set clock as master on state change
		if state == 0 then
			send("traktor", "tempo_master_clock", 127, 0)
		end
		end)

  -- autofade
  mode_button(d, events['autofade'], "autofade_mode", colors.autofade, 4, function(d, e, v, p)
    -- start autofade if went to mode 3
    local mode = get("autofade_mode")
    if mode == 3 then
      start_autofade()
    -- cancel autofade if went to mode 0
    elseif mode == 0 then
      print("CANCELLING AUTOFADE")
      stop_autofade()
    end
  end)

	-- others
	toggle(d, events['browser'], 0,
		colors.browser_on, colors.browser_off, "traktor", "browser")
	tempo_or_pitch(d, events['up'], 0,
		colors.tempo, colors.pitch, colors.tempo_or_pitch_off,
		"inc", shift)
	tempo_or_pitch(d, events['down'], 0,
		colors.tempo, colors.pitch, colors.tempo_or_pitch_off,
		"dec", shift)
	focus_switch(d, events['right'], events['left'], 0,
		colors.focus_on, colors.focus_off)

	-- init layers
	init_layer("left", grid("0,0", "7,3"), get_region("0,0"))
	init_layer("right", grid("0,4", "7,7"), get_region("0,4"))
end

-- init devices
init_device("lp", lp_colors, {

	-- shifts
	['all_shift_toggle'] = 'vol',
	['all_shift_hold'] = 'pan',
	['vert_shift_toggle'] = 'snda',
	['vert_shift_hold'] = 'sndb',
	['horiz_shift_toggle'] = 'stop',
	['horiz_shift_hold'] = 'trkon',
	['shift_toggle'] = 'solo',
	['shift_hold'] = 'arm',

	-- globals
	['record'] = 'session',
	['clock'] = 'user1',
	['browser'] = 'user2',
	['autofade'] = 'mixer',
	['up'] = 'up',
	['down'] = 'down',
	['left'] = 'left',
	['right'] = 'right',

})
