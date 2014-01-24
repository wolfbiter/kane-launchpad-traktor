launchpad = {}
launchpad.traktor_sync_enabled = false
launchpad.flash_status = 0
launchpad.enable_flashing_colors = true

-- color definitions (set copy bit for non flashing colors)

launchpad.black = 4

launchpad.lo_red = 1 + 4
launchpad.mi_red = 2 + 4
launchpad.hi_red = 3 + 4
launchpad.lo_green = 16 + 4
launchpad.mi_green = 32 + 4
launchpad.hi_green = 48 + 4
launchpad.lo_amber = 17 + 4
launchpad.mi_amber = 34 + 4
launchpad.hi_amber = 51 + 4
launchpad.hi_orange = 35 + 4
launchpad.lo_orange = 18 + 4
launchpad.hi_yellow = 50 + 4
launchpad.lo_yellow = 33 + 4

launchpad.flash_lo_red = 1
launchpad.flash_mi_red = 2
launchpad.flash_hi_red = 3
launchpad.flash_lo_green = 16
launchpad.flash_mi_green = 32
launchpad.flash_hi_green = 48
launchpad.flash_lo_amber = 17
launchpad.flash_mi_amber = 34
launchpad.flash_hi_amber = 51
launchpad.flash_hi_orange = 35
launchpad.flash_lo_orange = 18
launchpad.flash_hi_yellow = 50
launchpad.flash_lo_yellow = 33

launchpad.flash_red = 11
launchpad.flash_amber = 59
launchpad.flash_yellow = 58
launchpad.flash_green = 56

launchpad.flashing_off_color = launchpad.black

-- color definitions (for old code)

lp_black = 4

lp_lo_red = 1 + 4
lp_mi_red = 2 + 4
lp_hi_red = 3 + 4
lp_lo_green = 16 + 4
lp_mi_green = 32 + 4
lp_hi_green = 48 + 4
lp_lo_amber = 17 + 4
lp_mi_amber = 34 + 4
lp_hi_amber = 51 + 4
lp_hi_orange = 35 + 4
lp_lo_orange = 18 + 4
lp_hi_yellow = 50 + 4
lp_lo_yellow = 33 + 4

lp_flash_lo_red = 1
lp_flash_mi_red = 2
lp_flash_hi_red = 3
lp_flash_lo_green = 16
lp_flash_mi_green = 32
lp_flash_hi_green = 48
lp_flash_lo_amber = 17
lp_flash_mi_amber = 34
lp_flash_hi_amber = 51
lp_flash_hi_orange = 35
lp_flash_lo_orange = 18
lp_flash_hi_yellow = 50
lp_flash_lo_yellow = 33

lp_flash_red = 11
lp_flash_amber = 59
lp_flash_yellow = 58
lp_flash_green = 56

---------------------------------------------------------------------------------
-- device reset
---------------------------------------------------------------------------------

function launchpad.reset(d)
	send_midi_raw(d, 0xb0, 0, 0)
end

---------------------------------------------------------------------------------
-- test led's, reset device and enabling flashing colors
---------------------------------------------------------------------------------

function launchpad.init(d, enable_flashing_colors)

	--
	-- test each led
	--

	local colors = { launchpad.hi_green, launchpad.hi_red, launchpad.hi_yellow, launchpad.black }
	local buttons = { 
						"up", "down", "left", "right", "session", "user1", "user2", "mixer",
						"vol", "pan", "snda", "sndb", "stop", "trkon", "solo", "arm"
					}

	for row = 0, 7 do
		for col = 0, 7 do
			for _, c in ipairs(colors) do
        send(d, row..","..col, c)
			end
		end
	end

	for _, btn in ipairs(buttons) do
		for _, c in ipairs(colors) do
      send(d, btn, c)
		end
	end

	--
	-- reset the device
	--

	launchpad.reset(d)

	if enable_flashing_colors == nil or enable_flashing_colors then

		launchpad.enable_flashing_colors = true

		--
		-- enable the use of flashing led colors
		--

		launchpad.flash_enable(d)

		--
		-- OFF needs to be 4 and not just 0, so both lp buffers are cleared
		-- always use launchpad.black or lp_black instead of OFF to turn a pad off
		--

		reset_refresh_cache(d, launchpad.black)
	else
		launchpad.enable_flashing_colors = false
	end
end

---------------------------------------------------------------------------------
-- page change function that ensures flashing leds are refreshed properly
---------------------------------------------------------------------------------

function launchpad.set_page(d, p, parent)

	--
	-- set the new page, but don't let the generic code send out any led updates
	--

	set_page(d, p, false)
	launchpad.refresh_page(d, parent)
end

function launchpad.inc_offset(d, r, c, parent)
	inc_offset(d, r, c, false)
	launchpad.refresh_page(d, parent)
end

