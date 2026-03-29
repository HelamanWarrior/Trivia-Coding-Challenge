extends Control

const results_scene: String = "res://src/ui/results_screen/results.tscn"

var correct_button: Button
var no_click: bool = false

var pop_up: PackedScene = preload("res://src/ui/pop_up/pop_up.tscn")
var confetti: PackedScene = preload("res://src/effects/confetti/confetti.tscn")

@onready var question: Label = $Question
@onready var answer_container: GridContainer = $GridContainer
@onready var answer_buttons: Array = [
	$GridContainer/Answer1,
	$GridContainer/Answer2,
	$GridContainer/Answer3,
	$GridContainer/Answer4
]
@onready var allow_proceed_timer: Timer = $AllowProceedTimer
@onready var question_number: Label = $QuestionNumber

func _ready() -> void:
	GameEvent.create_pop_up.connect(_instance_pop_up)
	GameEvent.trivia_data_update.connect(_trivia_data_update)
	
	GameEvent.correct_answer.connect(_on_correct_answer)
	GameEvent.incorrect_answer.connect(_on_incorrect_answer)
	GameEvent.all_questions_complete.connect(_on_questions_finished)
	
	allow_proceed_timer.timeout.connect(_on_allow_proceed_timeout)
	
	TriviaDB.make_api_request()

func update_button_data(buttons: Array, options: Array) -> void:
	for i in buttons.size():
		var button: Button = buttons[i]
		if i < options.size():
			button.text = options[i]
			
			if TriviaDB.is_answer_correct(options[i]):
				button.is_correct = true
				correct_button = button
		else:
			button.hide()

func _trivia_data_update() -> void:
	question.text = TriviaDB.load_current_question()
	var options: Array = TriviaDB.load_current_options()
	
	question_number.text = str(TriviaDB.current_item + 1) + "/" + str(TriviaDB.MAX_QUESTIONS)
	update_button_data(answer_buttons, options)

func display_correct_answer() -> void:
	no_click = true
	for button in answer_buttons:
		if button != correct_button:
			button.disabled = true

func reset_buttons() -> void:
	for button in answer_buttons:
		button.disabled = false
		button.is_correct = false
		button.show()

func _on_correct_answer() -> void:
	if no_click:
		return
	
	TriviaDB.current_score += 1
	display_correct_answer()
	allow_proceed_timer.start()
	
	var confetti_instance = confetti.instantiate()
	confetti_instance.global_position = Vector2(568, 695)
	add_child(confetti_instance)

func _on_incorrect_answer() -> void:
	if no_click:
		return
	
	display_correct_answer()
	allow_proceed_timer.start()

func _on_allow_proceed_timeout() -> void:
	no_click = false
	TriviaDB.proceed_to_next_item()
	reset_buttons()
	GameEvent.emit_signal("trivia_data_update")

func _instance_pop_up(message: String, button_text: String, method: Callable) -> void:
	var pop_up_instance: PanelContainer = pop_up.instantiate()
	add_child(pop_up_instance)
	pop_up_instance.message_label.text = message
	pop_up_instance.confirm_button.text = button_text
	
	pop_up_instance.confirm_button.pressed.connect(func():
		method.call()
		SoundManager.play_sound(SoundManager.select_sound, randf_range(0.8, 1.2), 1)
		pop_up_instance.queue_free()
	)

func _on_questions_finished() -> void:
	get_tree().change_scene_to_file(results_scene)
