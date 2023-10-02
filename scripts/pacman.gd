extends Node2D

var _rotation_speed_while_orbiting = 2
var _rotation_speed_while_shoot = 7

var _shoot_speed = 800
var _orbit_radius = 150
var _offscreen_offset = 50

var _is_orbiting = false
var _is_moving_away = false

var _last_direction_angle

var box_rotates_left = true

var game_over = false

signal throw_success
signal throw_fail

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	if _is_moving_away:
		var direction_vector = Vector2.from_angle(
			_last_direction_angle
		)
		
		position += direction_vector * delta * _shoot_speed
		rotation += _rotation_speed_while_shoot * delta
		
		reset_position()
	
	if _is_orbiting:
		var direction = -1 if box_rotates_left else 1
		
		rotation += _rotation_speed_while_orbiting * delta * direction
		
		_do_orbit_movement()

func reset_position():
	var screen_size = get_viewport_rect().size
	
	var center = screen_size / 2
	
	# if one of the following predicates is true, the pacman is offscreen
	var p1 = position.x > screen_size.x + _offscreen_offset
	var p2 = position.y > screen_size.y + _offscreen_offset
	var p3 = position.x < - _offscreen_offset
	var p4 = position.y < - _offscreen_offset
	
	if p1 or p2 or p3 or p4:
		$AnimatedSprite2D.set_frame_and_progress(0,0)
		_is_moving_away = false
		position = center
		
		box_rotates_left = randi() % 2 == 0
		throw_success.emit(box_rotates_left)

func _do_orbit_movement():
	var center = get_viewport_rect().size / 2
	
	# r = radius
	# t = angle in radians
	# (h,k) = center point
	# (x,y) = desired point on circle path
	
	# float x = r*cos(t) + h;
	# float y = r*sin(t) + k;
	
	# adjust rotation so pacman follows the circle path
	var adjusted_rotation = rotation - deg_to_rad(
		90 if box_rotates_left else -90
	)
	
	position = Vector2(
		_orbit_radius * cos(adjusted_rotation) + center.x,
		_orbit_radius * sin(adjusted_rotation) + center.y
	)
	
	_last_direction_angle = adjusted_rotation

func _shoot():
	_is_moving_away = true

func _input(event):
	var p1 = _is_moving_away
	var p2 = not event is InputEventScreenTouch
	var p3 = not is_visible_in_tree()
	var p4 = game_over
	
	if p1 or p2 or p3 or p4:
		return
	
	if event.is_pressed():
		$AnimatedSprite2D.play()
		_is_orbiting = true
		return
	
	_is_orbiting = false
	
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.set_frame_and_progress(6,0)
	
	_shoot()

# if pacman collides with the box, stop moving
func _on_area_2d_area_entered(_area):
	game_over = true
	
	_is_moving_away = false
	
	$AnimatedSprite2D.hide()
	$AnimatedSprite2D.set_frame_and_progress(0,0)
	
	$PacmanDead.show()
	
	throw_fail.emit()


func _on_hud_start_game():
	_is_moving_away = false
	
	var center = get_viewport_rect().size / 2
	position = center
	
	game_over = false
	
	$PacmanDead.hide()
	$AnimatedSprite2D.show()
	
	show()