function launchpad.refresh_page(d, parent)

	local num = get_num_page_refresh_events(d)
	local flashing = {}

	if num > 0 then

		--
		-- select buf1 so our updates don't get shown
		--

		launchpad.select_buffer1(d)

		--
		-- iterate through the led updates
		--

		for i=1,num do

			--
			-- get the next update event
			--

			local chan, typ, val, vel = get_page_refresh_event(d, i)

			--
			-- 0 makes no sense - needs to be 4 for black/off
			--

			if vel == 0 then
				vel = 4
			end

			if bitwise_and(vel, 0x4) > 0 then

				--
				-- copy bit is set, a non-flashing color, remove the copy bit and send
				--

				local vel = bitwise_and(vel, 0xfb)
				send_midi(d, chan, typ, val, bitwise_and(vel, 0x3f), false)

			else
				--
				-- copy bit not set, a flashing color, send out black and make a note of it
				--

				send_midi(d, chan, typ, val, launchpad.flashing_off_color, false)
				flashing[#flashing+1] = {chan, typ, val, vel}
			end

			--
			-- if we are a sub-device set parents cache with copy bit left set or unset
			-- code above will have sent out the correct led values to the launchpad but now
			-- the parent device will have incorrect values causing leds to flash when they
			-- shouldn't be when we change the main pages
			--

			if parent ~= nil then
				set_parent_cache(d, chan, typ, val, vel)
			end
		end

		--
		-- refresh any parent device flashing led's as they'll have been nuked otherwise 
		--


		if parent ~= nil then

			-- this now queues up all midi data for the parent device
			refresh_page(parent) 

			-- only interested in flashing leds from the parent device
			num = get_num_page_refresh_events(parent);
			if num > 0 then
				for i=1,num do
					local chan, typ, val, vel = get_page_refresh_event(parent, i)
					if bitwise_and(vel, 0x4) == 0 then
						send_midi(parent, chan, typ, val, launchpad.flashing_off_color, false)
						flashing[#flashing+1] = {chan, typ, val, vel}
					end
				end
			end
		end

		--
		-- flip to buffer0 which will display all our updates in one hit
		--

		launchpad.select_buffer0(d)

		--
		-- send out any flashing led updates (to a single buffer)
		--

		for _, f in ipairs(flashing) do
			send_midi(d, f[1], f[2], f[3], bitwise_and(f[4], 0x3f), false)
		end

		--
		-- re-enable internal flashing cycle if not synching to traktor
		--

		if launchpad.traktor_sync_enabled == false and launchpad.enable_flashing_colors then
			launchpad.flash_enable(d)
		end
	end
end

---------------------------------------------------------------------------------
-- set the off color for flashing leds
---------------------------------------------------------------------------------

function launchpad.flash_set_off_color(c)
	launchpad.flashing_off_color = bitwise_and(c, 0xfb)
end

---------------------------------------------------------------------------------
-- enable flashing using launchpad set frequency
---------------------------------------------------------------------------------

function launchpad.flash_enable(d)
	send_midi_raw(d, 0xb0, 0x0, 0x28)
end

---------------------------------------------------------------------------------
-- turn on any led set for flashing
---------------------------------------------------------------------------------

function launchpad.flash_on(d)
	send_midi_raw(d, 0xb0, 0x0, 0x21)
end

---------------------------------------------------------------------------------
-- turn off any led set for flashing
---------------------------------------------------------------------------------

function launchpad.flash_off(d)
	send_midi_raw(d, 0xb0, 0x0, 0x20)
end

---------------------------------------------------------------------------------
-- select buffer 1 for display allowing us to update buffer 0
---------------------------------------------------------------------------------

function launchpad.select_buffer1(d)
	send_midi_raw(d, 0xb0, 0x0, 0x31)
end

---------------------------------------------------------------------------------
-- select buffer 0 for display which will copy automatically to buffer 1
---------------------------------------------------------------------------------

function launchpad.select_buffer0(d)
	send_midi_raw(d, 0xb0, 0x0, 0x34)
end

---------------------------------------------------------------------------------
-- sync flashing leds to traktors beats
---------------------------------------------------------------------------------

function launchpad.traktor_sync(d)

	launchpad.traktor_sync_enabled = true

	--
	-- use the master clock beats to enable/disable our flashing leds
	--

	capture("_global", "beat", NOFF, 0, function(d, e, v, p)
		if launchpad.flash_status == 0 then
			launchpad.flash_off("lp")
			launchpad.flash_status = 1
		else
			launchpad.flash_on("lp")
			launchpad.flash_status = 0
		end
	end)
end

---------------------------------------------------------------------------------
-- set the contrast/palette 
---------------------------------------------------------------------------------

function launchpad.set_contrast(d, num, den)
	if num < 1 then 
		num = 1
	elseif num > 16 then 
		num = 16
	end

	if den < 3 then 
		den = 3
	elseif den > 18 then 
		den = 18
	end

	if num < 9 then
		send_midi_raw(d, 0xb0, 0x1e, (0x10 * (num-1)) + (den-3))
	else
		send_midi_raw(d, 0xb0, 0x1f, (0x10 * (num-9)) + (den-3))
	end
end


