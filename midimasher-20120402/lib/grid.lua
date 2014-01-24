---------------------------------------------------------------------------------
-- combo_page_switcher
---------------------------------------------------------------------------------

function combo_page_switcher(device, buttons, cb)

	local tmp = {}

	--
	-- list all page switcher buttons used
	--

	for _, e in ipairs(buttons) do
		if type(e) == "table" then
			for _, ee in ipairs(e) do
				tmp[ee] = 1
			end
		else
			tmp[e] = 1
		end
	end

	local all = keys(tmp)

	--
	-- a function to reset leds to indicate current page
	--

	local reset_leds = function(d, e)
		local t = {}
		if type(e) == "table" then
			for _, ee in ipairs(e) do
				send(d, ee, ON)
				t[ee] = 1
			end
		else
			send(d, e, ON)
			t[e] = 1
		end

		for _, ee in ipairs(all) do
			if t[ee] == nil then
				send(d, ee, OFF)
			end
		end

		call(cb)
	end

	--
	-- cache to store status of each button
	--

	local cache = {}

	for _, e in ipairs(all) do
		cache[e] = mkcachename("combo_page_switcher", device, e)
	end

	--
	-- finally attach callbacks for each page switch button
	--

	for _, e in ipairs(all) do
		capture(device, e, ALL, 0, function(d, e, v, p)
			if v > 0 then

				--
				-- register that this button is held down
				--

				set(cache[e], ON)

				--
				-- check if any combos match
				--

				for page, spec in ipairs(buttons) do
					if type(spec) == "table" then
						local match = true
						for _, ee in ipairs(spec) do
							if get(cache[ee]) == 0 then
								match = false
							end
						end
						if match then
							set_page(d, page)
							reset_leds(d, spec)
							return
						end
					end
				end

				--
				-- only get here if no combos match
				--

				for page, spec in ipairs(buttons) do
					if type(spec) ~= "table" and spec == e then
						set_page(d, page)
					end
				end
				reset_leds(d, e)
			else

				--
				-- register that this button has been released
				--

				set(cache[e], OFF)
			end
		end)
	end
end

---------------------------------------------------------------------------------
-- superfader
---------------------------------------------------------------------------------

function superfader(device, ein, pin, minin, maxin, eout, minout, maxout, offout)

	if offout == nil then offout = OFF end
	if maxout == nil then maxout = minout end

	local cache = mkcachename("superfader", device, ein, pin, minin, maxin, eout, minout, maxout)
	local mult, fixedout, nv, cv, invert
	
	if maxin == minin or maxout == minout then
		fixedout = minout
	elseif minout > maxout then
		mult, invert = (minout - maxout) / (maxin - minin), true
	else
		mult = (maxout - minout) / (maxin - minin)
	end

	capture(device, ein, ALL, pin, function(d, e, v, p)
		cv = get(cache)
		if v < minin or v > maxin then
			if cv ~= offout then
				create(device, eout, offout, pin)
				set(cache, offout)
			end
		else
			if fixedout then
				nv = fixedout
			elseif invert then
				nv = minout - v * mult
			else
				nv = v * mult
			end

			if nv ~= cv then
				create(device, eout, nv, pin)
				set(cache, nv)
			end
		end
	end)
end

---------------------------------------------------------------------------------
-- latching_layers
--------------------------------------------------------------------------------

function latching_layers(device, page, name, main_buttons, paging_button, paging_colors, on_color, off_color, callback)

	num_sub_pages = table.getn(paging_colors)
	attach_midi_subdevice(device, main_buttons, page, name, num_sub_pages)

	local cachename = name .. "___page"
	local numpages_cachename = name .. "___numpages"
	set(numpages_cachename, num_sub_pages)

	capture(device, paging_button, ON, page, function(d, e, v, p)
		local old_page = get_page(name)
		local max_page = get(numpages_cachename)

		local new_page

		if old_page == max_page then
			new_page = 1
		else
			new_page = old_page + 1
		end

		-- if callback defined it is responsible for setting the page

		if callback ~= nil then
			call(callback, name, e, v, new_page, new_page ~= old_page, device)
		else
			set_page(name, new_page)
		end

		-- update page change button led color

		send(device, paging_button, paging_colors[new_page], page)
	end)

	-- send initial page change button led color

	send(device, paging_button, paging_colors[1], page)
end

---------------------------------------------------------------------------------
-- toggled_layers
---------------------------------------------------------------------------------

