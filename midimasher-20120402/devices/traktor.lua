-- transport decks a+b

add_control("play_a",							1, "cc", 0);
add_control("cue_a",							1, "cc", 1);
add_control("cup_a",							1, "cc", 2);
add_control("seek_enc_a",						1, "cc", 3);
add_control("scratch_on_a",						1, "cc", 4);
add_control("scratch_on_direct_a",				1, "cc", 5);
add_control("scratch_a",						1, "cc", 12);
add_control("jog_scratch_tempo_bend_a",			1, "cc", 14);

add_control("play_b",							1, "cc", 6);
add_control("cue_b",							1, "cc", 7);
add_control("cup_b",							1, "cc", 8);
add_control("seek_enc_b",						1, "cc", 9);
add_control("scratch_on_b",						1, "cc", 10);
add_control("scratch_on_direct_b",				1, "cc", 11);
add_control("scratch_b",						1, "cc", 13);
add_control("jog_scratch_tempo_bend_b",			1, "cc", 15);

-- cue / loops

add_control("loop_in_set_cue_a",				1, "cc", 16);
add_control("loop_in_set_cue_b",				1, "cc", 17);
add_control("loop_out_a",						1, "cc", 18);
add_control("loop_out_b",						1, "cc", 19);
add_control("cue_set_store_a",					1, "cc", 20);
add_control("cue_set_store_b",					1, "cc", 21);
add_control("store_cue_loop_a",					1, "cc", 22);
add_control("store_cue_loop_b",					1, "cc", 23);
add_control("delete_cue_loop_a",				1, "cc", 24);
add_control("delete_cue_loop_b",				1, "cc", 25);

add_control("loop_size_inc_a",					1, "cc", 26);
add_control("loop_size_inc_b",					1, "cc", 27);
add_control("loop_size_dec_a",					1, "cc", 28);
add_control("loop_size_dec_b",					1, "cc", 29);

add_control("loop_size_set_/32_a",				1, "cc", 30);
add_control("loop_size_set_/16_a",				1, "cc", 31);
add_control("loop_size_set_/8_a",				1, "cc", 32);
add_control("loop_size_set_/4_a",				1, "cc", 33);
add_control("loop_size_set_/2_a",				1, "cc", 34);
add_control("loop_size_set_1_a",				1, "cc", 35);
add_control("loop_size_set_2_a",				1, "cc", 36);
add_control("loop_size_set_4_a",				1, "cc", 37);
add_control("loop_size_set_8_a",				1, "cc", 38);
add_control("loop_size_set_16_a",				1, "cc", 39);
add_control("loop_size_set_32_a",				1, "cc", 40);

add_control("loop_size_set_/32_b",				1, "cc", 41);
add_control("loop_size_set_/16_b",				1, "cc", 42);
add_control("loop_size_set_/8_b",				1, "cc", 43);
add_control("loop_size_set_/4_b",				1, "cc", 44);
add_control("loop_size_set_/2_b",				1, "cc", 45);
add_control("loop_size_set_1_b",				1, "cc", 46);
add_control("loop_size_set_2_b",				1, "cc", 47);
add_control("loop_size_set_4_b",				1, "cc", 48);
add_control("loop_size_set_8_b",				1, "cc", 49);
add_control("loop_size_set_16_b",				1, "cc", 50);
add_control("loop_size_set_32_b",				1, "cc", 51);

add_control("loop_set_a",						1, "cc", 52);
add_control("loop_set_b",						1, "cc", 53);
add_control("loop_active_a",					1, "cc", 54);
add_control("loop_active_b",					1, "cc", 55);

add_control("loop_size_encoder_a",				1, "cc", 56);
add_control("loop_size_encoder_b",				1, "cc", 57);
add_control("loop_size_a",						1, "cc", 58);
add_control("loop_size_b",						1, "cc", 59);

add_control("cue_loop_move_size_inc_a",			1, "cc", 60);
add_control("cue_loop_move_size_dec_a",			1, "cc", 61);
add_control("cue_loop_move_size_inc_b",			1, "cc", 62);
add_control("cue_loop_move_size_dec_b",			1, "cc", 63);

add_control("cue_loop_move_size_beatjump_a",	1, "cc", 64);
add_control("cue_loop_move_size_loop_a",		1, "cc", 65);
add_control("cue_loop_move_size_loop_in_a",		1, "cc", 66);
add_control("cue_loop_move_size_loop_out_a",	1, "cc", 67);

add_control("cue_loop_move_size_beatjump_b",	1, "cc", 68);
add_control("cue_loop_move_size_loop_b",		1, "cc", 69);
add_control("cue_loop_move_size_loop_in_b",		1, "cc", 70);
add_control("cue_loop_move_size_loop_out_b",	1, "cc", 71);

add_control("cue_loop_move_back_a",				1, "cc", 72);
add_control("cue_loop_move_forward_a",			1, "cc", 73);
add_control("cue_loop_move_back_b",				1, "cc", 74);
add_control("cue_loop_move_forward_b",			1, "cc", 75);

add_control("next_prev_cue_loop_previous_a",	1, "cc", 76);
add_control("next_prev_cue_loop_next_a",		1, "cc", 77);
add_control("next_prev_cue_loop_previous_b",	1, "cc", 78);
add_control("next_prev_cue_loop_next_b",		1, "cc", 79);

add_control("jump_to_act_cue_a",				1, "cc", 80);
add_control("jump_to_act_cue_b",				1, "cc", 81);

add_control("map_hotcue_a",						1, "cc", 82);
add_control("map_hotcue_b",						1, "cc", 83);

add_control("select_set_store_hotcue_1_a",		1, "cc", 84);
add_control("select_set_store_hotcue_2_a",		1, "cc", 85);
add_control("select_set_store_hotcue_3_a",		1, "cc", 86);
add_control("select_set_store_hotcue_4_a",		1, "cc", 87);
add_control("select_set_store_hotcue_5_a",		1, "cc", 88);
add_control("select_set_store_hotcue_6_a",		1, "cc", 89);
add_control("select_set_store_hotcue_7_a",		1, "cc", 90);
add_control("select_set_store_hotcue_8_a",		1, "cc", 91);

add_control("select_set_store_hotcue_1_b",		1, "cc", 92);
add_control("select_set_store_hotcue_2_b",		1, "cc", 93);
add_control("select_set_store_hotcue_3_b",		1, "cc", 94);
add_control("select_set_store_hotcue_4_b",		1, "cc", 95);
add_control("select_set_store_hotcue_5_b",		1, "cc", 96);
add_control("select_set_store_hotcue_6_b",		1, "cc", 97);
add_control("select_set_store_hotcue_7_b",		1, "cc", 98);
add_control("select_set_store_hotcue_8_b",		1, "cc", 99);

add_control("delete_hotcue_1_a",				1, "cc", 100);
add_control("delete_hotcue_2_a",				1, "cc", 101);
add_control("delete_hotcue_3_a",				1, "cc", 102);
add_control("delete_hotcue_4_a",				1, "cc", 103);
add_control("delete_hotcue_5_a",				1, "cc", 104);
add_control("delete_hotcue_6_a",				1, "cc", 105);
add_control("delete_hotcue_7_a",				1, "cc", 106);
add_control("delete_hotcue_8_a",				1, "cc", 107);

