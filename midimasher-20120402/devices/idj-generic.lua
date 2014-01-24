-- central 4x2 grid buttons

add_grid_control(0, 0, 1, "note", 85)
add_grid_control(1, 0, 1, "note", 88)
add_grid_control(2, 0, 1, "note", 91)
add_grid_control(3, 0, 1, "note", 76)
add_grid_control(0, 1, 1, "note", 78)
add_grid_control(1, 1, 1, "note", 79)
add_grid_control(2, 1, 1, "note", 82)
add_grid_control(3, 1, 1, "note", 83)

-- central controls

add_control("crossfader", 1, "cc", 8)
add_control("fader1", 1, "cc", 84)
add_control("fader1_reset", 1, "note", 1)
add_control("fader2", 1, "cc", 86)
add_control("fader2_reset", 1, "note", 3)
add_control("fader3", 1, "cc", 85)
add_control("fader3_reset", 1, "note", 2)
add_control("fader4", 1, "cc", 87)
add_control("fader4_reset", 1, "note", 4)

-- other faders - central - then left to right

add_control("fader5", 1, "cc", 30)
add_control("fader5_reset", 1, "note", 22)
add_control("fader6", 1, "cc", 20)
add_control("fader6_reset", 1, "note", 14)
add_control("fader7", 1, "cc", 21)
add_control("fader7_reset", 1, "note", 15)
add_control("fader8", 1, "cc", 23)
add_control("fader8_reset", 1, "note", 17)
add_control("fader9", 1, "cc", 28)
add_control("fader9_reset", 1, "note", 24)

add_control("fader10", 1, "cc", 29)
add_control("fader10_reset", 1, "note", 25)
add_control("fader11", 1, "cc", 24)
add_control("fader11_reset", 1, "note", 18)
add_control("fader12", 1, "cc", 25)
add_control("fader12_reset", 1, "note", 19)
add_control("fader13", 1, "cc", 27)
add_control("fader13_reset", 1, "note", 21)
add_control("fader14", 1, "cc", 31)
add_control("fader14_reset", 1, "note", 23)

-- deck a

add_control("loop_out_a", 1, "note", 50)
add_control("loop_in_a", 1, "note", 52)
add_control("cue_a", 1, "note", 51)
add_control("play_a", 1, "note", 70)
add_control("sync_a", 1, "note", 101)
add_control("loop_left_a", 1, "note", 102)
add_control("loop_right_a", 1, "note", 66)
add_control("pitch_a", 1, "cc", 14)
add_control("pitch_reset_a", 1, "note", 12)
add_control("fader_a", 1, "cc", 12)

-- deck b

add_control("cue_b", 1, "note", 71)
add_control("play_b", 1, "note", 55)
add_control("sync_b", 1, "note", 103)
add_control("loop_left_b", 1, "note", 104)
add_control("loop_right_b", 1, "note", 67)
add_control("loop_out_b", 1, "note", 56)
add_control("loop_in_b", 1, "note", 54)
add_control("fader_b", 1, "cc", 13)

-- jog wheels

add_control("jog_a", 1, "cc", 18)
add_control("jog_b", 1, "cc", 19)
add_control("scratch_a", 1, "cc", 16)
add_control("scratch_b", 1, "cc", 17)
add_control("touch_jog_a", 1, "note", 46)
add_control("stop_spinning_jog_a", 1, "note", 48)
add_control("touch_jog_b", 1, "note", 47)
add_control("stop_spinning_jog_b", 1, "note", 49)
add_control("pitch_bend_down_a", 1, "note", 59)
add_control("pitch_bend_up_a", 1, "note", 58)
add_control("pitch_bend_down_b", 1, "note", 61)
add_control("pitch_bend_up_b", 1, "note", 60)
