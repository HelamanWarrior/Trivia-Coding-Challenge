extends Button

var is_correct = false

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if is_correct:
		SoundManager.play_sound(SoundManager.confirmation_sound, randf_range(0.8, 1.2), 1)
		GameEvent.emit_signal("correct_answer")
	else:
		SoundManager.play_sound(SoundManager.error_sound, randf_range(0.8, 1.2), 1)
		GameEvent.emit_signal("incorrect_answer")
