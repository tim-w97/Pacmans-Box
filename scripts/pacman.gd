extends Node2D

var _speed = 0.5

@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation -= _speed * delta

func _input(event):
	if not event is InputEventScreenTouch:
		return
	
	if event.is_pressed():
		_animated_sprite.play()
		return
	
	_animated_sprite.stop()
	_animated_sprite.set_frame_and_progress(2, 0)
