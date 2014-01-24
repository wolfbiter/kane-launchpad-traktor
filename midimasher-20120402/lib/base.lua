--
-- Function             Toggled   Target   Local     Ignore Src   Routing
--                                         Led Set   Off Events
--
-- pipe()               no        device   no        no           A ---> B
-- join()               no        device   no        no           A <--> B
--
-- trigger()            no        device   yes       yes          A ---> B
-- button()             no        device   yes       no           A <--> B
-- button_shift()       no        device   yes       no           A ---> B
-- toggle()             yes       devicw   yes       no           A <--> B
--
-- pipe_modifier()      no        var      yes       no           A ---> V
-- hold_modifier()      no        var      yes       no           A <--> V
-- toggle_modifier()    yes       var      yes       no           A <--> V
--
-- send_midi(device, channel, type, value, velocity)
--  where type is one of MIDI_NOTE_ON, MIDI_NOTE_OFF, MIDI_CC, MIDI_PC



---1 pipe()
--
-- send an event to an output device when a specified event is received by the input device
--
---2 Usage
--
--  pipe(d1, e1, p1, d2, e2, p2, [cb])
--  pipe(d1, e1, p1, d2, e2, p2, scale, [cb])
--
-- param: d1 device name in
-- param: e1 event name(s) in
-- param: p1 page, use 0 for all pages in
-- param: d2 device name out
-- param: e2 event name out
-- param: p2 page out
-- param: scale scaling to be applied to input values
-- param: cb callback function (optional)
--
---2 Examples
--
--  pipe("launchpad", "0,0", 0, "traktor", "cue_a", 0)
--
--  pipe("launchpad", "0,0", 0, "traktor", "cue_a", 0, function(d, e, v, p)
--    print("sending cue_a message to traktor with value of" .. v)
--  end)
--
---

function pipe(d1, e1, p1, d2, e2, p2, scale, cb)

	if type(scale) == "function" then
		cb = scale
		scale = 1
	elseif type(scale) == "nil" then
		scale = 1
	end

	return route{
		device = d1,
		event = e1,
		page = p1,
		tdevice = d2,
		tevent = e2,
		tpage = p2,
		mode = HOLD,
		duplex = false,
		scale = scale,
		callback = cb
	}
end

---1 join()
--
-- duplex version of pipe()
--
---

function join(d1, e1, p1, d2, e2, p2, cb)
	return route{
		device = d1,
		event = e1,
		page = p1,
		tdevice = d2,
		tevent = e2,
		tpage = p2,
		mode = HOLD,
		duplex = true,
		callback = cb
	}
end

---1 trigger()
--
-- only send non-zero events onto target device, set local led colors
--
---2 Usage
--
--  trigger(d1, e1, p1, on_color, off_color, d2, e2, p2, [cb])
--
-- param: d1 device name in
-- param: e1 event name(s) in
-- param: p1 page, use 0 for all pages in
-- param: on_color local led on color
-- param: off_color local led off color
-- param: d2 device name out
-- param: e2 event name out
-- param: p2 page out
-- param: cb callback function (optional)
--
---

function trigger(d1, e1, p1, on_color, off_color, d2, e2, p2, cb)
	return route{
		device = d1,
		event = e1,
		page = p1,
		tdevice = d2,
		tevent = e2,
		tpage = p2,
		mode = TRIGGER,
		duplex = false,
		on_color = on_color,
		off_color = off_color,
		callback = cb
	}
end

---1 C<lpd8_trigger()>
--
-- the same as trigger() with these two additions:
--
--fix for the problem where the lpd8 led turns off when u release the pad even tho a midi message may have been sent to it to turn it on
--
--send an OFF message 3ms after the ON so that the lpd8 PC mode pads can also be used
--
---

function lpd8_trigger(d1, e1, p1, on_color, off_color, d2, e2, p2, cb)
	return route{
		device = d1,
		event = e1,
		page = p1,
		tdevice = d2,
		tevent = e2,
		tpage = p2,
		mode = TRIGGER,
		lpd8_fix = true,
		duplex = false,
		on_color = on_color,
		off_color = off_color,
		callback = cb
	}
end

---1 button()
--
-- similar to C<pipe()> but with local led colors
--
---2 Usage
--
--  button(d1, e1, p1, on_color, off_color, d2, e2, p2, [cb])
--
-- param: d1 device name in
-- param: e1 event name(s) in
-- param: p1 page, use 0 for all pages in
-- param: on_color local led on color
-- param: off_color local led off color
-- param: d2 device name out
-- param: e2 event name out
-- param: p2 page out
-- param: cb callback function (optional)
--
---

