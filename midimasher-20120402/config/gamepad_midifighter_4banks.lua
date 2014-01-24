open_hid_device("gp", "gamepad_12btn", "USB Gamepad")
open_midi_device("mf1", "generic", "MidiFighter1 Input", "MidiFighter1 Output")
virtual_midifighter_4banks("gp", 0, "mf1", 0, 0)

