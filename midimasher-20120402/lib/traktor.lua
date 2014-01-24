---0
--
-- all these functions assume you have connected traktor and you have named it C<"traktor">
--
--  open_midi_device("traktor", "traktor", "Traktor to MM", "MM to Traktor")
--
---

---------------------------------------------------------------------------------
-- traktor table
---------------------------------------------------------------------------------

traktor = {}
traktor.slicer = {}
traktor.fx = {}
traktor.loop_size_a = 1
traktor.loop_size_b = 1
traktor.loop_active_a = 0
traktor.loop_active_b = 0

---------------------------------------------------------------------------------
-- beatjumps used by the slicer
---------------------------------------------------------------------------------

traktor.beatjumps = {
	["jump-8"] = { "beatjump_-8_" },
	["jump-7.5"] = { "beatjump_-4_", "beatjump_-2_", "beatjump_-1_", "beatjump_-/2_" },
	["jump-7"] = { "beatjump_-4_", "beatjump_-2_", "beatjump_-1_" },
	["jump-6.5"] = { "beatjump_-4_", "beatjump_-2_", "beatjump_-/2_" },
	["jump-6"] = { "beatjump_-4_", "beatjump_-2_" },
	["jump-5.5"] = { "beatjump_-4_", "beatjump_-1_", "beatjump_-/2_" },
	["jump-5"] = { "beatjump_-4_", "beatjump_-1_" },
	["jump-4.5"] = { "beatjump_-4_", "beatjump_-/2_" },
	["jump-4"] = { "beatjump_-4_" },
	["jump-3.5"] = { "beatjump_-2_", "beatjump_-1_", "beatjump_-/2_" },
	["jump-3"] = { "beatjump_-2_", "beatjump_-1_" },
	["jump-2.5"] = { "beatjump_-2_", "beatjump_-/2_" },
	["jump-2"] = { "beatjump_-2_" },
	["jump-1.5"] = { "beatjump_-1_", "beatjump_-/2_" },
	["jump-1"] = { "beatjump_-1_" },
	["jump-0.5"] = { "beatjump_-/2_" },
	["jump0.5"] = { "beatjump_+/2_" },
	["jump1"] = { "beatjump_+1_" },
	["jump1.5"] = { "beatjump_+1_", "beatjump_+/2_" },
	["jump2"] = { "beatjump_+2_" },
	["jump2.5"] = { "beatjump_+2_", "beatjump_+/2_" },
	["jump3"] = { "beatjump_+2_", "beatjump_+1_" },
	["jump3.5"] = { "beatjump_+2_", "beatjump_+1_", "beatjump_+/2_" },
	["jump4"] = { "beatjump_+4_" },
	["jump4.5"] = { "beatjump_+4_", "beatjump_+/2_" },
	["jump5"] = { "beatjump_+4_", "beatjump_+1_" },
	["jump5.5"] = { "beatjump_+4_", "beatjump_+1_", "beatjump_+/2_" },
	["jump6"] = { "beatjump_+4_", "beatjump_+2_" },
	["jump6.5"] = { "beatjump_+4_", "beatjump_+2_", "beatjump_+/2_" },
	["jump7"] = { "beatjump_+4_", "beatjump_+2_", "beatjump_+1_" },
	["jump7.5"] = { "beatjump_+4_", "beatjump_+2_", "beatjump_+1_", "beatjump_+/2_" },
	["jump8"] = { "beatjump_+8_" }
}

---------------------------------------------------------------------------------
-- loop size/vals
---------------------------------------------------------------------------------

traktor.loop_id2val = { "/32", "/16", "/8", "/4", "/2", "1", "2", "4", "8", "16", "32" }
traktor.loop_val2id = {}

for i, len in ipairs(traktor.loop_id2val) do
	traktor.loop_val2id[len] = i
end

---------------------------------------------------------------------------------
-- effects select indexes
---------------------------------------------------------------------------------

traktor.fx = {}

