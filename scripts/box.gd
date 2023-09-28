extends Node2D

var speed = 0.5
var is_rotating = true
var rotate_left = true

var speed_increase = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_rotating:
		rotation += speed * delta * (1 if rotate_left else -1)

func _on_pacman_throw_success(new_rotation_direction):
	# TODO: Remove later
	is_rotating = true
	
	speed += speed_increase
	rotate_left = new_rotation_direction


func _on_pacman_throw_fail():
	is_rotating = false
