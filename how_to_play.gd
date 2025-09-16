extends Node2D
@onready var back_to_main: Button = $CanvasLayer/BackToMain


func _ready() -> void:
	back_to_main.pressed.connect(BackToMain)
	
	
func BackToMain() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