local fx_names = {
	"Beatmasher 2",
	"Flanger",
	"Flanger Pulse",
	"Flanger Flux",
	"Gater",
	"Delay",
	"Delay T3",
	"Filter LFO",
	"Filter Pulse",
	"Filter",
	"Filter:92 LFO",
	"Filter:92 Pulse",
	"Filter:92",
	"Phaser",
	"Phaser Pulse",
	"Phaser Flux",
	"Reverse Grain",
	"Turntable FX",
	"Iceverb",
	"Reverb",
	"Reverb T3",
	"Ringmodulator",
	"Digital LoFi",
	"Mulholland Drive",
	"Transpose Stretch",
	"BeatSlicer",
	"Formant Filter",
	"Peak Filter",
	"Tape Delay",
	"Ramp Delay",
	"Bouncer",
	"Auto Bouncer"
}

local fx_incr = math.ceil(127 / #fx_names)

for i,fx in ipairs(fx_names) do
	local v = fx_incr * i
	if v > 127 then v = 127 end
	traktor.fx[fx] = v
end

---------------------------------------------------------------------------------
-- traktor fx control
---------------------------------------------------------------------------------

function traktor.fx_control(a)

	local unit = 1
	if a.unit ~= nil then
		unit = a.unit
	end

	-- group/single

	if a.mode ~= nil then
		send("traktor", "fx_panel_mode_unit_"..unit.."_"..a.mode, ON)
	end

	-- fx select single

	if a.fx ~= nil then
		send("traktor", "effect_select_unit_"..unit, traktor.fx[a.fx])
	end

	-- param 1,2,3

	for p = 1,3 do
		if a["param"..p] ~= nil then
			send("traktor", "effect_param_"..p.."_unit_"..unit, a["param"..p])
		end
	end

	-- button 1,2

	for b = 1,2 do
		if a["button"..b] ~= nil then
			send("traktor", "effect_button_"..b.."_unit_"..unit, a["button"..b])
		end
	end

	-- dry/wet

	if a.drywet ~= nil then
		send("traktor", "dry_wet_single_unit_"..unit, a.drywet)
	end

	-- on/off

	if a.active ~= nil then
		send("traktor", "effect_on_unit_"..unit, ON)
	end

	-- deck on/off

	for _, d in ipairs{"a", "b", "c", "d"} do
		if a["deck_"..d] ~= nil then
			send("traktor", "effect_unit_"..unit.."_on_"..d, a["deck_"..d])
		end
	end
end

---------------------------------------------------------------------------------
-- simulate post fader fx by setting up one fx unit with the gater
---------------------------------------------------------------------------------

function traktor.postfaderfx_status(deck, unit, status)
	if status == nil or status == ON then

		local vol = get("traktor", "volume_fader_"..deck)

		traktor.fx_control{
			unit = unit,
			mode = "single",
			fx = "Gater",
			param1 = ON,
			button1 = ON,
			button2 = OFF,
			drywet = 127 - math.floor(vol/2),
			active = ON,
			deck_a = ON
		}

		send("traktor", "volume_fader_"..deck, 127)
	else
		local vol = get("traktor", "dry_wet_single_unit_"..unit)
		traktor.fx_control{ unit = unit, deck_a = OFF }
		send("traktor", "volume_fader_"..deck, 127 - (vol - 64) * 2)
	end
end

---------------------------------------------------------------------------------
-- faderfx
---------------------------------------------------------------------------------

function traktor.faderfx(d, e, p, on_color, off_color, deck, e2, e3)

	--
	-- work out faderfx args
	--

	local faderfx_d
	local faderfx_e
	local faderfx_p
	local faderfx_unit
	local faderfx_cache

	if type(e2) == "table" then
		if e2.d == nil then faderfx_d = d
		else faderfx_d = e2.d end

		if e2.p == nil then faderfx_p = p
		else faderfx_p = e2.p end

		if e2.unit == nil then faderfx_unit = 1
		else faderfx_unit = e2.unit end

		faderfx_e = e2.e
		faderfx_cache = faderfx_d .. "__" .. faderfx_e .. "__" .. faderfx_p
	end

	--
	-- work out postfaderfx args
	--

	local postfaderfx_d
	local postfaderfx_e
	local postfaderfx_p
	local postfaderfx_unit
	local postfaderfx_cache

	if type(e3) == "table" then
		if e3.d == nil then postfaderfx_d = d
		else postfaderfx_d = e3.d end

		if e3.p == nil then postfaderfx_p = p
		else postfaderfx_p = e3.p end

		if e3.unit == nil then postfaderfx_unit = 1
		else postfaderfx_unit = e3.unit end

		postfaderfx_e = e3.e
		postfaderfx_cache = postfaderfx_d .. "__" .. postfaderfx_e .. "__" .. postfaderfx_p
	end

	--
	-- create the faderfx and/or postfaderfx toggle buttons
	--

	if type(e2) == "table" then
		toggle_modifier(faderfx_d, faderfx_e, faderfx_p, on_color, off_color, faderfx_cache, 
			function(d, e, v, p)
				traktor.faderfx_toggle_change(deck, faderfx_cache, faderfx_unit, postfaderfx_cache, postfaderfx_unit)
			end
		)
	end

	if type(e3) == "table" then
		toggle_modifier(postfaderfx_d, postfaderfx_e, postfaderfx_p, on_color, off_color, postfaderfx_cache, 
			function(d, e, v, p)
				traktor.faderfx_toggle_change(deck, faderfx_cache, faderfx_unit, postfaderfx_cache, postfaderfx_unit)
			end
		)
	end

	--
	-- setup routing for the volume fader
	--

	capture(d, e, ALL, p, function(d2, e2, v2, p2)

		local faderfx_val = get(faderfx_cache)
		local postfaderfx_val = get(postfaderfx_cache)
		
		if faderfx_val == 0 and postfaderfx_val == 0 then
			send("traktor", "volume_fader_"..deck, v2)
		elseif faderfx_val > 0 then
			send("traktor", "dry_wet_group_unit_"..faderfx_unit, 127 - v2)
			send("traktor", "dry_wet_single_unit_"..faderfx_unit, 127 - v2)
		elseif postfaderfx_val > 0 then
			send("traktor", "dry_wet_single_unit_"..postfaderfx_unit, 127 - math.floor(v2/2))
		end
	end)
end

function traktor.faderfx_toggle_change(deck, faderfx, faderfx_unit, postfaderfx, postfaderfx_unit)

	local faderfx_lastval = get(faderfx.."_lastval")
	local postfaderfx_lastval = get(postfaderfx.."_lastval")

	local faderfx_val = get(faderfx)
	local postfaderfx_val = get(postfaderfx)

	set(faderfx.."_lastval", faderfx_val)
	set(postfaderfx.."_lastval", postfaderfx_val)

	if faderfx_lastval ~= faderfx_val then
		if faderfx_val > 0 then 
			send("traktor", "dry_wet_group_unit_"..faderfx_unit, 0) 
			send("traktor", "dry_wet_single_unit_"..faderfx_unit, 0) 
		end
		send("traktor", "effect_unit_"..faderfx_unit.."_on_"..deck, faderfx_val)
	end

	if postfaderfx_lastval ~= postfaderfx_val then
		if postfaderfx_val > 0 then
			traktor.postfaderfx_status(deck, postfaderfx_unit, ON)
		else
			traktor.postfaderfx_status(deck, postfaderfx_unit, OFF)
		end
	end
end

---------------------------------------------------------------------------------
-- traktor heartbeat
---------------------------------------------------------------------------------

function traktor.deck_heartbeat(_deck)

	print "deprecated: use 'beat' event instead from midi clock"

	--
	-- do nothing if has already been called
	--

	if traktor["heartbeat_lastval_" .. _deck] ~= nil then
		return
	end

	--
	-- init and setup our event callback/generation hook
	--

	local deck = _deck
	local lastval = "heartbeat_lastval_" .. deck
	local lastticks = "heartbeat_lastticks" .. deck
	local heartbeat = "heartbeat_" .. deck

	traktor[lastval] = 0
	traktor[lastticks] = 0

	--
	-- seem to sometimes get spurious 0 messages from traktor sometimes
	-- hence counting the number of ticks between changes
	--

	capture("traktor", "beat_" .. deck, ALL, 0, function(d, e, v, p)

		if v ~= traktor[lastval] and traktor[lastticks] > 4 then
			traktor[lastval] = v
			traktor[lastticks] = 0
			create("traktor", heartbeat, v)
		else
			traktor[lastticks] = traktor[lastticks] + 1
		end
	end)
end

---------------------------------------------------------------------------------
-- traktor heartbeat master
---------------------------------------------------------------------------------

function traktor.heartbeat()

	print "deprecated: use 'beat' event instead from midi clock"

	traktor.deck_heartbeat("a")
	traktor.deck_heartbeat("b")

	traktor.deck_heartbeat_master = "a"
	traktor.deck_heartbeat_master_time = os.time()

	for _, _deck in ipairs{"a", "b"} do
		local deck = _deck
		capture("traktor", "heartbeat_"..deck, ALL, 0, function(d, e, v, p)
			if traktor.deck_heartbeat_master == deck then
				traktor.deck_heartbeat_master_time = os.time()
				create("traktor", "heartbeat", v)
			elseif os.time() - traktor.deck_heartbeat_master_time > 2 then
				traktor.deck_heartbeat_master = deck
			end
		end)
	end
end

---------------------------------------------------------------------------------
-- add hot cue to a button, and delete hotcue if shift pressed
---------------------------------------------------------------------------------

---1 C<traktor.hotcue()>
--
-- add a hotcue with delete functionality
--
---2 Usage
--
--  traktor.hotcue(d, e, p, on_color, off_color, shift, deck, cuenum, callback)
--
-- param: d device name in
-- param: e event name in
-- param: p page, use 0 for all pages in
-- param: on_color local led on color. can either be a single value or a table of 6 values based on the cue type to set different colors
-- param: off_color local led off color
-- param: shift the name of the modifier to switch between select/store and delete functionality
-- param: deck a or b
-- param: cuenum a number from 1 to 8
-- param: callback optional function to call 
--
---2 Examples
--
-- using colors defined for a launchpad, but the same code (with different colors defined) will work for any grid controller with led feedback on the pads
--
--  -- first create a shift control that will set "myshift" on the "arm" 
--  -- of the launchpad
--
--  hold_modifier("grid", "arm", 0, lp_hi_yellow, lp_lo_red, "myshift")
--
--  -- add 4 hotcues on row 1 of a grid controller
--
--  traktor.hotcue("grid", "1,0", 127, 0, "myshift", "a", 1)
--  traktor.hotcue("grid", "1,1", 127, 0, "myshift", "a", 2)
--  traktor.hotcue("grid", "1,2", 127, 0, "myshift", "a", 3)
--  traktor.hotcue("grid", "1,3", 127, 0, "myshift", "a", 4)
--
--  -- define different colors for different cue types
--
--  mycolors = { lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_yellow, lp_hi_red }
--
--  -- add 4 hotcues using those colors
--
--  traktor.hotcue("grid", "2,0", mycolors, 0, "myshift", "a", 1)
--  traktor.hotcue("grid", "2,1", mycolors, 0, "myshift", "a", 2)
--  traktor.hotcue("grid", "2,2", mycolors, 0, "myshift", "a", 3)
--  traktor.hotcue("grid", "2,3", mycolors, 0, "myshift", "a", 4)
--
---

function traktor.hotcue(d, e, p, on_color, off_color, shift, deck, cuenum, callback)

	local set_hotcue = "select_set_store_hotcue_"..cuenum.."_"..deck
	local delete_hotcue = "delete_hotcue_"..cuenum.."_"..deck
	local hotcue_state = "hotcue"..cuenum.."_state_"..deck

	-- if passed single on-val use for all

	if type(on_color) ~= "table" then
		on_color = { on_color, on_color, on_color, on_color, on_color, on_color }
	end

	capture(d, e, ALL, p, function(d, e, v, p)

		-- either set/store or delete a hotcue if shift is pressed
		local called = ""
		if get(shift) == 0 then
			called = "select_set_store_hotcue_"..cuenum
			send("traktor", set_hotcue, v)
		else
			called = "delete_hotcue_"..cuenum
			send("traktor", delete_hotcue, v)
		end

		call(callback, d, e, v, p, called)
	end)

	-- always send traktors hotcue events back to the pad led

	capture("traktor", hotcue_state, ALL, 0, function(d2, e2, v2, p2)
		if v2 > 0 then
			if on_color[v2] ~= nil then
				send(d, e, on_color[v2], p)
			else
				send(d, e, on_color[1], p)
			end
		else
			send(d, e, off_color, p)
		end
	end)

	-- init pad color

	send(d, e, off_color, p)
end

---------------------------------------------------------------------------------
-- traktor hotcues
---------------------------------------------------------------------------------

---1 C<traktor.hotcues()>
--
-- convenience function to add a block of hotcues, supports same options/features as C<traktor.hotcue()>
--
---2 Usage
--
--  traktor.hotcues(d, e, p, on_color, off_color, shift, deck, firstcuenum, callback)
--
-- param: d device name in
-- param: e event names
-- param: p page, use 0 for all pages in
-- param: on_color local led on color. can either be a single value or a table of 6 values based on the cue type to set different colors
-- param: off_color local led off color
-- param: shift the name of the modifier to switch between select/store and delete functionality
-- param: deck a or b
-- param: firstcuenum the first cue num to use
-- param: callback optional function to call 
--
---2 Examples
--
--  -- first create a shift control that will set "myshift" on the "arm" 
--  -- of the launchpad
--
--  hold_modifier("grid", "arm", 0, lp_hi_yellow, lp_lo_red, "myshift")
--
--  -- add 8 hotcues for deck A and 8 for deck B
--
--  traktor.hotcue("grid", grid("1,0", "2,3"), 127, 0, "myshift", "a", 1)
--  traktor.hotcue("grid", grid("1,4", "2,7"), 127, 0, "myshift", "b", 1)
--
---

function traktor.hotcues(d, e, p, on_color, off_color, shift, deck, firstcuenum, hotcue_fn)

	if type(e) ~= "table" then
		e = { e }
	end

	if type(hotcue_fn) ~= "function" then
		hotcue_fn = traktor.hotcue
	end


	for i, e2 in ipairs(e) do
		call(hotcue_fn, d, e2, p, on_color, off_color, shift, deck, firstcuenum + i - 1)
	end
end

---------------------------------------------------------------------------------
-- traktor loops
---------------------------------------------------------------------------------

---1 C<traktor.loops()>
--
-- add a grid of buttons for selecting loop size and activating the loop. 
--
-- normally deactivates when u release the button. if you pass in the C<shift> parameter then pressing the shift followed by a loopsize will keep the loop active when you release
--
-- any changes within traktor of loop size and status will be reflected on the leds
--
---2 Usage
--
--  traktor.loops(d, e, p, on_color, off_color, shift, deck, sizes)
--
-- param: d device name in
-- param: e event names, 
-- param: p page, use 0 for all pages in
-- param: on_color local led on color
-- param: off_color local led off color
-- param: deck a or b
-- param: shift the name of the modifier to switch between hold and toggle mode (optional)
-- param: sizes the range of loop sizes to use (optional, defaults to 1/8 to 16)
--
---2 Examples
--
-- define a shift button that will be used to change between hold/toggle mode
-- 
--  hold_modifier("grid", "arm", 0, lp_hi_yellow, lp_lo_red, "myshift")
--
-- manually define the list of 8 grid pad names
--
--  traktor.loops("lp", 
--     {"6,0", "6,1", "6,2", "6,3", "7,0", "7,1", "7,2", "7,3"}, 
--     0, lp_hi_green, lp_lo_green, "a", "myshift"
--  )
--
-- use the C<grid()> function to generate the list of our 8 grid pad names. define 8 loop pads using default loop sizes:
--
--  traktor.loops("lp", grid("6,0", "7,3"), 0, lp_hi_green, lp_lo_green, "a", "myshift")
--
-- define our own set of loop sizes to pass in and also define for deck b
--
--  loopsizes = { "/16", "/8", "/4", "/2", "1", "2", "4", "8" }
-- 
--  traktor.loops("lp", grid("6,0", "7,3"), 0, lp_hi_green, lp_lo_green, "a", "myshift", loopsizes)
--  traktor.loops("lp", grid("6,4", "7,7"), 0, lp_hi_green, lp_lo_green, "b", "myshift", loopsizes)
--
---

function traktor.loops(d, e, p, on_color, off_color, deck, shift, sizes)

	--
	-- 
	--

	--
	-- default sizes if none provided
	--

	if sizes == nil then
		sizes = { "/8", "/4", "/2", "1", "2", "4", "8", "16" }
	end

	--
	-- attach actions to each button, toggle if shift pressed
	--

	for i, e2 in ipairs(e) do
		if sizes[i] ~= nil then
			local e3 = "loop_size_set_" .. sizes[i] .. "_" .. deck
			local v3 = traktor.loop_val2id[sizes[i]]
			capture(d, e2, ALL, p, function(d, e2, v2, p)
				if v2 > 0 then
					send("traktor", e3, ON)
					send("traktor", "loop_active_" .. deck, ON)
					create("traktor", "loop_size_" .. deck, v3) -- traktor won't resend if it's the current loop len
				elseif shift ~= nil and get(shift) == 0 then
					send("traktor", "loop_active_" .. deck, OFF)
				end
			end)
		end
	end

	--
	-- do all pad led changes based on traktor feedback
	--

	capture("traktor", "loop_size_" .. deck, ALL, 0, function(d2, e2, v2, p2)
		traktor.loops_change_callback(d, e, v, p, on_color, off_color, deck, sizes, v2, -1)
	end)

	capture("traktor", "loop_active_" .. deck, ALL, 0, function(d2, e2, v2, p2)
		traktor.loops_change_callback(d, e, v, p, on_color, off_color, deck, sizes, -1, v2)
	end)

	--
	-- init off colors
	--

	for _, e2 in ipairs(e) do
		send(d, e2, off_color, p)
	end
end

function traktor.loops_change_callback(d, e, v, p, on_color, off_color, deck, sizes, loop_size, loop_active)

	if loop_size ~= -1 then
		traktor["loop_size_" .. deck] = loop_size
	elseif loop_active ~= -1 then
		traktor["loop_active_" .. deck] = loop_active
	end

	if traktor["loop_active_" .. deck] == 0 then
		for _, e2 in ipairs(e) do
			send(d, e2, off_color, p)
		end
	else
		-- find the name of the active pad to light up

		local lsn = traktor.loop_id2val[traktor["loop_size_" .. deck]]
		local pos = 1

		for i, name in ipairs(sizes) do
			if name == lsn then
				pos = i
			end
		end

		-- turn off all pads except the active one

		for i,e2 in ipairs(e) do
			if i == pos then
				send(d, e2, on_color, p)
			else
				send(d, e2, off_color, p)
			end
		end
	end

end

---------------------------------------------------------------------------------
-- traktor slicer: enable
---------------------------------------------------------------------------------

---1 C<traktor.slicer_enable()>
--
-- enable a slicer at the current beat
--
---2 Usage
--
--  traktor.slicer_enable(sid, hotcue)
--
-- param: sid slicer id, starting from 1 with the first call to C<traktor.slicer_create()> and increments
-- param: hotcue a hotcue number to jump to before enabling the slicer (optional)
--
---2 Examples
--
-- start slicer from current position
--
--  sid = traktor.slicer_create("lp", grid("6,0", "7,3"), 1, "a", lp_hi_red, lp_lo_red)
--  traktor.slicer_enable(sid)
--
-- jump to hotcue 1 for the slicer dec (a) before starting the slicer
--
--  sid = traktor.slicer_create("lp", grid("6,0", "7,3"), 1, "a", lp_hi_red, lp_lo_red)
--  traktor.slicer_enable(sid, 1)
--
---

function traktor.slicer_enable(sid, hotcue)

	traktor.slicer[sid].pad_jumped = true
	traktor.slicer[sid].active = true
	traktor.slicer[sid].pad_pressed = false

	--
	-- if phase is 2 or less then we seem to be a beat out
	-- then where we expect
	--

	local phase = get_midi_clock_phase()

	if phase < 3 then
		traktor.slicer[sid].step = 8
		traktor.slicer[sid].phase_adjust = true
	else
		traktor.slicer[sid].step = 1
		traktor.slicer[sid].phase_adjust = false
	end

	--
	-- pass in a hotcue number to jump to a predefined hotcue
	-- else will set+use the active cue
	--

	if hotcue == nil then
		send("traktor", "loop_in_set_cue_" .. traktor.slicer[sid].deck , ON)
		traktor.slicer[sid].hotcue = ''
	else
		local t = "select_set_store_hotcue_" .. hotcue .. "_" .. traktor.slicer[sid].deck
		send("traktor", t, ON)
		traktor.slicer[sid].hotcue = t
	end

	--
	-- init pad colours 
	--

	local d = traktor.slicer[sid].device
	local p = traktor.slicer[sid].page

	for i = 1, 8 do
		if i == traktor.slicer[sid].step then
			send(d, traktor.slicer[sid].pads[i], traktor.slicer[sid].on_color, p)
		else
			send(d, traktor.slicer[sid].pads[i], traktor.slicer[sid].off_color, p)
		end
	end
end

---------------------------------------------------------------------------------
-- traktor slicer: disable
---------------------------------------------------------------------------------

---1 C<traktor.slicer_disable()>
--
-- disable the specified slicer
--
---2 Usage
--
--  traktor.slicer_disable(sid)
--
-- param: sid slicer id, starting from 1 with the first call to C<traktor.slicer_create()> and increments
--
---2 Examples
--
--  traktor.slicer_disable(1)
--
---

function traktor.slicer_disable(sid)
	traktor.slicer[sid].active = false
end

---------------------------------------------------------------------------------
-- traktor slicer: toggle
---------------------------------------------------------------------------------

---1 C<traktor.slicer_toggle()>
--
-- create a toggle button to enable/disable the specified slicer
--
---2 Usage
--
--  traktor.slicer_toggle[d, e, p, on_color, off_color, sid, [name], callback])
--
-- param: d device name in
-- param: e event names, 
-- param: p page, use 0 for all pages in
-- param: on_color local led on color
-- param: off_color local led off color
-- param: sid slicer id, starting from 1 with the first call to C<traktor.slicer_create()> and increments
-- param: name name that can be used via get(name) to get the current slicer status (optional, default C<nil>)
-- param: callback function to be called on slicer status change (optional)
--
---2 Examples
--
--  sid = traktor.slicer_create("lp", grid("6,0", "7,3"), 1, "a", lp_hi_red, lp_lo_red)
--  traktor.slicer_toggle("lp", "trkon", lp_hi_yellow, lp_lo_yellow, sid, "slicer_a_status")
--
---