function toggled_layers(device, page, name, main_buttons, paging_buttons, on_color, off_color, callback)

	num_sub_pages = table.getn(paging_buttons)
	attach_midi_subdevice(device, main_buttons, page, name, num_sub_pages)

	local cachename = name .. "___page"

	toggle_group(device, paging_buttons, page, on_color, off_color, cachename, function(d, e, v, p)
		local old_page = get_page(name)
		local new_page = get(cachename)

		-- if callback defined it is responsible for setting the page

		if callback ~= nil then
			call(callback, name, e, v, new_page, new_page ~= old_page, device)
		else
			set_page(name, new_page)
		end
	end)
end

---------------------------------------------------------------------------------
-- toggle groups
---------------------------------------------------------------------------------

function toggle_group(device, _buttons, _page, _on_color, _off_color, _cache, callback)

	if type(_buttons) ~= "table" then return end

	local cache = _cache
	local buttons = _buttons
	local off_color = _off_color
	local on_color = _on_color
	local page = _page

	-- create name for toggle cache if not passed on

	if cache == nil then
		cache = device .. "_"
		for _,e in ipairs(buttons) do
			cache = cache .. "_" .. e
		end
		cache = cache .. "___" .. page
	end

	-- map toggle actions

	for i,e in ipairs(buttons) do
		capture(device, e, NOFF, page, function(d, e, v, p)
			local ii = i
			local old = get(cache)
			send(device, buttons[old], off_color, page)
			set(cache, ii)
			send(device, buttons[ii], on_color, page)
			call(callback, d, e, v, p)
		end)

		-- init button/page 1 on

		if i == 1 then
			send(device, e, on_color, page)
		else
			send(device, e, off_color, page)
		end
	end

	-- init button/page 1 on

	set(cache, 1)
end

---------------------------------------------------------------------------------
-- vertical fader
---------------------------------------------------------------------------------
-- if local_update=false then leds will only be updated via midi feedback from target device

virtual_yfader_cache = {}
virtual_yfader_cache_dinval = {}
virtual_yfader_cache_din2val = {}

function virtual_yfader(din, y, x, page, dout, eout, pout, nbtns, on_color, off_color, min_val, max_val, 
						lu, din2, ein2, pin2, shift2)

	if off_color == nil then off_color = 0 end
	if on_color == nil then on_color = 127 end
	if min_val == nil then min_val = 0 end
	if max_val == nil then max_val = 127 end
	if lu == nil then lu = 1 end

	local local_update = lu
	local vyf_id = #virtual_yfader_cache + 1
	virtual_yfader_cache[vyf_id] = {}
	virtual_yfader_cache_dinval[vyf_id] = 0
	virtual_yfader_cache_din2val[vyf_id] = 0
	local incr = (max_val - min_val) / (nbtns - 1)

	--
	-- grid controller --> target device
	-- e.g: launchpad --> traktor/volume_fader_a
	--

	for btn=0, nbtns-1 do
		-- define here so is only calculated once at startup
		local val = math.floor(incr * btn)

		capture(din, (y-btn)..","..x, NOFF, page, function(d, e, v, p)

			-- send event onto remote end (e.g: traktor)
		 	send(dout, eout, val)
			virtual_yfader_cache_dinval[vyf_id] = val

			if local_update == true then
				-- now update fader to match (e.g: launchpad)
				for btn=1, nbtns-1 do
					if val > (btn-1)*incr then
						if virtual_yfader_cache[vyf_id][btn] == 0 then
							send(din, (y-btn)..","..x, on_color, page)
							virtual_yfader_cache[vyf_id][btn] = 1
						end
					else
						if virtual_yfader_cache[vyf_id][btn] == 1 then
							send(din, (y-btn)..","..x, off_color, page)
							virtual_yfader_cache[vyf_id][btn] = 0
						end
					end
				end
			end
		end)

		--
		-- init pad led colors
		--

		if btn == 0 then
			send(din, y..","..x, on_color, page)
		else
			send(din, (y-btn)..","..x, off_color, page)
			virtual_yfader_cache[vyf_id][btn] = 0
		end
	end

	--
	-- target device --> grid controller 
	-- e.g: traktor/volume_fader_a --> launchpad
	--

	capture(dout, eout, ALL, 0, function(d, e, v, p)
		for btn=1, nbtns-1 do
			if v > (btn-1)*incr then
				--print(">>>",v,"btn"..btn, "on")
				if virtual_yfader_cache[vyf_id][btn] == 0 then
					send(din, (y-btn)..","..x, on_color, page)
					virtual_yfader_cache[vyf_id][btn] = 1
				end
			else
				--print(">>>",v,"btn"..btn, "off")
				if virtual_yfader_cache[vyf_id][btn] == 1 then
					send(din, (y-btn)..","..x, off_color, page)
					virtual_yfader_cache[vyf_id][btn] = 0
				end
			end
		end
	end)

	--
	-- target device 2 --> grid controller 
	-- e.g: traktor/monitor_deck_afl_mono_a --> launchpad
	--

	if pin2 == nil then pin2 = 0 end

	if din2 ~= nil and ein2 ~= nil then
		capture(din2, ein2, ALL, pin2, function(d, e, v, p)
			if shift2 == nil or get(shift2) > 0 then
				for btn=1, nbtns-1 do
					if v > (btn-1)*incr then
						if virtual_yfader_cache[vyf_id][btn] == 0 then
							send(din, (y-btn)..","..x, on_color, page)
							virtual_yfader_cache[vyf_id][btn] = 1
						end
					else
						if virtual_yfader_cache[vyf_id][btn] == 1 then
							send(din, (y-btn)..","..x, off_color, page)
							virtual_yfader_cache[vyf_id][btn] = 0
						end
					end
				end
			end
		end)
	end

	--
	-- capture the shift on/off
	-- * reset to secondary (vumeter?) input if the shift is enabled
	-- * reset to the position of the last fader press if shift turned off
	--

	if shift2 ~= nil then
		capture("_varchange", shift2, ALL, 0, function(d, e, v, p)

			local val

			if v > 0 then
				-- reset to last known din2 val in case no new din2 vals coming (i.e: no level etc)
				val = virtual_yfader_cache_din2val[vyf_id]
			else
				-- reset to last known fader value
				val = virtual_yfader_cache_dinval[vyf_id]
			end

			for btn=1, nbtns-1 do
				if val > (btn-1)*incr then
					if virtual_yfader_cache[vyf_id][btn] == 0 then
						send(din, (y-btn)..","..x, on_color, page)
						virtual_yfader_cache[vyf_id][btn] = 1
					end
				else
					if virtual_yfader_cache[vyf_id][btn] == 1 then
						send(din, (y-btn)..","..x, off_color, page)
						virtual_yfader_cache[vyf_id][btn] = 0
					end
				end
			end
		end)
	end

