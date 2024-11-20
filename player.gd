extends CharacterBody2D

var MOVE_SPEED = 300
var charged = true
var shooting = false
var chargeScore = 1

@onready var raycast = $RayCast2D
@onready var sprite = $AnimatedSprite2D
@onready var laser = $LaserSprite
@onready var chargeTimer = $ChargeTimer

func _ready():
	await get_tree().process_frame
	get_tree().call_group("zombieMars", "set_player", self)
func _physics_process(delta):
	if charged == true:
		sprite.play("idle")
		laser.play("idleLaser")
	else:
		sprite.play("charging")
		laser.play("chargingLaser")
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	chargeScore = Global.chargeSpeed
	MOVE_SPEED = Global.speed
	chargeTimer.wait_time = chargeScore
	
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if Input.is_action_just_pressed("shoot"):
		shooting = true
	if Input.is_action_just_released("shoot"):
		shooting = false
	if charged == true && shooting == true:
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()
		sprite.play("shoot")
		laser.play("shootLaser")
		charged = false
		chargeTimer.start(-1)

func kill():
	get_tree().reload_current_scene()


func _on_charge_timer_timeout():
	charged = true
