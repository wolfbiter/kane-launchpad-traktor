--
-- virtual midifighter using a akai mpd18.
--

open_midi_device("traktor", "traktor", "Traktor to MM", "MM to Traktor")
open_midi_device("mpd18", "mpd18", "Akai MPD18", "");
open_midi_device("midifighter1", "generic", "MidiFighter1 Input", "MidiFighter1 Output")
virtual_midifighter_4banks("mpd18", 0, "midifighter1", 0, 0, 127, 0)



