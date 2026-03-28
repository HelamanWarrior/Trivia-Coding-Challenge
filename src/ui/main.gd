extends Control

@onready var question: Label = $Question

@onready var answer_1: Button = $GridContainer/Answer1
@onready var answer_2: Button = $GridContainer/Answer2
@onready var answer_3: Button = $GridContainer/Answer3
@onready var answer_4: Button = $GridContainer/Answer4

func _ready() -> void:
	GameEvent.trivia_data_update.connect(_trivia_data_update)
	
	TriviaDB.make_api_request()

func _trivia_data_update() -> void:
	#question.text = TriviaDB.load_current_question()
	pass
