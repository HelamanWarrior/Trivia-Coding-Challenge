extends Control

const SELECTION_SCENE: String = "res://src/ui/selection_screen/selection_screen.tscn"

const RANKS: Array = [
	"THE BLANK SLATE",     # 0
	"CURIOUS OBSERVER",    # 1
	"CURIOUS OBSERVER",    # 2 (Grouping low scores)
	"APPRENTICE SCHOLAR",  # 3
	"THE DISCIPLINE",      # 4
	"CHRONICLER",          # 5
	"LOGICIAN",            # 6
	"ERUDITE",             # 7
	"ENLIGHTENED",         # 8
	"PARAGON",             # 9
	"OMNISCIENT"           # 10
]

const MESSAGES: Array = [
	"Clean of all data. A fresh beginning.",
	"You've noticed a few patterns.",
	"You've noticed a few patterns.",
	"Collecting facts like rare coins.",
	"Hard work is starting to show.",
	"You hold the middle ground of history.",
	"Reasoning is your primary weapon.",
	"Your library of knowledge is expanding.",
	"You see the connections others miss.",
	"A model of excellence and accuracy.",
	"Total synchronization with the truth."
]

@onready var rank_label: Label = $Control/RankLabel
@onready var message_label: Label = $Control/MessageLabel
@onready var score_label: Label = $Control/VBoxContainer/ScoreLabel
@onready var percent_label: Label = $Control/VBoxContainer/PercentLabel
@onready var retry_button: Button = $Control/HBoxContainer/RetryButton
@onready var quit_button: Button = $Control/HBoxContainer/QuitButton

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	var score: int = clampi(TriviaDB.current_score, 0, RANKS.size() - 1)
	var rank = RANKS[score]
	var message = MESSAGES[score]
	var percent_correct: int = (score * 100) / TriviaDB.MAX_QUESTIONS
	
	score_label.text = "Score: " + str(score)
	rank_label.text = rank
	message_label.text = message
	percent_label.text = str(percent_correct) + "% correct."

func _on_retry_pressed() -> void:
	SoundManager.play_sound(SoundManager.select_sound, randf_range(0.8, 1.2), 1)
	TriviaDB.reset()
	get_tree().change_scene_to_file(SELECTION_SCENE)

func _on_quit_pressed() -> void:
	SoundManager.play_sound(SoundManager.select_sound, randf_range(0.8, 1.2), 1)
	get_tree().quit()
