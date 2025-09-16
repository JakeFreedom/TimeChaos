extends Node2D
#@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var sprite_2d: Sprite2D = $CharacterBody2D/Sprite2D

var speed: float = 1200.0
# Called when the node enters the scene tree for the first time.
var t: Timer
func _ready() -> void:
	t = Timer.new()
	t.timeout.connect(FreeBullet)
	t.wait_time = .8
	add_child(t)
	t.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if character_body_2d != null:
		#character_body_2d.velocity.x = speed
		#character_body_2d.move_and_slide()

func _physics_process(delta: float) -> void:
	if character_body_2d != null:
		character_body_2d.velocity.x = speed
		character_body_2d.move_and_slide()
		
func FreeBullet() -> void:
	queue_free()
