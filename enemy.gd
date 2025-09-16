#test push from main branch
extends CharacterBody2D

signal on_destoryed(LootDrop)
signal SpawnTimeIncreased
@onready var area_2d: Area2D = $Area2D

@export var drops: Array[PackedScene]  #I think we will put these here, the drop will then move along the same path the enemy was and player will have to pick it up. Just another challenge

const SPEED = 400.0
var iGainHealthWhenDamaged: bool = false
var direction: float = -1


func _ready() -> void:
	#Here is where we can determine if the enemy will gain health
	area_2d.body_entered.connect(on_body_enter)
	var doGainHealth : bool = (randf_range(0,1) * 100) < 5
	iGainHealthWhenDamaged = doGainHealth
	if iGainHealthWhenDamaged:
		#modulate.g = 128
		collision_layer = 2
		get_node("Node2D/SpecialEnemy").visible = true
		get_node("Node2D/SpecialEnemy").play("Walk")
	else:
		if randf_range(0,1) * 100 > 49:
			get_node("Node2D/MainEnemy").play("Walk")
			get_node("Node2D/MainEnemy").visible = true
		else:
			get_node("Node2D/MainEnemy2").play("Walk")
			get_node("Node2D/MainEnemy2").visible = true


#You big dummy, you can't use character body here,
#we will just have to use an area 2d or something so we can detect when the bullet hit the enemy and not just collide with it.
func _physics_process(delta: float) -> void:
	velocity.x = direction * SPEED
	move_and_slide()
	
func on_body_enter(otherBody: Node2D) -> void:
	#only if the other thing is a projectile will it remove the enemy
	if otherBody.is_in_group("Projectile"):
		#then we need to check if this enemy gains health or not
		if iGainHealthWhenDamaged:
			SpawnTimeIncreased.emit()
			otherBody.queue_free() #we can queue free the bullet, or else the player would never be able to hit the enemies behind them.
			get_parent().get_node("HitWrongEnemy").play()
			queue_free()
		else:
			otherBody.queue_free()
			
			#How to do drop
			#rand a percentage, what percentage means drop what doesn't
			#first we should calculate if there is a chace for a drop
			#then we calculte if the drop does happen
			var dropPercentage1 = (randf_range(0,1) * 100) 
			var dropPercentage2 = (randf_range(0,1) * 100)
			var lootDrop
			if(dropPercentage1<20):
				#we have a chance for a drop
				dropPercentage1 = (randf_range(0,1)*100)
				dropPercentage2 = (randf_range(0,1)*100)
				if(dropPercentage1>dropPercentage2):
					lootDrop = drops.pick_random().instantiate() as Node2D
					lootDrop.global_position = self.global_position
					get_parent().get_node("LootDrop").play()
					on_destoryed.emit(lootDrop)
					
			on_destoryed.emit(lootDrop)
			get_parent().get_node("DeathAudio").play()
			queue_free()
	

	
