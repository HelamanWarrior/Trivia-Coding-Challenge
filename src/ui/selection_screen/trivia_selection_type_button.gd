extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var modifier: String = text.to_lower()
	if "Difficulty" in get_parent().name:
		TriviaDB.difficulty = modifier
		GameEvent.emit_signal("updated_difficulty")
	elif "Category" in get_parent().name:
		TriviaDB.category = modifier
		get_tree().change_scene_to_file("res://src/ui/main.tscn")
