extends CanvasLayer

signal start_game
signal save_score

var score = 0

@onready var score_label = $ScoreLabel
@onready var highscore_label = $HighscoreLabel

@onready var play_button = $PlayButton
@onready var top_label = $TopLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	score = 0
	
	score_label.hide()
	highscore_label.hide()
	play_button.hide()
	
	start_game.emit()

	top_label.text = str(score)


func _on_pacman_throw_success(new_rotation_direction):
	score += 1
	top_label.text = str(score)


func _on_pacman_throw_fail():
	top_label.text = "Game Over"
	
	score_label.text = "You got " + str(score) + " points"
	score_label.show()
	
	play_button.show()
	highscore_label.show()
	
	save_score.emit(score)
