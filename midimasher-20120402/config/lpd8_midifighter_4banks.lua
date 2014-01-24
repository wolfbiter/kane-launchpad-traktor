--
-- virtual midifighter using a lpd8. PAD mode is the top half and CC mode is the bottom half of the MF
--

open_midi_device("lpd8", "lpd8", "LPD8", "LPD8", 2);

open_midi_device("traktor", "traktor", "V:Traktor to MM", "V:MM to Traktor")
open_midi_device("midifighter1", "generic", "V:MidiFighter1 Input", "V:MidiFighter1 Output")

virtual_midifighter_4banks("lpd8", 0, "midifighter1", 0, 0, 127, 0)

--
-- to use a 2nd lpd8 to be the other half of the midifighter, set one to PAD mode and
-- one to CC mode and then uncomment the following lines:
--
--open_midi_device("lpd8-2", "lpd8", "LPD8", "LPD8", 2);
--virtual_midifighter_4banks("lpd8-2", 0, "midifighter1", 0, 0, 127, 0)
--


