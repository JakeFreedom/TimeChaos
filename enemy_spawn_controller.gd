extends Node2D

signal Enemy_Destroyed

@export var EnemyScene: PackedScene
@export var spawnsPoints: Array[Node2D]
#Needs for this to work
#Timer - Do we need a timer for each spawn point? It seems like we will, but let's see if we can do it with just one timer.
#Enemy Scene
#Need to spawn at random intervals
#Waves ranging from elapsed time X to elapsed time X(Not sure what that means, but the longer the game is running the more frequent and bigger waves should happen.
#Health of the enemy will change as well, the longer the games runs the strong enemies will get, simply because the player should be getting stronger as well

var enemyRangeLow: float = 1.0
var enemyRangeHigh: float = 2.0
var enemySpawnRangeLow: int = 1
var enemySpawnRangeHigh: int = 6
var timer: Timer = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for item in spawnsPoints:
		#var timer: Timer
		#timer.timeout.connect(item.name)
	add_child(timer)
	timer.timeout.connect(SpawnEnemy)
	timer.wait_time = randi_range(1,1)
	timer.autostart
	timer.start()
	
	pass # Replace with function body.
  

func ResetTimerWaitTime() -> void:
	timer.wait_time=randf_range(enemyRangeLow,enemyRangeHigh)
	#print("Wait time reset to" + str(timer.wait_time))
	timer.start()	
func SpawnEnemy() -> void:
	#Here we will pick a random spawn point
		var spawnPointIndex: int = randi_range(0,3)
		
		for i in randi_range(enemySpawnRangeLow,enemySpawnRangeHigh):#the top number needs to be controlled by the length or how much time has passed since the game started
			var enemy = EnemyScene.instantiate()
		#	enemy.global_position = Vector2(-20,0)
			enemy.get_node("CharacterBody2D").on_destoryed.connect(EnemyDestroyed)
			enemy.get_node("CharacterBody2D").SpawnTimeIncreased.connect(SpawnTimeIncreased)
			enemy.find_child("Sprite2D").flip_h = true #Just make sure the sprite is facing the correct directoin.
			enemy.global_position = Vector2(0,randf_range(-10.0,10.0))
			spawnsPoints[spawnPointIndex].add_child(enemy)
			await get_tree().create_timer(.2).timeout
		ResetTimerWaitTime()
	
	#I feel like we need another random something to pick the amount of enemies in the way??? Or 
	#since there are multiple lanes, do we need that?
func EnemyDestroyed(loot: Node2D) -> void:
	Enemy_Destroyed.emit(loot)
	pass

func SpawnTimeIncreased() -> void:
	
	enemyRangeLow -= .1
	enemyRangeHigh -= .05
	#enemySpawnRangeLow += 1
	if not enemySpawnRangeHigh >=15:
		enemySpawnRangeHigh += 1
	else:
		if enemyRangeLow<5:
			enemySpawnRangeLow  += 1