function traktor.slicer_toggle(d, e, p, on_color, off_color, sid, name, callback)
	toggle_modifier(d, e, p, on_color, off_color, name, function(d, e, v, p)
		if v > 0 then
			traktor.slicer_enable(sid)
		else
			traktor.slicer_disable(sid)
		end

		if callback ~= nil then
			call(callback, d, e, traktor.slicer[sid].active, p)
		end
	end)
end

---------------------------------------------------------------------------------
-- traktor slicer: loop_toggle
---------------------------------------------------------------------------------

---1 C<traktor.slicer_loop_toggle()>
--
-- create a toggle button to enable/disable the specified slicer
--
---2 Usage
--
--  traktor.slicer_loop_toggle[d, e, p, on_color, off_color, sid, [name], callback])
--
-- param: d device name in
-- param: e event names, 
-- param: p page, use 0 for all pages in
-- param: on_color local led on color
-- param: off_color local led off color
-- param: sid slicer id, starting from 1 with the first call to C<traktor.slicer_create()> and increments
-- param: name name that can be used via get(name) to get the current slicer status (optional, default C<nil>)
-- param: callback function to be called on slicer status change (optional)
--
---2 Examples
--
--  sid = traktor.slicer_create("lp", grid("6,0", "7,3"), 1, "a", lp_hi_red, lp_lo_red)
--  traktor.slicer_loop_toggle("lp", "trkon", lp_hi_yellow, lp_lo_yellow, sid, "slicer_a_loopstatus")
--
---