add_control("delete_hotcue_1_b",				1, "cc", 108);
add_control("delete_hotcue_2_b",				1, "cc", 109);
add_control("delete_hotcue_3_b",				1, "cc", 110);
add_control("delete_hotcue_4_b",				1, "cc", 111);
add_control("delete_hotcue_5_b",				1, "cc", 112);
add_control("delete_hotcue_6_b",				1, "cc", 113);
add_control("delete_hotcue_7_b",				1, "cc", 114);
add_control("delete_hotcue_8_b",				1, "cc", 115);

add_control("beatjump_-loop_a",					2, "cc", 0);
add_control("beatjump_-32_a",					2, "cc", 1);
add_control("beatjump_-16_a",					2, "cc", 2);
add_control("beatjump_-8_a",					2, "cc", 3);
add_control("beatjump_-4_a",					2, "cc", 4);
add_control("beatjump_-2_a",					2, "cc", 5);
add_control("beatjump_-1_a",					2, "cc", 6);
add_control("beatjump_-/2_a",					2, "cc", 7);
add_control("beatjump_-/4_a",					2, "cc", 8);
add_control("beatjump_-/8_a",					2, "cc", 9);
add_control("beatjump_-/16_a",					2, "cc", 10);
add_control("beatjump_-fine_a",					2, "cc", 11);
add_control("beatjump_-ultrafine_a",			2, "cc", 12);

add_control("beatjump_+ultrafine_a",			2, "cc", 13);
add_control("beatjump_+fine_a",					2, "cc", 14);
add_control("beatjump_+/16_a",					2, "cc", 15);
add_control("beatjump_+/8_a",					2, "cc", 16);
add_control("beatjump_+/4_a",					2, "cc", 17);
add_control("beatjump_+/2_a",					2, "cc", 18);
add_control("beatjump_+1_a",					2, "cc", 19);
add_control("beatjump_+2_a",					2, "cc", 20);
add_control("beatjump_+4_a",					2, "cc", 21);
add_control("beatjump_+8_a",					2, "cc", 22);
add_control("beatjump_+16_a",					2, "cc", 23);
add_control("beatjump_+32_a",					2, "cc", 24);
add_control("beatjump_+loop_a",					2, "cc", 25);

add_control("beatjump_-loop_b",					2, "cc", 26);
add_control("beatjump_-32_b",					2, "cc", 27);
add_control("beatjump_-16_b",					2, "cc", 28);
add_control("beatjump_-8_b",					2, "cc", 29);
add_control("beatjump_-4_b",					2, "cc", 30);
add_control("beatjump_-2_b",					2, "cc", 31);
add_control("beatjump_-1_b",					2, "cc", 32);
add_control("beatjump_-/2_b",					2, "cc", 33);
add_control("beatjump_-/4_b",					2, "cc", 34);
add_control("beatjump_-/8_b",					2, "cc", 35);
add_control("beatjump_-/16_b",					2, "cc", 36);
add_control("beatjump_-fine_b",					2, "cc", 37);
add_control("beatjump_-ultrafine_b",			2, "cc", 38);

add_control("beatjump_+ultrafine_b",			2, "cc", 39);
add_control("beatjump_+fine_b",					2, "cc", 40);
add_control("beatjump_+/16_b",					2, "cc", 41);
add_control("beatjump_+/8_b",					2, "cc", 42);
add_control("beatjump_+/4_b",					2, "cc", 43);
add_control("beatjump_+/2_b",					2, "cc", 44);
add_control("beatjump_+1_b",					2, "cc", 45);
add_control("beatjump_+2_b",					2, "cc", 46);
add_control("beatjump_+4_b",					2, "cc", 47);
add_control("beatjump_+8_b",					2, "cc", 48);
add_control("beatjump_+16_b",					2, "cc", 49);
add_control("beatjump_+32_b",					2, "cc", 50);
add_control("beatjump_+loop_b",					2, "cc", 51);

add_control("hotcue1_state_a",					2, "cc", 52);
add_control("hotcue2_state_a",					2, "cc", 53);
add_control("hotcue3_state_a",					2, "cc", 54);
add_control("hotcue4_state_a",					2, "cc", 55);
add_control("hotcue5_state_a",					2, "cc", 56);
add_control("hotcue6_state_a",					2, "cc", 57);
add_control("hotcue7_state_a",					2, "cc", 58);
add_control("hotcue8_state_a",					2, "cc", 59);

add_control("hotcue1_state_b",					2, "cc", 60);
add_control("hotcue2_state_b",					2, "cc", 61);
add_control("hotcue3_state_b",					2, "cc", 62);
add_control("hotcue4_state_b",					2, "cc", 63);
add_control("hotcue5_state_b",					2, "cc", 64);
add_control("hotcue6_state_b",					2, "cc", 65);
add_control("hotcue7_state_b",					2, "cc", 66);
add_control("hotcue8_state_b",					2, "cc", 67);

add_control("cue_set_and_store_a",				6, "cc", 49);
add_control("cue_set_and_store_b",				6, "cc", 50);
add_control("jump_to_active_cue_point_a",		6, "cc", 51);
add_control("jump_to_active_cue_point_b",		6, "cc", 52);

-- mixer

add_control("eq_high_a",						2, "cc", 68);
add_control("eq_high_b",						2, "cc", 69);
add_control("eq_high_kill_a",					2, "cc", 70);
add_control("eq_high_kill_b",					2, "cc", 71);

add_control("eq_mid_a",							2, "cc", 72);
add_control("eq_mid_b",							2, "cc", 73);
add_control("eq_mid_kill_a",					2, "cc", 74);
add_control("eq_mid_kill_b",					2, "cc", 75);

add_control("eq_low_a",							2, "cc", 76);
add_control("eq_low_b",							2, "cc", 77);
add_control("eq_low_kill_a",					2, "cc", 78);
add_control("eq_low_kill_b",					2, "cc", 79);

add_control("filter_a",							2, "cc", 80);
add_control("filter_b",							2, "cc", 81);
add_control("filter_on_a",						2, "cc", 82);
add_control("filter_on_b",						2, "cc", 83);

add_control("volume_fader_a",					2, "cc", 84);
add_control("volume_fader_b",					2, "cc", 85);

add_control("effect_unit_1_on_a",				2, "cc", 86);
add_control("effect_unit_1_on_b",				2, "cc", 87);
add_control("effect_unit_2_on_a",				2, "cc", 88);
add_control("effect_unit_2_on_b",				2, "cc", 89);
add_control("effect_unit_3_on_a",				2, "cc", 90);
add_control("effect_unit_3_on_b",				2, "cc", 91);
add_control("effect_unit_4_on_a",				2, "cc", 92);
add_control("effect_unit_4_on_b",				2, "cc", 93);

add_control("gain_a",							2, "cc", 94);
add_control("gain_b",							2, "cc", 95);

