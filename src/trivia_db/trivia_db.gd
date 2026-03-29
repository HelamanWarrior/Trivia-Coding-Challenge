extends Node

const API_BASE_URL: String = "https://opentdb.com/api.php?"
const MAX_QUESTIONS: int = 10

var trivia_data: Array = []
var current_correct: String = ""
var current_item: int = 0
var current_score: int = 0

var difficulty: String = "medium"
var category: String = "Geography"

@onready var http_request: HTTPRequest = $TriviaRequest

func _ready() -> void:
	http_request.request_completed.connect(_on_http_request_completed)

func make_api_request() -> void:
	var api_url = API_BASE_URL + "amount=50&difficulty=" + difficulty + "&encode=base64"
	http_request.request(api_url)

func response_code_to_message(code: int) -> String:
	match code:
		1:
			return "No results: Could not return results. The API doesn't have enough questions for your query."
		2:
			return "Invalid Parameter: Contains an invalid parameter. Arguments passed in aren't valid."
		3:
			return "Token Not Found: Session Token does not exist."
		4:
			return "Token Empty: Session Token has given all possible questions for this query."
		5:
			return "Rate Limit: Too many requests have occurred. You may only access the API once every 5 seconds."
		_:
			return "Unexpected error: " + str(code)

func decode_base64_val(val: Variant) -> Variant:
	if typeof(val) == TYPE_STRING:
		return Marshalls.base64_to_utf8(val)
	
	if typeof(val) == TYPE_ARRAY:
		var decoded_array: Array = []
		for item in val:
			decoded_array.append(Marshalls.base64_to_utf8(item))
		return decoded_array
	
	return val

func decode_base64_dict(raw_dict: Dictionary) -> Dictionary:
	var clean_dict = {}
	for key in raw_dict:
		var encoded_value = raw_dict[key]
		clean_dict[key] = decode_base64_val(encoded_value)
	return clean_dict

func decode_trivia_data(raw_trivia_data: Array) -> Array:
	var decoded = []
	for item in raw_trivia_data:
		decoded.append(decode_base64_dict(item))
	return decoded

func proceed_to_next_item() -> void:
	var remaining_item_num: int = trivia_data.size() - (current_item + 1)
	if remaining_item_num < 2:
		make_api_request()
	
	if current_item + 1 >= MAX_QUESTIONS:
		GameEvent.emit_signal("all_questions_complete")
		return
	
	if trivia_data.size() > current_item + 1:
		current_item += 1
		return

func load_current_question() -> String:
	return trivia_data[current_item]["question"]

func load_current_options() -> Array:
	var options: Array = trivia_data[current_item]["incorrect_answers"]
	current_correct = trivia_data[current_item]["correct_answer"]
	options.append(current_correct)
	options.shuffle()
	return options

func is_answer_correct(answer) -> bool:
	return current_correct == answer

func filter_by_category(data: Array) -> Array:
	return data.filter(func(item):
		return item.get("category").find(category) != -1
	)

func _on_http_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		var message: String = "Network error: Are you connected to the internet?"
		GameEvent.emit_signal("create_pop_up", message, "Retry", Callable(self, "make_api_request"))
		return
	
	var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	
	if json.get("response_code") != null and json["response_code"] != 0.0:
		var message: String = response_code_to_message(json["response_code"])
		GameEvent.emit_signal("create_pop_up", message, "Retry", Callable(self, "make_api_request"))
		return
	
	var decode_data = decode_trivia_data(json["results"])
	var by_category_data = filter_by_category(decode_data)
	for item in by_category_data:
		if not trivia_data.has(item):
			trivia_data.append(item)
	
	if current_item == 0:
		GameEvent.emit_signal("trivia_data_update")

func reset() -> void:
	trivia_data = []
	current_correct = ""
	current_item = 0
	current_score = 0
