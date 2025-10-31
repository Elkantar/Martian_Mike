extends Area2D

@export var jump_force = -300

func _on_body_entered(body: Node2D) -> void:
	
	if body is Player:
		body.jumpBoost(jump_force)
		print("player enter jumpBoost")
		queue_free()
