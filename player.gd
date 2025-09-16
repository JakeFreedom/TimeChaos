extends CharacterBody2D

signal OnShotFired
signal IWasTouched
var SPEED = 300.0

var speed_boost: int = 1
@onready var area_2d: Area2D = $Area2D
var zipTimer: Timer = Timer.new()

@onready var animated_sprite_2d: AnimatedSprite2D = $Node2D/Walk

func _ready() -> void:
	get_node("PlayerWeapon").ShotFire.connect(ShotFired)
	area_2d.body_entered.connect(On_Body_Entered)
	zipTimer.wait_time=15
	add_child(zipTimer)
	zipTimer.start()
	zipTimer.paused = true


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_up", "ui_down")
	
	if(Input.is_action_pressed("ZIP")):
		speed_boost = 2
		if zipTimer.paused:
			zipTimer.paused = false
		#print(zipTimer.time_left)
	else:
		speed_boost = 1
		zipTimer.paused = true
	if direction:
		animated_sprite_2d.play("default")
		velocity.y = direction * (SPEED * speed_boost)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		#animated_sprite_2d.stop()

	move_and_slide()


func ShotFired() -> void:
	animated_sprite_2d.stop()
	animated_sprite_2d.play("Shoot")
	OnShotFired.emit()
	
func On_Body_Entered(otherBody: Node2D) -> void:
	if(otherBody.is_in_group("Enemy")):
		IWasTouched.emit()
		pass
		
func AddToSpeed(modifier: float) -> void:
	SPEED += modifier