add_control("monitor_cue_a",					2, "cc", 96);
add_control("monitor_cue_b",					2, "cc", 97);
add_control("monitor_cue_c",					2, "cc", 98);
add_control("monitor_cue_d",					2, "cc", 99);

add_control("x_fader",							2, "cc", 100);
add_control("master_volume",					2, "cc", 101);
add_control("monitor_volume",					2, "cc", 102);
add_control("monitor_mix",						2, "cc", 103);

-- fx group

add_control("effect_1_select_unit_1",			6, "cc", 53);
add_control("effect_1_select_unit_2",			6, "cc", 54);
add_control("effect_1_select_unit_3",			6, "cc", 55);
add_control("effect_1_select_unit_4",			6, "cc", 56);

add_control("effect_2_select_unit_1",			6, "cc", 57);
add_control("effect_2_select_unit_2",			6, "cc", 58);
add_control("effect_2_select_unit_3",			6, "cc", 59);
add_control("effect_2_select_unit_4",			6, "cc", 60);

add_control("effect_3_select_unit_1",			6, "cc", 61);
add_control("effect_3_select_unit_2",			6, "cc", 62);
add_control("effect_3_select_unit_3",			6, "cc", 63);
add_control("effect_3_select_unit_4",			6, "cc", 64);

add_control("effect_1_select_inc_unit_1",		3, "cc", 0);
add_control("effect_1_select_inc_unit_2",		3, "cc", 1);
add_control("effect_1_select_inc_unit_3",		3, "cc", 2);
add_control("effect_1_select_inc_unit_4",		3, "cc", 3);
add_control("effect_1_select_dec_unit_1",		3, "cc", 4);
add_control("effect_1_select_dec_unit_2",		3, "cc", 5);
add_control("effect_1_select_dec_unit_3",		3, "cc", 6);
add_control("effect_1_select_dec_unit_4",		3, "cc", 7);

add_control("effect_2_select_inc_unit_1",		3, "cc", 8);
add_control("effect_2_select_inc_unit_2",		3, "cc", 9);
add_control("effect_2_select_inc_unit_3",		3, "cc", 10);
add_control("effect_2_select_inc_unit_4",		3, "cc", 11);
add_control("effect_2_select_dec_unit_1",		3, "cc", 12);
add_control("effect_2_select_dec_unit_2",		3, "cc", 13);
add_control("effect_2_select_dec_unit_3",		3, "cc", 14);
add_control("effect_2_select_dec_unit_4",		3, "cc", 15);

add_control("effect_3_select_inc_unit_1",		3, "cc", 16);
add_control("effect_3_select_inc_unit_2",		3, "cc", 17);
add_control("effect_3_select_inc_unit_3",		3, "cc", 18);
add_control("effect_3_select_inc_unit_4",		3, "cc", 19);
add_control("effect_3_select_dec_unit_1",		3, "cc", 20);
add_control("effect_3_select_dec_unit_2",		3, "cc", 21);
add_control("effect_3_select_dec_unit_3",		3, "cc", 22);
add_control("effect_3_select_dec_unit_4",		3, "cc", 23);

add_control("dry_wet_group_unit_1",				3, "cc", 24);
add_control("dry_wet_group_unit_2",				3, "cc", 25);
add_control("dry_wet_group_unit_3",				3, "cc", 26);
add_control("dry_wet_group_unit_4",				3, "cc", 27);

add_control("effect_1_amount_unit_1",			3, "cc", 28);
add_control("effect_1_amount_unit_2",			3, "cc", 29);
add_control("effect_1_amount_unit_3",			3, "cc", 30);
add_control("effect_1_amount_unit_4",			3, "cc", 31);

add_control("effect_2_amount_unit_1",			3, "cc", 32);
add_control("effect_2_amount_unit_2",			3, "cc", 33);
add_control("effect_2_amount_unit_3",			3, "cc", 34);
add_control("effect_2_amount_unit_4",			3, "cc", 35);

add_control("effect_3_amount_unit_1",			3, "cc", 36);
add_control("effect_3_amount_unit_2",			3, "cc", 37);
add_control("effect_3_amount_unit_3",			3, "cc", 38);
add_control("effect_3_amount_unit_4",			3, "cc", 39);

add_control("effect_1_amount_inc_unit_1",		3, "cc", 40);
add_control("effect_1_amount_inc_unit_2",		3, "cc", 41);
add_control("effect_1_amount_inc_unit_3",		3, "cc", 42);
add_control("effect_1_amount_inc_unit_4",		3, "cc", 43);

add_control("effect_1_amount_dec_unit_1",		3, "cc", 44);
add_control("effect_1_amount_dec_unit_2",		3, "cc", 45);
add_control("effect_1_amount_dec_unit_3",		3, "cc", 46);
add_control("effect_1_amount_dec_unit_4",		3, "cc", 47);

add_control("effect_2_amount_inc_unit_1",		3, "cc", 48);
add_control("effect_2_amount_inc_unit_2",		3, "cc", 49);
add_control("effect_2_amount_inc_unit_3",		3, "cc", 50);
add_control("effect_2_amount_inc_unit_4",		3, "cc", 51);

add_control("effect_2_amount_dec_unit_1",		3, "cc", 52);
add_control("effect_2_amount_dec_unit_2",		3, "cc", 53);
add_control("effect_2_amount_dec_unit_3",		3, "cc", 54);
add_control("effect_2_amount_dec_unit_4",		3, "cc", 55);

add_control("effect_3_amount_inc_unit_1",		3, "cc", 56);
add_control("effect_3_amount_inc_unit_2",		3, "cc", 57);
add_control("effect_3_amount_inc_unit_3",		3, "cc", 58);
add_control("effect_3_amount_inc_unit_4",		3, "cc", 59);

add_control("effect_3_amount_dec_unit_1",		3, "cc", 60);
add_control("effect_3_amount_dec_unit_2",		3, "cc", 61);
add_control("effect_3_amount_dec_unit_3",		3, "cc", 62);
add_control("effect_3_amount_dec_unit_4",		3, "cc", 63);

add_control("effect_1_on_unit_1",				3, "cc", 64);
add_control("effect_1_on_unit_2",				3, "cc", 65);
add_control("effect_1_on_unit_3",				3, "cc", 66);
add_control("effect_1_on_unit_4",				3, "cc", 67);

add_control("effect_2_on_unit_1",				3, "cc", 68);
add_control("effect_2_on_unit_2",				3, "cc", 69);
add_control("effect_2_on_unit_3",				3, "cc", 70);
add_control("effect_2_on_unit_4",				3, "cc", 71);

add_control("effect_3_on_unit_1",				3, "cc", 72);
add_control("effect_3_on_unit_2",				3, "cc", 73);
add_control("effect_3_on_unit_3",				3, "cc", 74);
add_control("effect_3_on_unit_4",				3, "cc", 75);

-- fx single

add_control("effect_select_unit_1",				3, "cc", 76);
add_control("effect_select_unit_2",				3, "cc", 77);
add_control("effect_select_unit_3",				3, "cc", 78);
add_control("effect_select_unit_4",				3, "cc", 79);

