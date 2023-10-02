extends CanvasLayer

signal start_game

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	score = 0
	
	$BottomLabel.hide()
	$ShareButton.hide()
	$PlayButton.hide()
	
	start_game.emit()

	$TopLabel.text = str(score)


func _on_pacman_throw_success(new_rotation_direction):
	score += 1
	$TopLabel.text = str(score)


func _on_pacman_throw_fail():
	$TopLabel.text = "Game Over"
	
	$BottomLabel.text = "You got " + str(score) + " points"
	$BottomLabel.show()
	
	$ShareButton.show()
	
	$PlayButton.show()
