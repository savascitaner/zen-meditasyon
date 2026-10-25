package com.zenmeditation.zen_meditation

import com.ryanheise.audioservice.AudioServiceActivity

// audio_service needs its own activity so the Flutter engine is shared with
// the background playback service.
class MainActivity : AudioServiceActivity()
