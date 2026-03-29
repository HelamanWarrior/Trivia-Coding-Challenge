extends Node

signal create_pop_up(message: String, button_text: String, method: Callable)
signal trivia_data_update()
signal updated_difficulty()

signal incorrect_answer()
signal correct_answer()
signal all_questions_complete()
