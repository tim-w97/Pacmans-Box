extends CanvasLayer

signal start_game

var score = 0

@onready var bottom_label = $BottomLabel
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
	
	bottom_label.hide()
	play_button.hide()
	
	start_game.emit()

	top_label.text = str(score)


func _on_pacman_throw_success(new_rotation_direction):
	score += 1
	top_label.text = str(score)


func _on_pacman_throw_fail():
	top_label.text = "Game Over"
	
	bottom_label.text = "You got " + str(score) + " points"
	bottom_label.show()
	
	play_button.show()
