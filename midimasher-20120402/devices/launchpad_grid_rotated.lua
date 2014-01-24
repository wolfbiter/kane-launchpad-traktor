-- define the top row buttons

add_control("up", 		1, "cc", 104);
add_control("down", 	1, "cc", 105);
add_control("left", 	1, "cc", 106);
add_control("right", 	1, "cc", 107);
add_control("session", 	1, "cc", 108);
add_control("user1", 	1, "cc", 109);
add_control("user2", 	1, "cc", 110);
add_control("mixer", 	1, "cc", 111);

-- define the right hand buttons

add_control("vol", 		1, "note", 8);
add_control("pan", 		1, "note", 16 + 8);
add_control("snda", 	1, "note", 2 * 16 + 8);
add_control("sndb", 	1, "note", 3 * 16 + 8);
add_control("stop", 	1, "note", 4 * 16 + 8);
add_control("trkon", 	1, "note", 5 * 16 + 8);
add_control("solo", 	1, "note", 6 * 16 + 8);
add_control("arm", 		1, "note", 7 * 16 + 8);

-- define the grid buttons, 8x8, note number is row x 16 + col 

for row = 0, 7
do
	for col = 0, 7
	do
		local note = row * 16 + col
		add_grid_control(7-col, row, 1, "note", note)
	end
end

-- lib/launchpad.lua won't autoload so we need to do it

require "lib/launchpad"