end

---------------------------------------------------------------------------------
-- virtual midifighter - normal mode
---------------------------------------------------------------------------------

function virtual_midifighter(rdev, rdevpage, vdev, y_offset, x_offset, on_color, off_color)

	local off_colors = {}

	-- default colors?

	if on_color == nil then
		off_color = { lp_lo_orange, lp_lo_red, lp_hi_red, lp_hi_red,
						lp_lo_red, lp_lo_green, lp_lo_green, lp_lo_green,
						lp_mi_green, lp_mi_green, lp_mi_green, lp_mi_green,
						lp_lo_orange, lp_hi_orange, lp_hi_orange, lp_lo_orange }

		on_color = lp_hi_yellow
	end

	-- init mapping with grid offsets

	local btns = {}

	if x_offset == nil then x_offset = 0 end
	if y_offset == nil then y_offset = 0 end

	for y=0,3 do
		for x=0,3 do
			btns[y..","..x] = (y+y_offset) .. "," .. (x+x_offset)
		end
	end

	-- create button mappings with the offsets

	local any2mf_map = { 
		[btns["0,0"]] = "C2", [btns["0,1"]] = "C#2", [btns["0,2"]] = "D2", [btns["0,3"]] = "D#2",
		[btns["1,0"]] = "G#1", [btns["1,1"]] = "A1", [btns["1,2"]] = "A#1", [btns["1,3"]] = "B1",
		[btns["2,0"]] = "E1", [btns["2,1"]] = "F1", [btns["2,2"]] = "F#1", [btns["2,3"]] = "G1",
		[btns["3,0"]] = "C1", [btns["3,1"]] = "C#1", [btns["3,2"]] = "D1", [btns["3,3"]] = "D#1"
	}

	local mf2any_map = {}
	for k,v in pairs(any2mf_map) do mf2any_map[v] = k end

	-- create each button and assign its callbacks

	for y=0,3 do
		for x=0,3 do
			btn = btns[y..","..x]

			-- init off color

			if type(off_color) == "number" then
				send(rdev, btn, off_color, rdevpage)
			elseif type(off_color) == "table" then
				off_colors[btn] = off_color[y+4 + x + 1]
				send(rdev, btn, off_color[y*4 + x + 1], rdevpage)
			end

			-- map input to the virtual midifighter

			capture(rdev, btn, ALL, rdevpage, function(d, e, v, p)
				if any2mf_map[e] ~= nil then
					if v > 0 then
						send_midi(vdev, 3, MIDI_NOTE_ON, any2mf_map[e], v)
					else
						send_midi(vdev, 3, MIDI_NOTE_OFF, any2mf_map[e], 127)
					end
				end
			end)

			-- route mf input back to real surface

			capture(vdev, any2mf_map[btn], ALL, 0, function(d, e, v, p)
				if mf2any_map[e] ~= nil then
					if v == 0 then
						if type(off_color) == "number" then
							send(rdev, mf2any_map[e], off_color, rdevpage)
						elseif type(off_color) == "table" then
							send(rdev, mf2any_map[e], off_colors[mf2any_map[e]], rdevpage)
						end
					else
						send(rdev, mf2any_map[e], on_color, rdevpage)
					end
				end
			end)
		end
	end
