extends Node

var file_path = "user://highscore.txt"

func save_highscore(score):
	var file_exists = FileAccess.file_exists(file_path)
	
	var last_highscore = get_last_highscore()
	
	if file_exists and last_highscore == -1:
		return
	
	if file_exists and score <= last_highscore:
		return
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	var score_string = str(score)
	
	file.store_line(score_string)

func get_last_highscore():
	var file_exists = FileAccess.file_exists(file_path)
	
	if not file_exists:
		return -1
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	var highscore_string = file.get_line()
	
	if not highscore_string.is_valid_int():
		return -1
	
	return highscore_string.to_int()
