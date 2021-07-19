extends KinematicBody2D

const ACCELERATION = 100
const MAX_SPEED = 70
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK,
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")

func _ready():
	animationtree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
	
		ROLL:
			roll_state(delta)
	
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if input_vector != Vector2.ZERO:
		animationtree.set("parameters/idle/blend_position", input_vector)
		animationtree.set("parameters/walk/blend_position", input_vector)
		animationtree.set("parameters/attack/blend_position", input_vector)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animationstate.travel("walk")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationstate.travel("idle")
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("slice"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animationstate.travel("attack")

func attack_animation_finished():
	state = MOVE

func roll_state(delta):
	pass
