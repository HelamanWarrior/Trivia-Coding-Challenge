extends Node

var api_url: String = "https://opentdb.com/api.php?amount=10"
var trivia_data: Array = []

@onready var http_request: HTTPRequest = $HTTPRequest

func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(api_url)

func response_code_to_message(code: int) -> String:
	match code:
		200:
			return "Successfully connected!"
		401, 403:
			return "Authentication failed."
		429:
			return "Too many requests."
		500, 503:
			return "Server is currently offline. Try again later."
		0:
			return "Are you connected to the internet?"
		_:
			return "Unexpected error: " + str(code)

func decode_html_entries(text: String) -> String:
	return text.replace("&quot;", "\"") \
			   .replace("&#039;", "'") \
			   .replace("&amp;", "&") \
			   .replace("&lt;", "<") \
			   .replace("&gt;", ">") \
			   .replace("&rsquo;", "'") \
			   .replace("&deg;", "°")

func filter_data_by_type(trivia_data: Array, type: String, target_val: String) -> Array:
	var filted_results = []
	for item in trivia_data:
		if item.get(type) == target_val:
			filted_results.append(item)
	
	return filted_results

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != http_request.RESULT_SUCCESS:
		var message: String = "Network error: " + response_code_to_message(response_code)
		GameEvent.emit_signal("create_pop_up", message, "Retry")
		return
	
	var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	trivia_data = json["results"]
	var easy_questions = filter_data_by_type(trivia_data, "difficulty", "easy")
	print(easy_questions)
	
	GameEvent.emit_signal("trivia_data_update")
