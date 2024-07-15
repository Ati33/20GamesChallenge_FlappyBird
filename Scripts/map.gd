extends Node2D

@export var pipe_scene : PackedScene
@onready var player = $Player
@onready var wall_reset_area = $WallResetArea
@onready var floor = $Floor
@onready var ceiling = $Ceiling

@onready var score_label = $HUD/ScoreLabel
@onready var high_score_label = $HUD/HighScoreLabel

@onready var game_over_screen = $GameOver
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var pipes : Array
var pipes_to_delete : Array
var score = 0
var highscore = 0
const player_start_pos = Vector2(100, 160)
var scroll_speed = Vector2(-2, 0)


#end of screen and randomized y pos
const constPosX : int = 630
var rndPosY

# Called when the node enters the scene tree for the first time.
func _ready():
	floor.floor_hit.connect(_on_floor_hit)
	ceiling.floor_hit.connect(_on_floor_hit)
	_game_over()


func _new_game():
	$Timer.start()
	score = 0
	score_label.text = str(score)
	high_score_label.hide()
	player.position = player_start_pos
	game_over_screen.hide()
	player.gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	for pipe in pipes:
		pipes_to_delete.append(pipe)
	pipes.clear()
	for pipe_d in pipes_to_delete:
		if pipe_d != null:
			pipe_d.queue_free()


func _game_over():
	$Timer.stop()
	game_over_screen.show()
	player.gravity = 0
	high_score_label.show()
	if score > highscore:
		highscore = score
		high_score_label.text = str(highscore)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	MovePipe()


func SpawnPipe(posX, posY):
	var pipeInstance = pipe_scene.instantiate()
	pipeInstance.position.x = posX + 50 #+50 hogy slide-oljon a cső és ne csak megjelenjen
	pipeInstance.position.y = posY  
	pipeInstance.player_hit.connect(_on_player_hit) 
	pipeInstance.player_score.connect(_player_scored)
	pipeInstance.delete_pipe.connect(_pipe_deleted)
	add_child(pipeInstance)
	pipes.append(pipeInstance)


func MovePipe():
	if pipes.size() != 0:
		for pipe in pipes:
			pipe.position += scroll_speed


func _on_timer_timeout():
	rndPosY = randi_range(50, 250)
	SpawnPipe(constPosX, rndPosY)
	return rndPosY


func _on_player_hit():
	print("player hit wall")
	_game_over()


func _on_floor_hit():
	print("player hit floor")
	_game_over()


func _player_scored():
	print("player scored")
	score += 1   
	score_label.text = str(score)


func _pipe_deleted():
	print("pipe deleted")
	pipes_to_delete.append(pipes[0])
	pipes.remove_at(0)
	for pipe in pipes_to_delete:
		if pipe != null:
			pipe.queue_free()
	


func _on_game_over_restart():
	_new_game()
