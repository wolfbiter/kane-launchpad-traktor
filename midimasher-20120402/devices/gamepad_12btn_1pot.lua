--
-- turn a gamepad with 12 buttons and an analogue pot into a 4x4 grid 
-- plus start+select button 
--

local d = get_current_device()

--
-- select + start
--

add_hid_control("select", "button", 6, 0x10)
add_hid_control("start", "button", 6, 0x20)

--
-- it looks like bytes 1 and 2 are for an analogue pot (untested)
--

add_hid_control("pot1x", "fader", 1, 0xff)
add_hid_control("pot1y", "fader", 2, 0xff)

--
-- turn the analgue pot into 4 buttons
-- value is 127 in the middle, 0 at min, 255 at max
-- the pot1x and pot1y events can be used instead of these as faders
--

superfader(d, "pot1x", 0, 0, 0, "0,0", ON, ON)
superfader(d, "pot1y", 0, 0, 0, "0,1", ON, ON)
superfader(d, "pot1x", 0, 255, 255, "0,2", ON, ON)
superfader(d, "pot1y", 0, 255, 255, "0,3", ON, ON)

--
-- direction buttons act as faders even on digital gamepads
--

add_hid_control("left_right", "fader", 3, 0xff)
add_hid_control("up_down", "fader", 4, 0xff)

--
-- turn left_right and up_down controls into separate buttons
-- value is 127 in the middle, 0 at min, 255 at max
--

superfader(d, "left_right", 0, 0, 0, "1,0", ON, ON)
superfader(d, "up_down", 0, 0, 0, "1,1", ON, ON)
superfader(d, "left_right", 0, 255, 255, "1,2", ON, ON)
superfader(d, "up_down", 0, 255, 255, "1,3", ON, ON)

--
-- right hand buttons 4,1,2,3
--

add_hid_control("2,0", "button", 5, 0x10)
add_hid_control("2,1", "button", 5, 0x20)
add_hid_control("2,2", "button", 5, 0x40)
add_hid_control("2,3", "button", 5, 0x80)

--
-- shoulder buttons, left1, left2, right1, right2
--

add_hid_control("3,0", "button", 6, 0x01)
add_hid_control("3,1", "button", 6, 0x02)
add_hid_control("3,2", "button", 6, 0x04)
add_hid_control("3,3", "button", 6, 0x08)