function button(d1, e1, p1, on_color, off_color, d2, e2, p2, cb)
	return route{
		device = d1,
		event = e1,
		page = p1,
		tdevice = d2,
		tevent = e2,
		tpage = p2,
		mode = HOLD,
		duplex = true,
		on_color = on_color,
		off_color = off_color,
		callback = cb
	}
end

---1 toggle()
--
-- same as C<button()> but with toggle behaviour
--
---2 Usage
--
--  toggle(d1, e1, p1, on_color, off_color, d2, e2, p2, [cb])
--
-- param: d1 device name in
-- param: e1 event name(s) in
-- param: p1 page, use 0 for all pages in
-- param: on_color local led on color
-- param: off_color local led off color
-- param: d2 device name out
-- param: e2 event name out
-- param: p2 page out
-- param: cb callback function (optional)
--
-- return value is the name of the modifier being used to store the current I<toggle> status
--
---

function toggle(d1, e1, p1, on_color, off_color, d2, e2, p2, cb)
	return route{
		device = d1,
		event = e1,
		page = p1,
		tdevice = d2,
		tevent = e2,
		tpage = p2,
		mode = TOGGLE,
		duplex = true,
		on_color = on_color,
		off_color = off_color,
		callback = cb
	}
end

---1 hold_modifier()
--
-- sets a value that can be accessed via C<get()> when pressed instead of sending any data onto another device
--
-- duplex, so if the modifier is changed via any other device/code then the local led status will reflect it
--
---2 Usage
--
--  hold_modifier(d1, e1, p1, on_color, off_color, name, [cb])
--
-- param: d1 device name in
-- param: e1 event name(s) in
-- param: p1 page, use 0 for all pages in
-- param: on_color local led on color
-- param: off_color local led off color
-- param: name the name for the modifier
-- param: cb callback function (optional)
--
---2 Examples
--
--   hold_modifier("lpd8", "0,0", 1, 127, 0, "shift")
--   my_val = get("shift")
--   set("shift", 127)
--   set("shift", 0)
--
---

function hold_modifier(d1, e1, p1, on_color, off_color, name, cb)
	return route{
		device = d1,
		event = e1,
		page = p1,
		mode = HOLD,
		duplex = true,
		on_color = on_color,
		off_color = off_color,
		cache = name,
		callback = cb
	}
end

---1 toggle_modifier()
--
-- same as C<hold_modifier()> but with toggle behaviour
--
---

function toggle_modifier(d1, e1, p1, on_color, off_color, cache, cb)
	return route{
		device = d1,
		event = e1,
		page = p1,
		mode = TOGGLE,
		duplex = true,
		on_color = on_color,
		off_color = off_color,
		cache = cache,
		lpd8_fix = true,
		callback = cb
	}
end

---1 pipe_modifier()
--
-- same as C<hold_modifier()> but with non-duplex
--
---

function pipe_modifier(d1, e1, p1, on_color, off_color, name, cb)
	return route{
		device = d1,
		event = e1,
		page = p1,
		mode = HOLD,
		duplex = false,
		on_color = on_color,
		off_color = off_color,
		cache = name,
		callback = cb
	}
end

---1 button_shift()
--
-- behaves like C<button()> but varies the output event based on the current status of a modifier allowing a button to have a different behaviour when another button is pressed like sending "tempo_bend_down_a" as opposed to "tempo_bend_up_a"
--
-- it also has 2 additional I<inline> callbacks that if set must return the value to be sent out, C<cb1> is called if the modifier is not set and C<cb2> if it is
--
---2 Usage
--
--  button_shift(d1, e1, p1, on_color, off_color, d2, e2, e2s, shift, p2)
--
-- param: d1 device name in
-- param: e1 event name(s) in
-- param: p1 page, use 0 for all pages in
-- param: on_color local led on color
-- param: off_color local led off color
-- param: d2 device name out
-- param: e2 event name out when shift not pressed
-- param: e2s event name out when shift is pressed
-- param: shift the name of the modifier
-- param: p2 page out
-- param: cb callback called after each event (optional, default C<nil>)
-- param: cb1 callback that is called B<before> sending out the value when shift is not set (optional, default C<nil>)
-- param: cb2 callback that is called B<before> sending out the value when shift is set (optional, default C<nil>)
--
---2 Examples
--
--  -- first create a shift control that will set "myshift" on the "arm" 
--  -- of the launchpad
--
--  hold_modifier("lp", "arm", 0, lp_hi_yellow, lp_lo_red, "myshift")
--
--  -- now add a dual function control (at row 0, column 3) on the same controller
--  -- that will send "tempo_bend_up_a" to traktor, unless the shift button has 
--  -- been held down, in which case it will send "tempo_bend_down_a"
--
--  button_shift("lp", "0,3", 1, lp_hi_yellow, lp_lo_red, "traktor", "tempo_bend_up_a", "tempo_bend_down_a", "myshift")
--
---

