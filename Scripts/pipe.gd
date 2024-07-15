extends Area2D

signal player_hit
signal player_score
signal delete_pipe

func _on_body_entered(body):
	player_hit.emit()


func _on_score_area_body_entered(body):
	player_score.emit()


func _on_area_entered(area):
	if area.name == "WallResetArea":
		delete_pipe.emit()