end

---------------------------------------------------------------------------------
-- virtual midifighter - 4banks mode
---------------------------------------------------------------------------------

mf_4banks_curr_bank = {}

function virtual_midifighter_4banks(rdev, rdevpage, vdev, y_offset, x_offset, on_color, off_color)

	-- default colors?

	if on_color == nil then
		off_color = { lp_lo_red, lp_lo_red, lp_lo_red, lp_lo_red,
						lp_lo_orange, lp_lo_green, lp_lo_orange, lp_lo_green,
						lp_mi_green, lp_mi_green, lp_mi_green, lp_mi_green,
						lp_lo_orange, lp_lo_orange, lp_lo_green, lp_lo_orange }

		on_color = lp_hi_yellow
	end

	-- set our current bank to 1

	local mf_4banks_id = #mf_4banks_curr_bank + 1
	local off_colors = {}
	mf_4banks_curr_bank[mf_4banks_id] = 1

	-- init mapping with grid offsets

	local btns = {}

	if x_offset == nil then x_offset = 0 end
	if y_offset == nil then y_offset = 0 end

	for y=0,3 do
		for x=0,3 do
			btns[y..","..x] = (y+y_offset) .. "," .. (x+x_offset)
		end
	end

	-- localise these maps as they use the above offsets

	local any2mf_4banks_map = { 
	
		["select"] = {
			[btns["0,0"]] = { ["note"] = "C-1", ["bank"] = 1 },
			[btns["0,1"]] = { ["note"] = "C#-1", ["bank"] = 2 },
			[btns["0,2"]] = { ["note"] = "D-1", ["bank"] = 3 },
			[btns["0,3"]] = { ["note"] = "D#-1", ["bank"] = 4 }
		},
	
		["banks"] = {
			{
	 			[btns["1,0"]] = "G#1", [btns["1,1"]] = "A1", [btns["1,2"]] = "A#1", [btns["1,3"]] = "B1",
	 			[btns["2,0"]] = "E1", [btns["2,1"]] = "F1", [btns["2,2"]] = "F#1", [btns["2,3"]] = "G1",
	 			[btns["3,0"]] = "C1", [btns["3,1"]] = "C#1", [btns["3,2"]] = "D1", [btns["3,3"]] = "D#1" 
			},
			{
	 			[btns["1,0"]] = "G#2", [btns["1,1"]] = "A2", [btns["1,2"]] = "A#2", [btns["1,3"]] = "B2",
	 			[btns["2,0"]] = "E2", [btns["2,1"]] = "F2", [btns["2,2"]] = "F#2", [btns["2,3"]] = "G2",
	 			[btns["3,0"]] = "C2", [btns["3,1"]] = "C#2", [btns["3,2"]] = "D2", [btns["3,3"]] = "D#2" 
			},
			{
	 			[btns["1,0"]] = "G#3", [btns["1,1"]] = "A3", [btns["1,2"]] = "A#3", [btns["1,3"]] = "B3",
	 			[btns["2,0"]] = "E3", [btns["2,1"]] = "F3", [btns["2,2"]] = "F#3", [btns["2,3"]] = "G3",
	 			[btns["3,0"]] = "C3", [btns["3,1"]] = "C#3", [btns["3,2"]] = "D3", [btns["3,3"]] = "D#3" 
			},
			{
	 			[btns["1,0"]] = "G#4", [btns["1,1"]] = "A4", [btns["1,2"]] = "A#4", [btns["1,3"]] = "B4",
	 			[btns["2,0"]] = "E4", [btns["2,1"]] = "F4", [btns["2,2"]] = "F#4", [btns["2,3"]] = "G4",
	 			[btns["3,0"]] = "C4", [btns["3,1"]] = "C#4", [btns["3,2"]] = "D4", [btns["3,3"]] = "D#4" 
			}
		}
	}
	
	-- map mf notes back to our surface
	
	local mf2any_bankselect_map = {}
	local mf2any_4banks_map = {}
	local any2mf_4banks_all_map = {}
	
	for k,v in pairs(any2mf_4banks_map["select"]) do 
		mf2any_4banks_map[v["note"]] = k
		mf2any_bankselect_map[v["bank"]] = k
	end
	
	for k2, v2 in ipairs(any2mf_4banks_map["banks"]) do
		for k3, v3 in pairs(any2mf_4banks_map["banks"][k2]) do
			mf2any_4banks_map[v3] = k3
		end
	end

	--dumper(any2mf_4banks_map)

	-- create each button and assign its callbacks

	for x=0,3 do
		for y=0,3 do
			btn = btns[y..","..x]

			-- init off color

			if type(off_color) == "number" then
				send(rdev, btn, off_color, rdevpage)
			elseif type(off_color) == "table" then
				off_colors[btn] = off_color[x + y*4 + 1]
				send(rdev, btn, off_color[x + y*4 + 1], rdevpage)
			end

			-- map input to the virtual midifighter

			capture(rdev, btn, ALL, rdevpage, function(d, e, v, p)
			
				local curr_bank = mf_4banks_curr_bank[mf_4banks_id];

				if any2mf_4banks_map["select"][e] ~= nil then
					if v > 0 then
						-- change selected bank led if changed
						if curr_bank ~= any2mf_4banks_map["select"][e]["bank"] then
							if type(off_color) == "number" then
								send(rdev, mf2any_bankselect_map[curr_bank], off_color, rdevpage)
							elseif type(off_color) == "table" then
								send(rdev, mf2any_bankselect_map[curr_bank], off_colors[mf2any_bankselect_map[curr_bank]], rdevpage)
							end
	
							send(rdev, mf2any_bankselect_map[any2mf_4banks_map["select"][e]["bank"]], on_color, rdevpage)
						end

						-- save bank number and send message out to virtual mf
						mf_4banks_curr_bank[mf_4banks_id] = any2mf_4banks_map["select"][e]["bank"]

						if v > 0 then
							send_midi(vdev, 3, MIDI_NOTE_ON, any2mf_4banks_map["select"][e]["note"], v)
						else
							send_midi(vdev, 3, MIDI_NOTE_OFF, any2mf_4banks_map["select"][e]["note"], 127)
						end
					else
						-- if the current bank pad has been released make sure it stays on (ala lpd8)
	
						if curr_bank == any2mf_4banks_map["select"][e]["bank"] then
							send(rdev, mf2any_bankselect_map[curr_bank], on_color, rdevpage)
						end
					end

				elseif any2mf_4banks_map["banks"][curr_bank][e] ~= nil then

					-- send the message out from a multi bank row (2,3,4)
					if v > 0 then
						send_midi(vdev, 3, MIDI_NOTE_ON, any2mf_4banks_map["banks"][curr_bank][e], v)
					else
						send_midi(vdev, 3, MIDI_NOTE_OFF, any2mf_4banks_map["banks"][curr_bank][e], 127)
					end
				end
			end)

			-- route bank select buttons back from mf - led feedback

			if any2mf_4banks_map["select"][btn] ~= nil then
				capture(vdev, any2mf_4banks_map["select"][btn]["note"], ALL, 0, function(d, e, v, p)
					if mf2any_4banks_map[e] ~= nil then
						if v == 0 then
							if type(off_color) == "number" then
								send(rdev, mf2any_4banks_map[e], off_color, rdevpage)
							elseif type(off_color) == "table" then
								send(rdev, mf2any_4banks_map[e], off_colors[mf2any_4banks_map[e]], rdevpage)
							end
						else
							send(rdev, mf2any_4banks_map[e], on_color, rdevpage)
						end
					end
				end)
			end

			-- route bank buttons back from mf - led feedback

			for bank=1,4 do
				if any2mf_4banks_map["banks"][bank][btn] ~= nil then
					capture(vdev, any2mf_4banks_map["banks"][bank][btn], ALL, 0, function(d, e, v, p)
						if mf2any_4banks_map[e] ~= nil then
							if v == 0 then
								if type(off_color) == "number" then
									send(rdev, mf2any_4banks_map[e], off_color, rdevpage)
								elseif type(off_color) == "table" then
									send(rdev, mf2any_4banks_map[e], off_colors[mf2any_4banks_map[e]], rdevpage)
								end
							else
								send(rdev, mf2any_4banks_map[e], on_color, rdevpage)
							end
						end
					end)
				end
			end
		end
	end

	-- bank 1 is default
	send(rdev, btns["0,0"], on_color, rdevpage)
end




