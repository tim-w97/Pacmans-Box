extends Node2D

var _speed = 0.5
var is_rotating = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_rotating:
		rotation += _speed * delta

# if pacman collides with the box, stop rotating
func _on_area_2d_area_entered(area):
	is_rotating = false
