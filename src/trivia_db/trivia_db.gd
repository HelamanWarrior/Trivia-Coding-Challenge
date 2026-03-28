extends Node

var api_url: String = "https://opentdb.com/api.php?amount=10"
var trivia_data: Array = []

var difficulty: String = "medium"
var category: String = "Geography"
var current_item: int = 0

@onready var http_request: HTTPRequest = $HTTPRequest

func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)

func make_api_request() -> void:
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

func decode_html_entries(text: String) -> String:
	return text.replace("&quot;", "\"") \
			   .replace("&#039;", "'") \
			   .replace("&amp;", "&") \
			   .replace("&lt;", "<") \
			   .replace("&gt;", ">") \
			   .replace("&rsquo;", "'") \
			   .replace("&deg;", "°")

func get_filtered_questions(data: Array) -> Array:
	return data.filter(func(item):
		return item.get("difficulty") == difficulty and item.get("category") == category
	)

func load_current_question() -> String:
	return "AA"

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != http_request.RESULT_SUCCESS:
		var message: String = "Network error: Are you connected to the internet?"
		GameEvent.emit_signal("create_pop_up", message, "Retry")
		return
	
	var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	if json["response_code"] != 0.0:
		var message: String = response_code_to_message(json["response_code"])
		GameEvent.emit_signal("create_pop_up", message, "Retry")
		return
	
	trivia_data = json["results"]
	print(trivia_data)
	
	GameEvent.emit_signal("trivia_data_update")
