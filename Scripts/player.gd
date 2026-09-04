class_name Player extends CharacterBody2D
signal lazer_shot(lazer_scene,location)
const SPEED = 300.0
signal killed



@onready var muzzle = $Muzzle
var lazer_scene = preload("res://Scenes/lazer.tscn")

func _ready():
	add_to_group("player")
	
func die():
	killed.emit()
	queue_free()
		
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():	
	lazer_shot.emit(lazer_scene , muzzle.global_position)
	
func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction := Input.get_axis("ui_left", "ui_right")
	
	var direction = Vector2(Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down"))
	
	#if direction:
	velocity = direction * SPEED
	global_position = global_position.clamp(Vector2.ZERO,get_viewport_rect().size)
	#else:
#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
