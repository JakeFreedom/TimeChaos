extends Node2D

var shots_fired: int = 0 #via player
var total_kills: int = 0 #via enemy
var total_health_gain: int = 0 #via enemy
var total_times_touched: int = 0 #via player
var total_enemies_through: int = 0 #via EnemyFreer
var total_elapsed_minutes: int = 0
var total_elasped_seconds: int = 0
@export var _player: PackedScene
@onready var shots_fired_label: Label = $CanvasLayer/ShotsFired
@onready var time_touched: Label = $CanvasLayer/TimeTouched
@onready var enemies_through: Label = $CanvasLayer/EnemiesThrough
@onready var total_kills_count: Label = $CanvasLayer/TotalKills
@onready var total_game_time: Label = $CanvasLayer/TotalGameTime

#stats to track
#Bullets Fired
#Total Kills
#Total Health gained to enemy
#Total Times Touched By Enemy
#Enemies that got by you
var player
func _ready() -> void:
	player = _player.instantiate()
	add_child(player)
	#print(player.get_node("CharacterBody2D").get_child_count())
	player.global_position = Vector2(55,50)
	#player.get_node("player_weapon").ShotFire.connect(ShotCount)
	player.get_node("CharacterBody2D").OnShotFired.connect(ShotCount)#This sucks, godot tells you not to put movable transforms as the root, then fucks you when you don't have the script on the root node
	player.get_node("CharacterBody2D").IWasTouched.connect(On_Touched)
	get_node("EnemyFreer").on_enemy_entered.connect(EnemyPassed)
	get_node("EnemySpawnController").Enemy_Destroyed.connect(EnemyDestroyed)
	#get_node("BackGroundMusic").play()
	#get_node("EnemySpawnController").Enemy_Destroyed.connect(EnemyDestroyed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	total_elapsed_minutes = (Time.get_ticks_msec()/1000) / 60
	total_elasped_seconds = (Time.get_ticks_msec()/1000)%60
	total_game_time.text = str(total_elapsed_minutes) + ":" + str(total_elasped_seconds)
	pass


func ShotCount() -> void:
	shots_fired += 1
	shots_fired_label.text = str(shots_fired)
	
func On_Touched() -> void:
	total_times_touched += 1
	get_node("GameTimer").SubtractTime(0.5)
	time_touched.text = str(total_times_touched)
	
func EnemyPassed() -> void:
	total_enemies_through += 1
	enemies_through.text = str(total_enemies_through)
	get_node("GameTimer").SubtractTime(1.0)

func EnemyDestroyed(loot: Node2D) -> void:
	if loot != null:
		loot.on_looted.connect(CollectLoot)
		call_deferred("add_child", loot)
	total_kills += 1
	total_kills_count.text = str(total_kills)
	

func CollectLoot(message: String) -> void:
	get_node("LootPickup").play()
	match message:
		"TIME_BUMP":
			get_node("GameTimer").AddTime(randf_range(.2,Time.get_ticks_msec()/3000))# this should be a random float
		"SPEED_BOOST":
			player.get_node("CharacterBody2D").AddToSpeed(randf_range(.1,25.0))
