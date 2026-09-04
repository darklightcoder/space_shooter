extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_hiscore(value):
	$Panel/HiScore.text="High Score: " + str(value)
	
func set_score(value):
	$Panel/Score.text="Score: " + str(value)
	
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
