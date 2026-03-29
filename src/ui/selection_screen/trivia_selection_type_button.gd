extends Button

@export var value: String = ""

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	SoundManager.play_sound(SoundManager.select_sound, randf_range(0.8, 1.2), 1)
	if "Difficulty" in get_parent().name:
		TriviaDB.difficulty = value
		GameEvent.emit_signal("updated_difficulty")
	elif "Category" in get_parent().name:
		TriviaDB.category = value
		get_tree().change_scene_to_file("res://src/ui/main.tscn")
