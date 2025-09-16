extends Area2D

signal on_enemy_entered
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(EnemyEntered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func EnemyEntered(otherBody: Node2D) -> void:
	on_enemy_entered.emit()
	otherBody.queue_free()
