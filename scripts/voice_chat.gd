extends Node

const CHUNK_DURATION := 0.02

var playback_player := AudioStreamPlayer.new()
var playback_stream := AudioStreamGenerator.new()
var playback_playback: AudioStreamGeneratorPlayback

var mic: AudioStreamPlayer
var capture: AudioEffectCapture
var chunk_size := int(AudioServer.get_mix_rate() * CHUNK_DURATION)

var audio_buffer: Array[Vector2] = []
var voice_buffer: PackedFloat32Array = PackedFloat32Array()
var voice_buffer_position := 0

var sound_enabled := true
var mic_enabled := true


func setup(microphone_player: AudioStreamPlayer) -> void:
	mic = microphone_player

	var idx := AudioServer.get_bus_index("MicInput")
	capture = AudioServer.get_bus_effect(idx, 0)

	AudioServer.set_bus_mute(idx, true)
	mic.play()
	
	print("VoiceChat initialized")
	print("Sample rate: ", AudioServer.get_mix_rate())
	print("Chunk size: ", chunk_size)
	print("Mic node: ", mic)
	print("Mic stream: ", mic.stream)
	print("Mic playing: ", mic.playing)
	print("Mic bus: ", mic.bus)

func _ready() -> void:
	
	add_child(playback_player)

	playback_stream.mix_rate = AudioServer.get_mix_rate()
	playback_stream.buffer_length = 0.2

	playback_player.stream = playback_stream
	playback_player.play()

	playback_playback = playback_player.get_stream_playback()

	print("Voice playback initialized")
	print("Playing: ", playback_player.playing)
	print("Playback object: ", playback_playback)
	print("Audio mix rate: ", AudioServer.get_mix_rate())
	print("Playback mix rate: ", playback_stream.mix_rate)
	
#func _process(_delta: float) -> void:
	#if playback_playback == null:
		#return
#
	#if not sound_enabled:
		#return
		#
	#var available := playback_playback.get_frames_available()
	#
	#if Engine.get_process_frames() % 60 == 0:
		#print("Voice buffer: ", voice_buffer.size(), " samples")
#
	#while available > 0 and voice_buffer.size() > 0:
		#var sample: float = voice_buffer.pop_front()
#
		#playback_playback.push_frame(
			#Vector2(sample, sample)
		#)
#
		#available -= 1
		
func _process(_delta: float) -> void:
	if playback_playback == null:
		return

	if not sound_enabled:
		return

	var available := playback_playback.get_frames_available()
	var remaining := voice_buffer.size() - voice_buffer_position
	var frames_to_push = min(available, remaining)

	if Engine.get_process_frames() % 60 == 0:
		print(
			"Voice buffer: ",
			voice_buffer.size() - voice_buffer_position,
			" samples"
		)
	
	for i in range(frames_to_push):
		var sample := voice_buffer[voice_buffer_position]

		playback_playback.push_frame(
			Vector2(sample, sample)
		)

		voice_buffer_position += 1

	if voice_buffer_position > 4096:
		voice_buffer = voice_buffer.slice(voice_buffer_position)
		voice_buffer_position = 0
	
func process_microphone() -> void:
	if not mic_enabled:
		mic.stop()
		return
		
	if capture == null:
		return

	if capture.can_get_buffer(1):
		var audio_data := capture.get_buffer(capture.get_frames_available())

		for sample in audio_data:
			audio_buffer.append(sample)

		if audio_buffer.size() >= chunk_size:
			var chunk: Array[Vector2] = audio_buffer.slice(0, chunk_size)
			
			audio_buffer = audio_buffer.slice(chunk_size)

			var pcm_data := audio_chunk_to_pcm(chunk)

			if multiplayer.is_server():
				#print("I am HOST - sending voice directly to clients")
				NetworkManager.relay_voice_data(
				multiplayer.get_unique_id(),
				pcm_data
			)
			else:
				#print("I am CLIENT - sending voice to server")
				NetworkManager.send_voice_data.rpc(pcm_data)


func audio_chunk_to_pcm(chunk: Array[Vector2]) -> PackedByteArray:
	var pcm_data := PackedByteArray()

	for sample in chunk:
		# Convert stereo to mono
		var mono := (sample.x + sample.y) / 2.0

		# Clamp to valid audio range
		mono = clamp(mono, -1.0, 1.0)

		# Convert float [-1, 1] to signed 16-bit integer
		var pcm_sample := int(mono * 32767.0)

		# Store as 2 bytes
		pcm_data.append(pcm_sample & 0xFF)
		pcm_data.append((pcm_sample >> 8) & 0xFF)

	return pcm_data
	
func pcm_to_audio_samples(pcm_data: PackedByteArray) -> PackedFloat32Array:
	var samples := PackedFloat32Array()

	# Every 2 bytes represents one 16-bit audio sample
	for i in range(0, pcm_data.size(), 2):
		var low_byte := pcm_data[i]
		var high_byte := pcm_data[i + 1]

		# Reconstruct the 16-bit integer
		var pcm_sample := low_byte | (high_byte << 8)

		# Convert unsigned representation back to signed 16-bit
		if pcm_sample >= 32768:
			pcm_sample -= 65536

		# Convert back to float [-1.0, 1.0]
		var float_sample := float(pcm_sample) / 32767.0

		samples.append(float_sample)

	return samples
	

	
func play_voice_samples(samples: PackedFloat32Array) -> void:
	voice_buffer.append_array(samples)

func test_sound() -> void:
	if playback_playback == null:
		return

	for i in range(4800):
		var sample := sin(float(i) * 0.1)
		playback_playback.push_frame(Vector2(sample, sample))
