extends Camera2D

@export var target: Node2D

func _process(_delta):
	if target == null:
		return

	# Taille réelle de l'écran visible avec le zoom
	var screen_size = get_viewport_rect().size * zoom
	var half_screen = screen_size / 2

	var target_pos = target.global_position * zoom

	# Détection de la "zone de caméra" actuelle (en fonction du zoom)
	var camera_zone_x = floor(target_pos.x / screen_size.x)
	var camera_zone_y = floor(target_pos.y / screen_size.y)

	# Position de la caméra centrée sur la zone
	var new_camera_pos = Vector2(
		camera_zone_x * screen_size.x + half_screen.x,
		camera_zone_y * screen_size.y + half_screen.y
	)

	# Si la position change, on ajuste la caméra
	if global_position != new_camera_pos:
		global_position = global_position.lerp(new_camera_pos, 0.1)
