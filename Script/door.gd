extends Area2D

@export var target_scene_path: String = ""

var player_in_zone := false
func _on_body_entered(body: Node2D) -> void:
	if body is Player : 
		print("player est dans la zone")
		player_in_zone = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player : 
		print("player est partie de la zone")
		player_in_zone = false

func _process(delta: float) -> void:
	
	if player_in_zone and Input.is_action_just_pressed("Validate") :
		print("action")
		print(target_scene_path)
		if target_scene_path == "Quitter":
			get_tree().quit()
		elif target_scene_path != "":
			get_tree().change_scene_to_file(target_scene_path)
		else:
			print("Aucune scène cible définie !")
