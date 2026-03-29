extends Node

var sound_script: Script = preload("res://src/globals/sound_manager/sound.gd")
var select_sound: AudioStream = preload("res://assets/sounds/select.ogg")
var confirmation_sound: AudioStream = preload("res://assets/sounds/confirmation.ogg")
var error_sound: AudioStream = preload("res://assets/sounds/error.ogg")

@onready var background_music: AudioStreamPlayer = $BackgroundMusic

func play_sound(sound: AudioStream, pitch: float, volume: float) -> void:
	var sound_instance = AudioStreamPlayer.new()
	sound_instance.stream = sound
	sound_instance.pitch_scale = pitch
	sound_instance.volume_db = volume
	add_child(sound_instance)
	sound_instance.set_script(sound_script)
	sound_instance.play()

func play_background_music() -> void:
	if background_music.playing == false:
		background_music.play()