add_control("effect_select_inc_unit_1",			3, "cc", 80);
add_control("effect_select_inc_unit_2",			3, "cc", 81);
add_control("effect_select_inc_unit_3",			3, "cc", 82);
add_control("effect_select_inc_unit_4",			3, "cc", 83);

add_control("effect_select_dec_unit_1",			3, "cc", 84);
add_control("effect_select_dec_unit_2",			3, "cc", 85);
add_control("effect_select_dec_unit_3",			3, "cc", 86);
add_control("effect_select_dec_unit_4",			3, "cc", 87);

add_control("effect_on_unit_1",					3, "cc", 88);
add_control("effect_on_unit_2",					3, "cc", 89);
add_control("effect_on_unit_3",					3, "cc", 90);
add_control("effect_on_unit_4",					3, "cc", 91);

add_control("effect_param_reset_unit_1",		3, "cc", 92);
add_control("effect_param_reset_unit_2",		3, "cc", 93);
add_control("effect_param_reset_unit_3",		3, "cc", 94);
add_control("effect_param_reset_unit_4",		3, "cc", 95);

add_control("effect_button_1_unit_1",			3, "cc", 96);
add_control("effect_button_1_unit_2",			3, "cc", 97);
add_control("effect_button_1_unit_3",			3, "cc", 98);
add_control("effect_button_1_unit_4",			3, "cc", 99);

add_control("effect_button_2_unit_1",			3, "cc", 100);
add_control("effect_button_2_unit_2",			3, "cc", 101);
add_control("effect_button_2_unit_3",			3, "cc", 102);
add_control("effect_button_2_unit_4",			3, "cc", 103);

add_control("dry_wet_single_unit_1",			3, "cc", 104);
add_control("dry_wet_single_unit_2",			3, "cc", 105);
add_control("dry_wet_single_unit_3",			3, "cc", 106);
add_control("dry_wet_single_unit_4",			3, "cc", 107);

add_control("effect_param_1_unit_1",			3, "cc", 108);
add_control("effect_param_1_unit_2",			3, "cc", 109);
add_control("effect_param_1_unit_3",			3, "cc", 110);
add_control("effect_param_1_unit_4",			3, "cc", 111);

add_control("effect_param_1_inc_unit_1",		3, "cc", 112);
add_control("effect_param_1_inc_unit_2",		3, "cc", 113);
add_control("effect_param_1_inc_unit_3",		3, "cc", 114);
add_control("effect_param_1_inc_unit_4",		3, "cc", 115);

add_control("effect_param_1_dec_unit_1",		3, "cc", 116);
add_control("effect_param_1_dec_unit_2",		3, "cc", 117);
add_control("effect_param_1_dec_unit_3",		3, "cc", 118);
add_control("effect_param_1_dec_unit_4",		3, "cc", 119);

add_control("effect_param_2_unit_1",			4, "cc", 0);
add_control("effect_param_2_unit_2",			4, "cc", 1);
add_control("effect_param_2_unit_3",			4, "cc", 2);
add_control("effect_param_2_unit_4",			4, "cc", 3);

add_control("effect_param_2_inc_unit_1",		4, "cc", 4);
add_control("effect_param_2_inc_unit_2",		4, "cc", 5);
add_control("effect_param_2_inc_unit_3",		4, "cc", 6);
add_control("effect_param_2_inc_unit_4",		4, "cc", 7);

add_control("effect_param_2_dec_unit_1",		4, "cc", 8);
add_control("effect_param_2_dec_unit_2",		4, "cc", 9);
add_control("effect_param_2_dec_unit_3",		4, "cc", 10);
add_control("effect_param_2_dec_unit_4",		4, "cc", 11);

add_control("effect_param_3_unit_1",			4, "cc", 12);
add_control("effect_param_3_unit_2",			4, "cc", 13);
add_control("effect_param_3_unit_3",			4, "cc", 14);
add_control("effect_param_3_unit_4",			4, "cc", 15);

add_control("effect_param_3_inc_unit_1",		4, "cc", 16);
add_control("effect_param_3_inc_unit_2",		4, "cc", 17);
add_control("effect_param_3_inc_unit_3",		4, "cc", 18);
add_control("effect_param_3_inc_unit_4",		4, "cc", 19);

add_control("effect_param_3_dec_unit_1",		4, "cc", 20);
add_control("effect_param_3_dec_unit_2",		4, "cc", 21);
add_control("effect_param_3_dec_unit_3",		4, "cc", 22);
add_control("effect_param_3_dec_unit_4",		4, "cc", 23);

-- tempo

add_control("beat_sync_a",						4, "cc", 24);
add_control("beat_sync_b",						4, "cc", 25);
add_control("phase_sync_a",						4, "cc", 26);
add_control("phase_sync_b",						4, "cc", 27);
add_control("tempo_sync_a",						4, "cc", 28);
add_control("tempo_sync_b",						4, "cc", 29);

add_control("tempo_bend_down_a",				4, "cc", 30);
add_control("tempo_bend_down_b",				4, "cc", 31);
add_control("tempo_bend_up_a",					4, "cc", 32);
add_control("tempo_bend_up_b",					4, "cc", 33);
add_control("tempo_bend_encoder_a",				4, "cc", 34);
add_control("tempo_bend_encoder_b",				4, "cc", 35);

add_control("tempo_fader_a",					4, "cc", 36);
add_control("tempo_fader_b",					4, "cc", 37);
add_control("tempo_fader_inc_a",				4, "cc", 38);
add_control("tempo_fader_inc_b",				4, "cc", 39);
add_control("tempo_fader_dec_a",				4, "cc", 40);
add_control("tempo_fader_dec_b",				4, "cc", 41);

-- loop recorder

add_control("loop_recorder_record",				4, "cc", 42);
add_control("loop_recorder_size",				4, "cc", 43);
add_control("loop_recorder_size_inc",			4, "cc", 44);
add_control("loop_recorder_size_dec",			4, "cc", 45);
add_control("loop_recorder_size_4",				4, "cc", 46);
add_control("loop_recorder_size_8",				4, "cc", 47);
add_control("loop_recorder_size_16",			4, "cc", 48);
add_control("loop_recorder_size_32",			4, "cc", 49);
add_control("loop_recorder_dry_wet",			4, "cc", 50);
add_control("loop_recorder_play_pause",			4, "cc", 51);
add_control("loop_recorder_del",				4, "cc", 52);
add_control("loop_recorder_undo_redo",			4, "cc", 53);
add_control("loop_recorder_dry_wet_up",			6, "cc", 46);
add_control("loop_recorder_dry_wet_down",		6, "cc", 47);
add_control("loop_recorder_dry_wet_half",		6, "cc", 48);

-- sample decks c+d

