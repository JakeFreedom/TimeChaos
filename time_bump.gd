extends Node2D

signal on_looted

func _ready() -> void:
	get_node("Area2D").body_entered.connect(on_body_entered)
	
	
	
func on_body_entered(otherBody: Node2D) -> void:
	on_looted.emit("TIME_BUMP")
	queue_free()
