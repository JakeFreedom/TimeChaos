extends Node2D

signal ShotFire
@export var projectTileScene: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		var projectile = projectTileScene.instantiate()
		projectile.global_position = self.global_position
		owner.add_child(projectile)
		get_node("AudioStreamPlayer2D").play()
		ShotFire.emit()
	
