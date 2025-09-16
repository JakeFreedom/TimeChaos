extends Node2D
@onready var play: Button = $CanvasLayer/Play
@onready var quit: Button = $CanvasLayer/Quit
@onready var how_to_play: Button = $CanvasLayer/HowToPlay

#var mainGameScene = preload("res://mainScene.tscn")
func _ready() -> void:
	play.pressed.connect(PlayGame)
	quit.pressed.connect(QuitGame)
	how_to_play.pressed.connect(HowToPlay)
	
	
	
func PlayGame() -> void:
	get_tree().change_scene_to_file("res://mainScene.tscn")


func QuitGame() -> void:
	get_tree().quit()
	
func HowToPlay() -> void:
	get_tree().change_scene_to_file("res://how_to_play.tscn")
