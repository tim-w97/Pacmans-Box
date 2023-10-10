extends Node2D

var _rotation_speed_while_orbiting = 2
var _rotation_speed_while_shoot = 7

var _shoot_speed = 900
var _orbit_radius = 150
var _offscreen_offset = 50

var _is_orbiting = false
var _is_moving_away = false

var _last_direction_angle

var box_rotates_left = true

var game_over = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var pacman_dead = $PacmanDead

@onready var munch_sound = $MunchSound
@onready var death_sound = $DeathSound
@onready var respawn_sound = $RespawnSound
@onready var whoosh_sound = $WhooshSound

var started_playing_munch = false

var last_input_event

signal orbiting
signal throw_success
signal throw_fail
signal is_moving

var max_whoosh_play_time = 0.480
	
var whoosh_play_positions = [
	0.322,
	1.361,
	2.377,
	3.508,
	4.743,
	5.844,
	6.905,
	8.060,
	9.236,
	10.312,
	11.482,
	12.533,
	13.625
]

var current_whoosh_index

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	maybe_stop_whoosh_sound()
	
	if _is_moving_away:
		var direction_vector = Vector2.from_angle(
			_last_direction_angle
		)
		
		position += direction_vector * delta * _shoot_speed
		rotation += _rotation_speed_while_shoot * delta
		
		reset_position()
	
	if _is_orbiting:
		if not munch_sound.playing:
			munch_sound.play()
		
		var direction = -1 if box_rotates_left else 1
		
		rotation += _rotation_speed_while_orbiting * delta * direction
		
		_do_orbit_movement()

func play_random_whoosh_sound():
	current_whoosh_index = randi_range(
		0, 
		whoosh_play_positions.size() - 1
	)
	
	whoosh_sound.play(whoosh_play_positions[current_whoosh_index])

func maybe_stop_whoosh_sound():
	if not whoosh_sound.playing:
		return
	
	var current_time = whoosh_sound.get_playback_position()
	var start_time = whoosh_play_positions[current_whoosh_index]
	
	var play_time = current_time - start_time
	
	if play_time > max_whoosh_play_time:
		whoosh_sound.stop()

func reset_position():
	var screen_size = get_viewport_rect().size
	
	var center = screen_size / 2
	
	# if one of the following predicates is true, the pacman is offscreen
	var p1 = position.x > screen_size.x + _offscreen_offset
	var p2 = position.y > screen_size.y + _offscreen_offset
	var p3 = position.x < - _offscreen_offset
	var p4 = position.y < - _offscreen_offset
	
	if not (p1 or p2 or p3 or p4):
		return
		
	rotation = deg_to_rad(
		randi_range(0, 360)
	)
	
	respawn_sound.play()
		
	animated_sprite.set_frame_and_progress(0,0)
	_is_moving_away = false
	position = center
	
	box_rotates_left = randi() % 2 == 0
	throw_success.emit(box_rotates_left)
	
	if last_input_event.is_pressed():
		do_orbit_movement()

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
	is_moving.emit()
	_is_moving_away = true

func _unhandled_input(event):
	last_input_event = event
	
	var p1 = _is_moving_away
	var p2 = not event is InputEventScreenTouch
	var p3 = not is_visible_in_tree()
	var p4 = game_over
	
	if p1 or p2 or p3 or p4:
		return
	
	if event.is_pressed():
		do_orbit_movement()
		return
	
	play_random_whoosh_sound()
	
	_is_orbiting = false
	
	animated_sprite.stop()
	animated_sprite.set_frame_and_progress(6,0)
	
	_shoot()

func do_orbit_movement():
	animated_sprite.play()
	_is_orbiting = true
		
	orbiting.emit()

# if pacman collides with the box, stop moving
func _on_area_2d_area_entered(_area):
	death_sound.play()
	
	game_over = true
	
	_is_moving_away = false
	
	animated_sprite.hide()
	animated_sprite.set_frame_and_progress(0,0)
	
	pacman_dead.show()
	
	throw_fail.emit()


func _on_hud_start_game():
	_is_moving_away = false
	
	var center = get_viewport_rect().size / 2
	position = center
	
	game_over = false
	
	pacman_dead.hide()
	animated_sprite.show()
	
	show()
