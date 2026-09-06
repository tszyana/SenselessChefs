extends Control

@onready var mic = $MicrophonePlayer

func _ready() -> void:

	VoiceChat.setup(mic)

	print("Mic test started")
	VoiceChat.test_sound()


func _process(_delta: float) -> void:
	#VoiceChat.process_microphone()
	pass
