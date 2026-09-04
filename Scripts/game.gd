extends Node2D

@onready var player_pos = $playerSpawnPos
@onready var lazer_con = $LazerContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_con = $EnemyContainer
@onready var hud = $UILayer/Hud
@onready var go = $UILayer/GameOverScreen
@onready var pb = $ParallaxBackground

@onready var hitSound = $SFX/HitSound
@onready var explodeSound = $SFX/ExplodeSound
@onready var lazerSound = $SFX/LazerSound

@export var enemyscenes:Array[PackedScene] = []

var score :=0:
	set(value):
		score=value
		hud.score = score

var hiscore :=0
	
var scrollspeed =100
var player = null
# Called when the node enters the scene tree for the first time.
#@onready var player = $Player
func _ready() :
	score=0
	var save_file = FileAccess.open("user://game.data",FileAccess.READ)
	if save_file !=null:
		hiscore = save_file.get_32()
	var group_nodes = get_tree().get_nodes_in_group("player")
	player=group_nodes[1]
	print("Found the first node: ", player.name)
	print("GROUP OBJECT: ", player.name, " | CLASS: ", player.get_class())
	assert(player!=null)
	
	player.global_position = player_pos.global_position
	player.lazer_shot.connect(_on_player_lazer_shot)
	player.killed.connect(_on_player_killed)
	
func save_game():
	var save_file = FileAccess.open("user://game.data",FileAccess.WRITE)
	save_file.store_32(hiscore)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if timer.wait_time > 0.5:
		timer.wait_time -= delta * 0.005
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5
	pb.scroll_offset.y += delta * scrollspeed
	if pb.scroll_offset.y >= 960:
		pb.scroll_offset.y = 0
		
	
	

func _on_player_lazer_shot(lazer_scene,location):
	var lazer = lazer_scene.instantiate()
	lazer.global_position=location
	lazer_con.add_child(lazer)
	lazerSound.play()

func _on_player_killed():
	explodeSound.play()
	await get_tree().create_timer(1.5).timeout
	go.set_score(score)
	go.set_hiscore(hiscore)
	save_game()
	go.visible=true
	
	
func _on_enemy_spawn_timer_timeout() -> void:
	var e = enemyscenes.pick_random().instantiate()
	e.global_position=Vector2(randf_range(50,500),-50)
	e.killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	enemy_con.add_child(e)

func _on_enemy_hit():
	hitSound.play()
	
func _on_enemy_killed(points):
	hitSound.play()
	score += points
	if score >= hiscore:
		hiscore=score
	print(score)
