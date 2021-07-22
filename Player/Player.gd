extends KinematicBody2D

const ACCELERATION = 70
const MAX_SPEED = 70
const ROLL_SPEED = 115
const FRICTION = 700

enum {
	MOVE,
	ROLL,
	ATTACK,
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")
onready var swordhitbox = $HitboxPivot/SwordHitbox

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
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationtree.set("parameters/idle/blend_position", input_vector)
		animationtree.set("parameters/walk/blend_position", input_vector)
		animationtree.set("parameters/knife/blend_position", input_vector)
		animationtree.set("parameters/roll/blend_position", input_vector)
		animationtree.set("parameters/rangedknife/blend_position", input_vector)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animationstate.travel("walk")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationstate.travel("idle")
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("slice"):
		state = ATTACK

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationstate.travel("roll")
	move()

func move():
	velocity = move_and_slide(velocity)

func attack_state(delta):
	velocity = Vector2.ZERO
	animationstate.travel("knife")
	move()

func attack_animation_finished():
	state = MOVE


