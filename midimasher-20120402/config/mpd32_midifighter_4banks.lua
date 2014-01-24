--
-- virtual midifighter using a akai mpd32
--

open_midi_device("traktor", "traktor", "Traktor to MM", "MM to Traktor")
open_midi_device("mpd32", "mpd32", "MIDIIN2 (Akai MPD32)", "MIDIOUT2 (Akai MPD32)")
open_midi_device("midifighter1", "generic", "MidiFighter1 Input", "MidiFighter1 Output")
virtual_midifighter_4banks("mpd32", 0, "midifighter1", 0, 0, 127, 0)