function button_shift(d1, e1, p1, on_color, off_color, d2, e2, e2s, shift, p2, cb, cb1, cb2)

	if p2 == nil then p2 = 0 end

	capture(d1, e1, ALL, p1, function(d, e, v, p)
		if get(shift) > 0 then
			if cb2 ~= nil then
				v = call(cb2, d, e, v, p)
			end
			send(d2, e2s, v, p2)
		else
			if cb1 ~= nil then
				v = call(cb2, d, e, v, p)
			end
			send(d2, e2, v, p2)
		end
		if v > 0 then
			send(d1, e1, on_color, p1)
		else
			send(d1, e1, off_color, p1)
		end
		if cb ~= nil then
			call(cb, d, e, v, p)
		end
	end)

	send(d1, e1, off_color, p1)
end

---1 pipe_shift()
--
-- behaves like C<pipe()> but varies the output based on a shift the same as C<button_shift()>
--
-- this could be used to enable fader fx for example like on the twitch by using the fader to control an effects param when a "fader_fx" shift is toggled on
-- and inverting the value passed through so that the effects level is at max when the fader is at minimum
--
---2 Usage
--
--  pipe_shift(d1, e1, p1, d2, e2, e2s, shift, p2, cb, cb1, cb2)
--
-- param: d1 device name in
-- param: e1 event name(s) in
-- param: p1 page, use 0 for all pages in
-- param: d2 device name out
-- param: e2 event name out when shift not pressed
-- param: e2s event name out when shift is pressed
-- param: shift the name of the modifier
-- param: p2 page out (optional, default 0)
-- param: cb callback called after each event (optional, default C<nil>)
--
-- the C<cb> param can either be a single function that gets called after each event or a C<table> that defines up to 3 callbacks
--
--   cb = function1
--
-- or
--
--   { cb = function1, cb_shift = function2, cb_noshift = function3 }
--
-- C<cb_shift> gets called only when the modifier is non zero and C<cb_noshift> gets called when the modifer is zero.
-- each is called B<before> the value is sent out to the target device and the function must return what value is to be sent
--
---2 Examples
--
-- first create two toggle buttons that will enable fader effects mode for decks a+b independantly and enable/disable the effects unit
--
--  faderfx_a = toggle_modifier("djm101", "pfl_a", 0, ON, OFF, nil, function(d, e, v, p)
--      if v > 0 then send("traktor", "dry_wet_group_unit_1", 0) end
--      send("traktor", "effect_unit_1_on_a", v)
--  end)
--
--  faderfx_b = toggle_modifier("djm101", "pfl_b", 0, ON, OFF, nil, function(d, e, v, p)
--      if v > 0 then send("traktor", "dry_wet_group_unit_1", 0) end
--      send("traktor", "effect_unit_1_on_b", v)
--  end)
--
-- use a fader to control deck levels as normal when the toggle is not engaged. when the toggle is set switch to
-- controlling the effects unit dry/wet parameter but inverted so that the effect will be at full wet when the 
-- fader is at minimum
--
--  pipe_shift("djm101", "volume_fader_a", 0, "traktor", "volume_fader_a", "dry_wet_group_unit_1", faderfx_a, 0, { cb_shift = invert_value_cb})
--  pipe_shift("djm101", "volume_fader_b", 0, "traktor", "volume_fader_b", "dry_wet_group_unit_1", faderfx_b, 0, { cb_shift = invert_value_cb})
--
---

function pipe_shift(d1, e1, p1, d2, e2, e2s, shift, p2, _cb)

	if p2 == nil then p2 = 0 end
	local cb = nil
	local cb1 = nil
	local cb2 = nil

	if type(_cb) == "table" then
		if _cb.cb ~= nil then
			cb = _cb.cb
		end
		if _cb.cb_noshift ~= nil then
			cb1 = _cb.cb_noshift
		end
		if _cb.cb_shift ~= nil then
			cb2 = _cb.cb_shift
		end
	else
		cb = _cb
	end

	capture(d1, e1, ALL, p1, function(d, e, v, p)

		if get(shift) > 0 then
			if cb2 ~= nil then
				_, v = call(cb2, d, e, v, p)
			end
			send(d2, e2s, v, p2)
		else
			if cb1 ~= nil then
				_, v = call(cb1, d, e, v, p)
			end
			send(d2, e2, v, p2)
		end
		if cb ~= nil then
			call(cb, d, e, v, p)
		end
	end)
end