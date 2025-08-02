extends Area2D

@export var jump_force = -300
@onready var animated_sprite_jump_pad = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	
	if body is Player:
		animated_sprite_jump_pad.play("jump")
		body.jump(jump_force)
