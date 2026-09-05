extends Control

const CHUNK_DURATION := 0.02

@onready var mic = $MicrophonePlayer
var capture: AudioEffectCapture
var chunk_size := int(AudioServer.get_mix_rate() * CHUNK_DURATION)
var audio_buffer: Array[Vector2] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# We get the index of the "Record" bus.
	var idx = AudioServer.get_bus_index("MicInput")
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectCapture" resource.
	capture = AudioServer.get_bus_effect(idx, 0)
	
	# mic.play()
	
	print("mic started")
	print("Microphone started")
	print("Sample rate: ", AudioServer.get_mix_rate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if capture.can_get_buffer(1):
		var audio_data := capture.get_buffer(capture.get_frames_available())
		# print("Captured audio frames: ", audio_data.size())
		
		for sample in audio_data:
			audio_buffer.append(sample)

		if audio_buffer.size() >= chunk_size:
			var chunk: Array[Vector2] = audio_buffer.slice(0, chunk_size)

			audio_buffer = audio_buffer.slice(chunk_size)
			
			var pcm_data := audio_chunk_to_pcm(chunk)

			print("Created audio chunk: ", chunk.size(), " frames")
			print("PCM size: ", pcm_data.size(), " bytes")
			
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
