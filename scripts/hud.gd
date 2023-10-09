extends CanvasLayer

signal start_game

var score = 0

@onready var small_top_label = $SmallTopLabel
@onready var small_bottom_label = $SmallBottomLabel

@onready var play_button = $PlayButton
@onready var top_label = $TopLabel

@onready var save_manager = get_parent().get_node("SaveManager")

var showed_tutorial = false

func _ready():
	var last_highscore = save_manager.get_last_highscore()
	
	if last_highscore == -1:
		return
	
	small_bottom_label.text = "Your highscore is " + str(last_highscore)
	small_bottom_label.show()

func _process(delta):
	pass


func _on_play_button_pressed():
	showed_tutorial = false
	
	top_label.hide()
	
	score = 0
	top_label.text = str(score)
	
	small_top_label.hide()
	play_button.hide()
	
	start_game.emit()
	
	small_bottom_label.text = "Tap and hold the screen"
	small_bottom_label.show()


func _on_pacman_throw_success(new_rotation_direction):
	score += 1
	top_label.text = str(score)


func _on_pacman_throw_fail():
	top_label.text = "Game Over"
	
	small_top_label.text = "Your score is " + str(score)
	small_top_label.show()
	
	play_button.show()
	
	save_manager.save_highscore(score)
	
	var last_highscore = save_manager.get_last_highscore()
	
	if last_highscore == -1:
		return
	
	small_bottom_label.text = "Your highscore is " + str(last_highscore)
	small_bottom_label.show()


func _on_pacman_orbiting():
	if showed_tutorial:
		return
	
	small_bottom_label.hide()
	
	small_top_label.text = "Release to shoot"
	small_top_label.show()


func _on_pacman_is_moving():
	if showed_tutorial:
		return
		
	showed_tutorial = true
	
	small_top_label.hide()
	small_bottom_label.hide()
	
	top_label.show()