function traktor.slicer_loop_toggle(d, e, p, on_color, off_color, sid, name, callback)
	toggle_modifier(d, e, p, on_color, off_color, name, function(d, e, v, p)
		if v > 0 then
			traktor.slicer[sid].loop_mode = true
		else
			traktor.slicer[sid].loop_mode = false
		end

		if callback ~= nil then
			call(callback, d, e, traktor.slicer[sid].loop_mode, p)
		end
	end)
end

---------------------------------------------------------------------------------
-- traktor slicer: create
---------------------------------------------------------------------------------

---1 C<traktor.slicer_create()>
--
-- create a twitch style slicer on a set of pads with led feedback
--
---2 Usage
--
--  traktor.slicer_create(d, pads, p, deck, on_color, off_color)
--
-- param: d device name in
-- param: pads the pads (event names) to assign the slicer to
-- param: p page, use 0 for all pages in
-- param: deck a or b
-- param: on_color local led on color
-- param: off_color local led off color
--
-- return value is the slicer id, starting from 1 with the first call to C<traktor.slicer_create()> and increments
--
---2 Examples
--
--  traktor.slicer_create("lp", grid("6,0", "7,3"), 1, "a", lp_hi_red, lp_lo_red)
--
---

function traktor.slicer_create(d, pads, p, deck, on_color, off_color)

	--
	-- make sure we have the heartbeat running
	--

	--traktor.deck_heartbeat(deck)

	--
	-- data cache for this slicer
	--

	local sid = #traktor.slicer + 1
	traktor.slicer[sid] = {
		["step"] = 1,
		["deck"] = deck,
		["page"] = p,
		["device"] = d,
		["app"] = app,
		["on_color"] = on_color,
		["off_color"] = off_color,
		["phase_adjust"] = false,
		["pads"] = pads,
		["active"] = false,
		["hotcue"] = -1,
		['pad_pressed'] = false,
		['pad_jumped'] = false,
		['loop_mode'] = false,
		["pads2step"] = {}
	}

	--
	-- init pad colors
	--

	for i = 1, 8 do
		send(d, pads[i], off_color, p)
	end

	--
	-- animate the pads
	--

	capture("_global", "beat", NOFF, 0, function(d2, e2, v2, p2)
		if traktor.slicer[sid].active then 
			if traktor.slicer[sid].pad_pressed and traktor.slicer[sid].pad_jumped == false then
				traktor.send_beatjump("-1", traktor.slicer[sid].deck)
			else
				traktor.slicer[sid].pad_jumped = false
				send(d, pads[traktor.slicer[sid].step], off_color, p)
				traktor.slicer[sid].step = traktor.slicer[sid].step + 1
				if traktor.slicer[sid].step >= 9 then 
					traktor.slicer[sid].step = 1 

					if traktor.slicer[sid].loop_mode then
						send("traktor", "jump_to_active_cue_point_" .. traktor.slicer[sid].deck, ON)
					else 
						send("traktor", "loop_in_set_cue_" .. traktor.slicer[sid].deck , ON)
					end
				end
				send(d, pads[traktor.slicer[sid].step], on_color, p)
			end
		end
	end)

	--
	-- beatjumps
	--

	for i,e in ipairs(pads) do

		-- map back from pad name to slicer step
		traktor.slicer[sid].pads2step[e] = i

		capture(d, e, ALL, p, function(d, e, v, p)
			if traktor.slicer[sid].active then
				if v > 0 then
					traktor.slicer[sid].pad_pressed = true
					local jump = traktor.slicer[sid].pads2step[e] - 1
					send("traktor", "jump_to_active_cue_point_" .. traktor.slicer[sid].deck, ON)

					if jump > 0 then
						traktor.send_beatjump(jump, traktor.slicer[sid].deck, 1)
					end

					send(d, pads[traktor.slicer[sid].step], off_color, p)
					if jump == 0 then jump = 8 end
					traktor.slicer[sid].step = jump
					send(d, pads[traktor.slicer[sid].step], on_color, p)
					traktor.slicer[sid].pad_jumped = true
				else
					traktor.slicer[sid].pad_pressed = false
				end
			end
		end)
	end

	--
	-- disable slicer when loop disabled
	--

	-- return the id so it can be attached to a button
	return sid
end

function traktor.send_beatjump(jump, deck, delay)
	if traktor.beatjumps["jump"..jump] ~= nil then
		for i,j in ipairs(traktor.beatjumps["jump"..jump]) do
			send("traktor", j .. deck, ON, 0, delay)
			delay = delay + 1
			send("traktor", j .. deck, OFF, 0, delay)
			delay = delay + 2
		end
	end
end

return traktor



