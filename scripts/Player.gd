extends KinematicBody2D

const UP : Vector2 = Vector2(0,-1)
const JUMP : float = -200.0
const MAXSINKSPEED : float = 100.0
const GRAVITY : float = 5.0

var velocity : Vector2 = Vector2.ZERO
var screen_size : Vector2 = Vector2.ZERO
var player_size :Vector2 = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x / 4, screen_size.y / 2)
	player_size = $Sprite.texture.get_size()

func _physics_process(delta):
	_move()

func _move():
	velocity.y += GRAVITY
	if velocity.y > MAXSINKSPEED:
		velocity.y = MAXSINKSPEED
	
	if Input.is_action_just_pressed("JUMP"):
		velocity.y = JUMP
	
	velocity = move_and_slide(velocity, UP)
	
	position = Vector2(
		clamp(position.x, 0, screen_size.x / 2),
		clamp(position.y, 0 + (player_size.x*0.5), (screen_size.y) - (player_size.x*0.5)) 
	)
