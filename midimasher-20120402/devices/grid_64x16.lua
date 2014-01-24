--
-- a virtual midi device, 64rows, 16cols, that can be embedded/scrolled
-- within a grid controller like a launchpad
--

for row=0, 63 do
	for col=0,15 do
		local i = row*16 + col
		local chan = math.floor(i/128) + 1
		local note = i % 128
 		add_grid_control(row, col, chan, "note", note)
	end
end