add_control("sample_deck_play_c1",				5, "cc", 121);
add_control("sample_deck_play_c2",				5, "cc", 122);
add_control("sample_deck_play_c3",				5, "cc", 123);
add_control("sample_deck_play_c4",				5, "cc", 124);
add_control("sample_deck_play_d1",				5, "cc", 125);
add_control("sample_deck_play_d2",				5, "cc", 126);
add_control("sample_deck_play_d3",				5, "cc", 127);
add_control("sample_deck_play_d4",				6, "cc", 0);

add_control("slot_start_stop_c1",				4, "cc", 54);
add_control("slot_start_stop_c2",				4, "cc", 55);
add_control("slot_start_stop_c3",				4, "cc", 56);
add_control("slot_start_stop_c4",				4, "cc", 57);
add_control("slot_start_stop_d1",				4, "cc", 58);
add_control("slot_start_stop_d2",				4, "cc", 59);
add_control("slot_start_stop_d3",				4, "cc", 60);
add_control("slot_start_stop_d4",				4, "cc", 61);

add_control("load_from_list_c1",				4, "cc", 62);
add_control("load_from_list_c2",				4, "cc", 63);
add_control("load_from_list_c3",				4, "cc", 64);
add_control("load_from_list_c4",				4, "cc", 65);
add_control("load_from_list_d1",				4, "cc", 66);
add_control("load_from_list_d2",				4, "cc", 67);
add_control("load_from_list_d3",				4, "cc", 68);
add_control("load_from_list_d4",				4, "cc", 69);

add_control("load_from_deck_c1",				4, "cc", 70);
add_control("load_from_deck_c2",				4, "cc", 71);
add_control("load_from_deck_c3",				4, "cc", 72);
add_control("load_from_deck_c4",				4, "cc", 73);
add_control("load_from_deck_d1",				4, "cc", 74);
add_control("load_from_deck_d2",				4, "cc", 75);
add_control("load_from_deck_d3",				4, "cc", 76);
add_control("load_from_deck_d4",				4, "cc", 77);

add_control("group_play_mode_one_shot_c",		4, "cc", 78);
add_control("group_play_mode_looped_c",			4, "cc", 79);
add_control("group_play_mode_one_shot_d",		4, "cc", 80);
add_control("group_play_mode_looped_d",			4, "cc", 81);
add_control("group_play_mode_c",				4, "cc", 82); -- out only
add_control("group_play_mode_d",				4, "cc", 83); -- out only

add_control("clear_slot_c1",					4, "cc", 84);
add_control("clear_slot_c2",					4, "cc", 85);
add_control("clear_slot_c3",					4, "cc", 86);
add_control("clear_slot_c4",					4, "cc", 87);
add_control("clear_slot_d1",					4, "cc", 88);
add_control("clear_slot_d2",					4, "cc", 89);
add_control("clear_slot_d3",					4, "cc", 90);
add_control("clear_slot_d4",					4, "cc", 91);

add_control("slot_volume_c1",					4, "cc", 92);
add_control("slot_volume_c2",					4, "cc", 93);
add_control("slot_volume_c3",					4, "cc", 94);
add_control("slot_volume_c4",					4, "cc", 95);
add_control("slot_volume_d1",					4, "cc", 96);
add_control("slot_volume_d2",					4, "cc", 97);
add_control("slot_volume_d3",					4, "cc", 98);
add_control("slot_volume_d4",					4, "cc", 99);

add_control("slot_volume_up_c1",				6, "cc", 13);
add_control("slot_volume_up_c2",				6, "cc", 14);
add_control("slot_volume_up_c3",				6, "cc", 15);
add_control("slot_volume_up_c4",				6, "cc", 16);
add_control("slot_volume_up_d1",				6, "cc", 17);
add_control("slot_volume_up_d2",				6, "cc", 18);
add_control("slot_volume_up_d3",				6, "cc", 19);
add_control("slot_volume_up_d4",				6, "cc", 20);

add_control("slot_volume_down_c1",				6, "cc", 21);
add_control("slot_volume_down_c2",				6, "cc", 22);
add_control("slot_volume_down_c3",				6, "cc", 23);
add_control("slot_volume_down_c4",				6, "cc", 24);
add_control("slot_volume_down_d1",				6, "cc", 25);
add_control("slot_volume_down_d2",				6, "cc", 26);
add_control("slot_volume_down_d3",				6, "cc", 27);
add_control("slot_volume_down_d4",				6, "cc", 28);

add_control("slot_filter_c1",					4, "cc", 100);
add_control("slot_filter_c2",					4, "cc", 101);
add_control("slot_filter_c3",					4, "cc", 102);
add_control("slot_filter_c4",					4, "cc", 103);
add_control("slot_filter_d1",					4, "cc", 104);
add_control("slot_filter_d2",					4, "cc", 105);
add_control("slot_filter_d3",					4, "cc", 106);
add_control("slot_filter_d4",					4, "cc", 107);

add_control("slot_filter_amount_c1",			4, "cc", 108);
add_control("slot_filter_amount_c2",			4, "cc", 109);
add_control("slot_filter_amount_c3",			4, "cc", 110);
add_control("slot_filter_amount_c4",			4, "cc", 111);
add_control("slot_filter_amount_d1",			4, "cc", 112);
add_control("slot_filter_amount_d2",			4, "cc", 113);
add_control("slot_filter_amount_d3",			4, "cc", 114);
add_control("slot_filter_amount_d4",			4, "cc", 115);

add_control("slot_filter_up_c1",				6, "cc", 29);
add_control("slot_filter_up_c2",				6, "cc", 31);
add_control("slot_filter_up_c3",				6, "cc", 32);
add_control("slot_filter_up_c4",				6, "cc", 33);
add_control("slot_filter_up_d1",				6, "cc", 34);
add_control("slot_filter_up_d2",				6, "cc", 35);
add_control("slot_filter_up_d3",				6, "cc", 36);
add_control("slot_filter_up_d4",				6, "cc", 37);

add_control("slot_filter_down_c1",				6, "cc", 38);
add_control("slot_filter_down_c2",				6, "cc", 39);
add_control("slot_filter_down_c3",				6, "cc", 40);
add_control("slot_filter_down_c4",				6, "cc", 41);
add_control("slot_filter_down_d1",				6, "cc", 42);
add_control("slot_filter_down_d2",				6, "cc", 43);
add_control("slot_filter_down_d3",				6, "cc", 44);
add_control("slot_filter_down_d4",				6, "cc", 45);

add_control("sample_play_primary_c1",			4, "cc", 116);
add_control("sample_play_primary_c2",			4, "cc", 117);
add_control("sample_play_primary_c3",			4, "cc", 118);
add_control("sample_play_primary_c4",			4, "cc", 119);
add_control("sample_play_primary_d1",			4, "cc", 120);
add_control("sample_play_primary_d2",			4, "cc", 121);
add_control("sample_play_primary_d3",			4, "cc", 122);
add_control("sample_play_primary_d4",			4, "cc", 123);

