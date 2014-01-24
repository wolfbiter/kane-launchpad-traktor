--
-- turn a gamepad with 12 buttons into a virtual grid of 4,4
-- with 0,2 and 0,3 missing
-- hint: useful to emulate a midi fighter in 4banks mode for banks 1 and 2
--

--
-- select + start
--

add_hid_control("0,0", "button", 6, 0x10)
add_hid_control("0,1", "button", 6, 0x20)

--
-- direction buttons act as faders even on digital gamepads
--

add_hid_control("left_right", "fader", 3, 0xff)
add_hid_control("up_down", "fader", 4, 0xff)

--
-- turn left_right and up_down controls into separate buttons
-- value is 127 in the middle, 0 at min, 255 at max
--

local d = get_current_device()

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

