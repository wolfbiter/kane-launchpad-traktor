-------------------------------------------------------------------------------
-- connect devices
-------------------------------------------------------------------------------

-- embed a scrollable grid within page 1 of the lp, and link this grid
-- to a lpd8 so we can see the events in both directions via pad leds

open_midi_device("lp", "launchpad", "Launchpad", "Launchpad", 4)
open_midi_device("mf1", "generic", "V:MidiFighter1 Input", "V:MidiFighter1 Output")

attach_midi_subdevice("lp", grid("0,0", "7,7"), 1, "grid", 1, "grid_64x16")
enable_launchpad_led_fix("lp", 1)

set_device_route("grid", "mf1")
set_device_route_status("grid", true)

set_device_route("mf1", "grid")
set_device_route_status("mf1", true)

launchpad.init("lp")

-- 4 buttons to scroll the grid

pipe_modifier("lp", "down", 1, lp_hi_yellow, lp_lo_yellow, nil, function(d,e,v,p)
	if v > 0 then
		launchpad.inc_offset("grid", 1, 0, "lp")
	end
end)

pipe_modifier("lp", "up", 1, lp_hi_yellow, lp_lo_yellow, nil, function(d,e,v,p)
	if v > 0 then
		launchpad.inc_offset("grid", -1, 0, "lp")
	end
end)

pipe_modifier("lp", "right", 1, lp_hi_yellow, lp_lo_yellow, nil, function(d,e,v,p)
	if v > 0 then
		launchpad.inc_offset("grid", 0, 1, "lp")
	end
end)

pipe_modifier("lp", "left", 1, lp_hi_yellow, lp_lo_yellow, nil, function(d,e,v,p)
	if v > 0 then
		launchpad.inc_offset("grid", 0, -1, "lp")
	end
end)

-- light up some colors on the grid so we can see it scrolling

hold_modifier("grid", "0,0", 0, lp_hi_yellow, lp_lo_red)
toggle_modifier("grid", "1,7", 0, lp_hi_yellow, lp_lo_yellow)
hold_modifier("grid", "6,2", 0, lp_hi_yellow, lp_lo_green)
toggle_modifier("grid", "10,10", 0, lp_hi_yellow, lp_lo_amber)
hold_modifier("grid", "2,1", 0, lp_hi_yellow, lp_lo_green)
toggle_modifier("grid", "5,8", 0, lp_hi_yellow, lp_lo_yellow)
hold_modifier("grid", "6,9", 0, lp_hi_yellow, lp_lo_red)
toggle_modifier("grid", "3,4", 0, lp_hi_yellow, lp_lo_red)