add_control("sample_play_secondary_c1",			5, "cc", 113);
add_control("sample_play_secondary_c2",			4, "cc", 114);
add_control("sample_play_secondary_c3",			4, "cc", 115);
add_control("sample_play_secondary_c4",			4, "cc", 116);
add_control("sample_play_secondary_d1",			4, "cc", 117);
add_control("sample_play_secondary_d2",			4, "cc", 118);
add_control("sample_play_secondary_d3",			4, "cc", 119);
add_control("sample_play_secondary_d4",			4, "cc", 120);

add_control("group_play_c",						4, "cc", 124);
add_control("group_play_d",						4, "cc", 125);
add_control("group_trigger_c",					4, "cc", 126);
add_control("group_trigger_d",					4, "cc", 127);

add_control("slot_mute_unmute_c1",				5, "cc", 0);
add_control("slot_mute_unmute_c2",				5, "cc", 1);
add_control("slot_mute_unmute_c3",				5, "cc", 2);
add_control("slot_mute_unmute_c4",				5, "cc", 3);
add_control("slot_mute_unmute_d1",				5, "cc", 4);
add_control("slot_mute_unmute_d2",				5, "cc", 5);
add_control("slot_mute_unmute_d3",				5, "cc", 6);
add_control("slot_mute_unmute_d4",				5, "cc", 7);

add_control("sample_trigger_c1",				5, "cc", 8);
add_control("sample_trigger_c2",				5, "cc", 9);
add_control("sample_trigger_c3",				5, "cc", 10);
add_control("sample_trigger_c4",				5, "cc", 11);
add_control("sample_trigger_d1",				5, "cc", 12);
add_control("sample_trigger_d2",				5, "cc", 13);
add_control("sample_trigger_d3",				5, "cc", 14);
add_control("sample_trigger_d4",				5, "cc", 15);

add_control("slot_retrigger_c1",				5, "cc", 16);
add_control("slot_retrigger_c2",				5, "cc", 17);
add_control("slot_retrigger_c3",				5, "cc", 18);
add_control("slot_retrigger_c4",				5, "cc", 19);
add_control("slot_retrigger_d1",				5, "cc", 20);
add_control("slot_retrigger_d2",				5, "cc", 21);
add_control("slot_retrigger_d3",				5, "cc", 22);
add_control("slot_retrigger_d4",				5, "cc", 23);

add_control("copy_from_loop_recorder_c1",		5, "cc", 24);
add_control("copy_from_loop_recorder_c2",		5, "cc", 25);
add_control("copy_from_loop_recorder_c3",		5, "cc", 26);
add_control("copy_from_loop_recorder_c4",		5, "cc", 27);
add_control("copy_from_loop_recorder_d1",		5, "cc", 28);
add_control("copy_from_loop_recorder_d2",		5, "cc", 29);
add_control("copy_from_loop_recorder_d3",		5, "cc", 30);
add_control("copy_from_loop_recorder_d4",		5, "cc", 31);

add_control("slot_play_mode_one_shot_c1",		5, "cc", 32);
add_control("slot_play_mode_one_shot_c2",		5, "cc", 33);
add_control("slot_play_mode_one_shot_c3",		5, "cc", 34);
add_control("slot_play_mode_one_shot_c4",		5, "cc", 35);
add_control("slot_play_mode_one_shot_d1",		5, "cc", 36);
add_control("slot_play_mode_one_shot_d2",		5, "cc", 37);
add_control("slot_play_mode_one_shot_d3",		5, "cc", 38);
add_control("slot_play_mode_one_shot_d4",		5, "cc", 39);

add_control("slot_play_mode_looped_c1",			5, "cc", 40);
add_control("slot_play_mode_looped_c2",			5, "cc", 41);
add_control("slot_play_mode_looped_c3",			5, "cc", 42);
add_control("slot_play_mode_looped_c4",			5, "cc", 43);
add_control("slot_play_mode_looped_d1",			5, "cc", 44);
add_control("slot_play_mode_looped_d2",			5, "cc", 45);
add_control("slot_play_mode_looped_d3",			5, "cc", 46);
add_control("slot_play_mode_looped_d4",			5, "cc", 47);

add_control("slot_play_mode_c1",				5, "cc", 48); -- out only
add_control("slot_play_mode_c2",				5, "cc", 49); -- out only
add_control("slot_play_mode_c3",				5, "cc", 50); -- out only
add_control("slot_play_mode_c4",				5, "cc", 51); -- out only
add_control("slot_play_mode_d1",				5, "cc", 52); -- out only
add_control("slot_play_mode_d2",				5, "cc", 53); -- out only
add_control("slot_play_mode_d3",				5, "cc", 54); -- out only
add_control("slot_play_mode_d4",				5, "cc", 55); -- out only

add_control("slot_size_x2_c1",					5, "cc", 56);
add_control("slot_size_x2_c2",					5, "cc", 57);
add_control("slot_size_x2_c3",					5, "cc", 58);
add_control("slot_size_x2_c4",					5, "cc", 59);
add_control("slot_size_x2_d1",					5, "cc", 60);
add_control("slot_size_x2_d2",					5, "cc", 61);
add_control("slot_size_x2_d3",					5, "cc", 62);
add_control("slot_size_x2_d4",					5, "cc", 63);

add_control("slot_size_/2_c1",					5, "cc", 64);
add_control("slot_size_/2_c2",					5, "cc", 65);
add_control("slot_size_/2_c3",					5, "cc", 66);
add_control("slot_size_/2_c4",					5, "cc", 67);
add_control("slot_size_/2_d1",					5, "cc", 68);
add_control("slot_size_/2_d2",					5, "cc", 69);
add_control("slot_size_/2_d3",					5, "cc", 70);
add_control("slot_size_/2_d4",					5, "cc", 71);

add_control("slot_size_reset_c1",				5, "cc", 72);
add_control("slot_size_reset_c2",				5, "cc", 73);
add_control("slot_size_reset_c3",				5, "cc", 74);
add_control("slot_size_reset_c4",				5, "cc", 75);
add_control("slot_size_reset_d1",				5, "cc", 76);
add_control("slot_size_reset_d2",				5, "cc", 77);
add_control("slot_size_reset_d3",				5, "cc", 78);
add_control("slot_size_reset_d4",				5, "cc", 79);

add_control("slot_tempo_bend_up_c1",			5, "cc", 90);
add_control("slot_tempo_bend_up_c2",			5, "cc", 91);
add_control("slot_tempo_bend_up_c3",			5, "cc", 92);
add_control("slot_tempo_bend_up_c4",			5, "cc", 93);
add_control("slot_tempo_bend_up_d1",			5, "cc", 94);
add_control("slot_tempo_bend_up_d2",			5, "cc", 95);
add_control("slot_tempo_bend_up_d3",			5, "cc", 96);
add_control("slot_tempo_bend_up_d4",			5, "cc", 97);

add_control("slot_tempo_bend_down_c1",			5, "cc", 98);
add_control("slot_tempo_bend_down_c2",			5, "cc", 99);
add_control("slot_tempo_bend_down_c3",			5, "cc", 100);
add_control("slot_tempo_bend_down_c4",			5, "cc", 101);
add_control("slot_tempo_bend_down_d1",			5, "cc", 102);
add_control("slot_tempo_bend_down_d2",			5, "cc", 103);
add_control("slot_tempo_bend_down_d3",			5, "cc", 104);
add_control("slot_tempo_bend_down_d4",			5, "cc", 105);

