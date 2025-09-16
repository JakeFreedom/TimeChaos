extends Node2D
@onready var timer: Timer = $Timer
@onready var time_left_label: Label = $HBoxContainer/TimeLeftLabel
@onready var game_over: Label = $HBoxContainer2/GameOver

var minutesLeft: int 
var secondsLeft: float
func _ready() -> void:
	timer.timeout.connect(GameTimerExpired)
	timer.start()
	game_over.visible = false
	pass
	
func _process(delta: float) -> void:
	minutesLeft = timer.time_left / 60
	secondsLeft = int(timer.time_left) % 60
	time_left_label.text = str(minutesLeft) + ":" + str(secondsLeft)


func GameTimerExpired() -> void:
	get_tree().paused = true
	#Show Stats Screen with a couple of buttons to either quit or retry
	#maybe if there is time to keep track of best scores
	game_over.visible = true
	pass
	
func SubtractTime(time: int) -> void:
	var timeLeft = timer.time_left
	if timeLeft-time <= 0:
		time_left_label.text = "00:00"
		GameTimerExpired()
	timer.stop()
	timer.wait_time = timeLeft-time
	timer.start()
	
	
	
func AddTime(timeToAdd: int) -> void:
	var timeLeft = timer.time_left
	timer.stop()
	timer.wait_time = timeLeft+timeToAdd
	timer.start()

	
