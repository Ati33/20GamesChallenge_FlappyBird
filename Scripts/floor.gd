extends Area2D

signal floor_hit

func _on_body_entered(body):
	floor_hit.emit()
