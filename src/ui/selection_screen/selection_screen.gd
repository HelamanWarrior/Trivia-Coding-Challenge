extends Control

@onready var selection_description: Label = $SelectionDescription
@onready var difficulty_buttons: Container = $DifficultyButtons
@onready var category_buttons: Container = $CategoryButtons

func _ready() -> void:
	GameEvent.updated_difficulty.connect(_updated_difficulty)
	
	difficulty_buttons.show()
	category_buttons.hide()
	
	SoundManager.play_background_music()

func _updated_difficulty() -> void:
	difficulty_buttons.hide()
	category_buttons.show()
	selection_description.text = "Select a Category!"
