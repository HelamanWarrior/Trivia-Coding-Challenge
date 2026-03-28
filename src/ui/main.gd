extends Control

var pop_up: PackedScene = preload("res://src/ui/pop_up/pop_up.tscn")

@onready var question: Label = $Question

func _ready() -> void:
	GameEvent.create_pop_up.connect(_instance_pop_up)
	GameEvent.trivia_data_update.connect(_trivia_data_update)

func _instance_pop_up(message: String, button_text: String) -> void:
	var pop_up_instance: PanelContainer = pop_up.instantiate()
	add_child(pop_up_instance)
	pop_up_instance.message_label.text = message
	pop_up_instance.confirm_button.text = button_text

func _trivia_data_update() -> void:
	question.text = TriviaDB.filter_data_by_type(TriviaDB.trivia_data, "difficulty", "easy")[0]["question"]