add_control("seek_inc_a",						5, "cc", 109);
add_control("seek_dec_a",						5, "cc", 110);
add_control("seek_inc_b",						5, "cc", 111);
add_control("seek_dec_b",						5, "cc", 112);

-- output

add_control("beat_phase_monitor_a",				5, "cc", 80); -- out only
add_control("beat_phase_monitor_b",				5, "cc", 81); -- out only
add_control("monitor_deck_afl_mono_a",			5, "cc", 82); -- out only
add_control("monitor_deck_afl_mono_b",			5, "cc", 83); -- out only
add_control("track_end_warning_a",				5, "cc", 84); -- out only
add_control("track_end_warning_b",				5, "cc", 85); -- out only

add_control("master_tempo_clock_send",			5, "cc", 86);
add_control("master_tempo_clock_sync_midi",		5, "cc", 87);

add_control("seek_position_a",					5, "cc", 88); -- out only
add_control("seek_position_b",					5, "cc", 89); -- out only

add_control("master_level",						5, "cc", 106); -- out only
add_control("master_level_left",				5, "cc", 107); -- out only
add_control("master_level_right",				5, "cc", 108); -- out only
add_control("send_monitor_state",				6, "cc", 1);
add_control("show_slider_values",				6, "cc", 12);

-- layout

add_control("snap_mode",						6, "cc", 2);
add_control("quant_on",							6, "cc", 3);

add_control("fx_panel_mode_unit_1_group",		6, "cc", 4);
add_control("fx_panel_mode_unit_1_single",		6, "cc", 5);
add_control("fx_panel_mode_unit_2_group",		6, "cc", 6);
add_control("fx_panel_mode_unit_2_single",		6, "cc", 7);
add_control("fx_panel_mode_unit_3_group",		6, "cc", 8);
add_control("fx_panel_mode_unit_3_single",		6, "cc", 9);
add_control("fx_panel_mode_unit_4_group",		6, "cc", 10);
add_control("fx_panel_mode_unit_4_single",		6, "cc", 11);

-- hi res messages

add_control("tempo_fader_a_hires",				1, "pb");
add_control("tempo_fader_b_hires",				2, "pb");
add_control("x_fader_hires",					3, "pb");
add_control("volume_fader_a_hires",				4, "pb");
add_control("volume_fader_b_hires",				5, "pb");

-- end of controls
-- highest used: ch=6 cc=66

-------------------------------------------------------------------------
-- START OF KANE CONTROLS
-------------------------------------------------------------------------

--
-- Deck A: ch=7
--

-- load selected
add_control("load_selected_a", 					7, "cc", 0);

-- grid cues
add_control("set_grid_marker_a",				7, "cc", 1);
add_control("delete_grid_marker_a",			7, "cc", 2);

-- cue type
add_control("set_cue_type_a",						7, "cc", 3)

-- deck duplications
add_control("duplicate_deck_b_a",	            7, "cc", 4);
add_control("duplicate_deck_c_a",  	          7, "cc", 5);
add_control("duplicate_deck_d_a",    	        7, "cc", 6);


--
-- Deck B: ch=8
--

-- load selected
add_control("load_selected_b", 					8, "cc", 0);

-- grid cues
add_control("set_grid_marker_b",				8, "cc", 1);
add_control("delete_grid_marker_b",			8, "cc", 2);

-- cue type
add_control("set_cue_type_b",						8, "cc", 3)

-- deck duplications
add_control("duplicate_deck_a_b",	            8, "cc", 4);
add_control("duplicate_deck_c_b",  	          8, "cc", 5);
add_control("duplicate_deck_d_b",    	        8, "cc", 6);


--
-- Deck C: ch=9
--

-- hotcues
add_control("select_set_store_hotcue_1_c",		9, "cc", 1);
add_control("select_set_store_hotcue_2_c",		9, "cc", 2);
add_control("select_set_store_hotcue_3_c",		9, "cc", 3);
add_control("select_set_store_hotcue_4_c",		9, "cc", 4);
add_control("select_set_store_hotcue_5_c",		9, "cc", 5);
add_control("select_set_store_hotcue_6_c",		9, "cc", 6);
add_control("select_set_store_hotcue_7_c",		9, "cc", 7);
add_control("select_set_store_hotcue_8_c",		9, "cc", 8);

add_control("delete_hotcue_1_c",				9, "cc", 9);
add_control("delete_hotcue_2_c",				9, "cc", 10);
add_control("delete_hotcue_3_c",				9, "cc", 11);
add_control("delete_hotcue_4_c",				9, "cc", 12);
add_control("delete_hotcue_5_c",				9, "cc", 13);
add_control("delete_hotcue_6_c",				9, "cc", 14);
add_control("delete_hotcue_7_c",				9, "cc", 15);
add_control("delete_hotcue_8_c",				9, "cc", 16);

add_control("hotcue1_state_c",					9, "cc", 17);
add_control("hotcue2_state_c",					9, "cc", 18);
add_control("hotcue3_state_c",					9, "cc", 19);
add_control("hotcue4_state_c",					9, "cc", 20);
add_control("hotcue5_state_c",					9, "cc", 21);
add_control("hotcue6_state_c",					9, "cc", 22);
add_control("hotcue7_state_c",					9, "cc", 23);
add_control("hotcue8_state_c",					9, "cc", 24);

-- fx units
add_control("effect_unit_1_on_c",				9, "cc", 25);
add_control("effect_unit_2_on_c",				9, "cc", 26);
add_control("effect_unit_3_on_c",				9, "cc", 27);
add_control("effect_unit_4_on_c",				9, "cc", 28);

-- play/cue/sync
add_control("play_c",										9, "cc", 29);
add_control("cue_c",										9, "cc", 30);
add_control("beat_sync_c",							9, "cc", 31);

-- loops
add_control("loop_set_c",								9, "cc", 32);
add_control("loop_active_c",						9, "cc", 33);
add_control("loop_size_c",							9, "cc", 34);
add_control("loop_size_inc_c",					9, "cc", 35);
add_control("loop_size_dec_c",					9, "cc", 36);

add_control("loop_size_set_1_c",				9, "cc", 42);
add_control("loop_size_set_4_c",				9, "cc", 44);
add_control("loop_size_set_8_c",				9, "cc", 45);
add_control("loop_size_set_16_c",				9, "cc", 46);
add_control("loop_size_set_32_c",				9, "cc", 47);

-- beatjumps
add_control("beatjump_+1_c",						9, "cc", 52);
add_control("beatjump_+4_c",						9, "cc", 54);
add_control("beatjump_+8_c",						9, "cc", 55);
add_control("beatjump_+16_c",						9, "cc", 56);
add_control("beatjump_+32_c",						9, "cc", 57);

