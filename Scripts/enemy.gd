class_name Enemy extends Area2D

signal killed(points)
signal hit

@export var speed = 150.0
@export var hp = 1
@export var points = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
	
func die():
	queue_free() 
	
func take_damage(amount):
	hp -= amount
	if hp <=0:
		killed.emit(points)
		die()
	else:
		hit.emit()

func _on_body_entered(body) :
	if body is Player:
		body.die()
		die()
