extends Control

const SELECTION_SCREEN = "res://src/ui/selection_screen/selection_screen.tscn"

@onready var play_button: Button = $Play
@onready var quit_button: Button = $Quit

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	SoundManager.play_sound(SoundManager.select_sound, randf_range(0.8, 1.2), 1)
	get_tree().change_scene_to_file(SELECTION_SCREEN)

func _on_quit_pressed() -> void:
	SoundManager.play_sound(SoundManager.select_sound, randf_range(0.8, 1.2), 1)
	get_tree().quit()
