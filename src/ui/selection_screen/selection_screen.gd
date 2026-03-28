extends Control

var pop_up: PackedScene = preload("res://src/ui/pop_up/pop_up.tscn")

@onready var selection_description: Label = $SelectionDescription
@onready var difficulty_buttons: Container = $DifficultyButtons
@onready var category_buttons: Container = $CategoryButtons

func _ready() -> void:
	TriviaDB.make_api_request()
	
	GameEvent.updated_difficulty.connect(_updated_difficulty)
	GameEvent.create_pop_up.connect(_instance_pop_up)
	
	difficulty_buttons.visible = true
	category_buttons.visible = false

func _updated_difficulty() -> void:
	difficulty_buttons.visible = false
	selection_description.text = "Select a Category!"
	category_buttons.visible = true

func _instance_pop_up(message: String, button_text: String) -> void:
	var pop_up_instance: PanelContainer = pop_up.instantiate()
	add_child(pop_up_instance)
	pop_up_instance.message_label.text = message
	pop_up_instance.confirm_button.text = button_text
	
	pop_up_instance.confirm_button.pressed.connect(func():
		_on_retry_connection_pressed()
		pop_up_instance.queue_free()
	)
	pop_up_instance.confirm_button.pressed.connect(_on_retry_connection_pressed)

func _on_retry_connection_pressed() -> void:
	TriviaDB.make_api_request()