add_control("beatjump_-32_c",						9, "cc", 58);
add_control("beatjump_-16_c",						9, "cc", 59);
add_control("beatjump_-8_c",						9, "cc", 60);
add_control("beatjump_-4_c",						9, "cc", 61);
add_control("beatjump_-1_c",						9, "cc", 63);

-- eq's
add_control("eq_high_kill_c",						9, "cc", 68);
add_control("eq_mid_kill_c",						9, "cc", 69);
add_control("eq_low_kill_c",						9, "cc", 70);

-- volume
add_control("volume_fader_c",						9, "cc", 71);

-- load selected
add_control("load_selected_c", 					9, "cc", 72);

-- grid cues
add_control("set_grid_marker_c",				9, "cc", 73);
add_control("delete_grid_marker_c",			9, "cc", 74);

-- cue type
add_control("set_cue_type_c",						9, "cc", 75)

-- deck duplications
add_control("duplicate_deck_a_c",             9, "cc", 76);
add_control("duplicate_deck_b_c",             9, "cc", 77);
add_control("duplicate_deck_d_c",             9, "cc", 78);

-- eq faders
add_control("eq_high_c",                      9, "cc", 79);
add_control("eq_mid_c",                       9, "cc", 80);
add_control("eq_low_c",         	            9, "cc", 81);

--
-- Deck D: ch=10
--

-- hotcues
add_control("select_set_store_hotcue_1_d",		10, "cc", 1);
add_control("select_set_store_hotcue_2_d",		10, "cc", 2);
add_control("select_set_store_hotcue_3_d",		10, "cc", 3);
add_control("select_set_store_hotcue_4_d",		10, "cc", 4);
add_control("select_set_store_hotcue_5_d",		10, "cc", 5);
add_control("select_set_store_hotcue_6_d",		10, "cc", 6);
add_control("select_set_store_hotcue_7_d",		10, "cc", 7);
add_control("select_set_store_hotcue_8_d",		10, "cc", 8);

add_control("delete_hotcue_1_d",				10, "cc", 9);
add_control("delete_hotcue_2_d",				10, "cc", 10);
add_control("delete_hotcue_3_d",				10, "cc", 11);
add_control("delete_hotcue_4_d",				10, "cc", 12);
add_control("delete_hotcue_5_d",				10, "cc", 13);
add_control("delete_hotcue_6_d",				10, "cc", 14);
add_control("delete_hotcue_7_d",				10, "cc", 15);
add_control("delete_hotcue_8_d",				10, "cc", 16);

add_control("hotcue1_state_d",					10, "cc", 17);
add_control("hotcue2_state_d",					10, "cc", 18);
add_control("hotcue3_state_d",					10, "cc", 19);
add_control("hotcue4_state_d",					10, "cc", 20);
add_control("hotcue5_state_d",					10, "cc", 21);
add_control("hotcue6_state_d",					10, "cc", 22);
add_control("hotcue7_state_d",					10, "cc", 23);
add_control("hotcue8_state_d",					10, "cc", 24);

-- fx units
add_control("effect_unit_1_on_d",				10, "cc", 25);
add_control("effect_unit_2_on_d",				10, "cc", 26);
add_control("effect_unit_3_on_d",				10, "cc", 27);
add_control("effect_unit_4_on_d",				10, "cc", 28);

-- play/cue/sync
add_control("play_d",										10, "cc", 29);
add_control("cue_d",										10, "cc", 30);
add_control("beat_sync_d",							10, "cc", 31);

-- loops
add_control("loop_set_d",								10, "cc", 32);
add_control("loop_active_d",						10, "cc", 33);
add_control("loop_size_d",							10, "cc", 34);
add_control("loop_size_inc_d",					10, "cc", 35);
add_control("loop_size_dec_d",					10, "cc", 36);

add_control("loop_size_set_1_d",				10, "cc", 42);
add_control("loop_size_set_4_d",				10, "cc", 44);
add_control("loop_size_set_8_d",				10, "cc", 45);
add_control("loop_size_set_16_d",				10, "cc", 46);
add_control("loop_size_set_32_d",				10, "cc", 47);

-- beatjumps
add_control("beatjump_+1_d",						10, "cc", 52);
add_control("beatjump_+4_d",						10, "cc", 54);
add_control("beatjump_+8_d",						10, "cc", 55);
add_control("beatjump_+16_d",						10, "cc", 56);
add_control("beatjump_+32_d",						10, "cc", 57);

add_control("beatjump_-32_d",						10, "cc", 58);
add_control("beatjump_-16_d",						10, "cc", 59);
add_control("beatjump_-8_d",						10, "cc", 60);
add_control("beatjump_-4_d",						10, "cc", 61);
add_control("beatjump_-1_d",						10, "cc", 63);

-- eq's
add_control("eq_high_kill_d",						10, "cc", 68);
add_control("eq_mid_kill_d",						10, "cc", 69);
add_control("eq_low_kill_d",						10, "cc", 70);

-- volume
add_control("volume_fader_d",						10, "cc", 71);

-- load selected
add_control("load_selected_d", 					10, "cc", 72);

-- grid cues
add_control("set_grid_marker_d",				10, "cc", 73);
add_control("delete_grid_marker_d",			10, "cc", 74);

-- cue type
add_control("set_cue_type_d",						10, "cc", 75)

-- deck duplications
add_control("duplicate_deck_a_d",	           	10, "cc", 76);
add_control("duplicate_deck_b_d",  	          10, "cc", 77);
add_control("duplicate_deck_c_d",    	        10, "cc", 78);

-- eq faders
add_control("eq_high_d",                      10, "cc", 79);
add_control("eq_mid_d",                       10, "cc", 80);
add_control("eq_low_d",                       10, "cc", 81);


--
-- Global: ch=11
--

-- tempo nudge
add_control("tempo_inc_master",					11, "cc", 1);
add_control("tempo_dec_master",					11, "cc", 2);

-- pitch nudge
add_control("pitch_inc_focus",					11, "cc", 3);
add_control("pitch_dec_focus",					11, "cc", 4);

-- deck focus
add_control("inc_focus",								11, "cc", 5);
add_control("dec_focus",								11, "cc", 6);

-- record
add_control("record_master",						11, "cc", 7);

-- browser mode
add_control("browser",									11, "cc", 8);

-- search
add_control("search",										11, "cc", 9);

-- load last record
add_control("load_last_record",					11, "cc", 10);

-- master clock tempo
add_control("master_clock_tempo",				11, "cc", 11);

-- deck focus tempo fader
add_control("tempo_fader_focus",				11, "cc", 12);

-- focus beat phase monitor
add_control("beat_phase_monitor_focus",	11, "cc", 13);

-- master clock tempo master mode
add_control("master_clock_tempo_mode",	11, "cc", 14);

-- set tempo master
add_control("tempo_master_clock",	11, "cc", 15);
add_control("tempo_master_a",	11, "cc", 16);
add_control("tempo_master_b",	11, "cc", 17);
add_control("tempo_master_c",	11, "cc", 18);
add_control("tempo_master_d",	11, "cc", 19);

-- focus beat monitor
add_control("beat_monitor_focus", 11, "cc", 20);

