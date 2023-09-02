extends Node2D

var _speed = 0.5

@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation -= _speed * delta
	
	var user_tapped_screen = Input.is_action_pressed("screen_tap")
	var user_released_screen = Input.is_action_just_released("screen_tap")
	
	_animated_sprite.play()
