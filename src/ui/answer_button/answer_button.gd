extends Button

var is_correct = false

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if is_correct:
		GameEvent.emit_signal("correct_answer")
	else:
		GameEvent.emit_signal("incorrect_answer")
