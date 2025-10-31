extends CharacterBody2D
class_name Player


@onready var animated_sprite = $AnimatedSprite2D

@onready var collision_normal = $CollisionShape2D_Normal
@onready var collision_crouch = $CollisionShape2D_Crouch

@export var speed = 225.0
@export var jump_force = -200.0

@export var gravity := 400

var is_crouching: bool = false
var crouch_phase: String = ""
var is_dead = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	if (is_on_floor() == false):
		velocity.y += gravity * delta
		if velocity.y > 500 :
			velocity.y = 500
	
	if Input.is_action_just_pressed("jump") && (is_on_floor() == true) : 
		jump(jump_force)
	
	var direction = Input.get_axis("left", "right")
	if (direction != 0):
		animated_sprite.flip_h = (direction == -1)
	
	velocity.x = direction * speed
	move_and_slide()
	handle_crouch()
	
	update_animation(direction)

func DeathPlay() :
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite.play("Death")
#___________________________Jump___________________________#

func jump(force):
	if !is_crouching :
		velocity.y = force

func jumpBoost(force):
	jump_force += force 
	print("jumpBoost is applied :" + str(jump_force))
	await get_tree().create_timer(3.0).timeout
	jump_force -= force 
	print("jumpBoost is canceled :" + str(jump_force))
#___________________________Crouch___________________________#
func handle_crouch():		
	if Input.is_action_just_pressed("down") and is_on_floor():
		is_crouching = true
		crouch_phase = "begin"
		animated_sprite.play("Crouch_begin")
		switch_to_crouch_collision()

	elif Input.is_action_pressed("down") and is_crouching:
		# Quand l'animation "Crouch_begin" est terminée
		if animated_sprite.animation == "Crouch_begin":
			crouch_phase = "idle"
			animated_sprite.play("Crouch_idle")

	elif Input.is_action_just_released("down") and is_crouching:
		crouch_phase = "end"
		animated_sprite.play("Crouch_end")
		switch_to_standing_collision()


	# Sortir de l'état accroupi après la fin de "Crouch_end"
	if crouch_phase == "end" and animated_sprite.animation == "Crouch_end":
		is_crouching = false
		crouch_phase = ""

func switch_to_crouch_collision():
	collision_normal.disabled = true
	collision_crouch.disabled = false

func switch_to_standing_collision():
	collision_normal.disabled = false
	collision_crouch.disabled = true

func can_stand_up() -> bool:
	var space_check = Vector2(0, -10) # Test vers le haut
	return not test_move(global_transform, space_check)

#___________________________Update Animation___________________________#

func update_animation(direction) :
	if is_crouching :
		speed = 0
		return
	else :
		speed = 225
	if is_on_floor():
		if direction == 0 :
			animated_sprite.play("idle")
		else :
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("Jump")
		else :
			animated_sprite.play("fall") 


#func _on_jump_boost_touched_player() -> void:
	#jump_force *= 2
	#jump_force /= 2
