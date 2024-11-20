extends Node2D

@export var zombie_scene = load("res://zombie.tscn")

@onready var spawn = $ZombieSpawn
@onready var spawnCD = $ZombieTimer

var milestone = "1"
var spawnCount = 1
var bushes = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("zombieMars", "queue_free")
	spawnCD.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.kills == 1:
		spawnCD.wait_time = 4
		Global.spawnCap=256
		milestone = "5"
	elif Global.kills == 5:
		Global.chargeSpeed=0.5
		milestone = "50"
	elif Global.kills == 50:#
		Global.chargeSpeed=0.4
		spawnCD.wait_time = 3.75
		milestone = "100"
	elif Global.kills == 100:
		spawnCD.wait_time = 3.5
		milestone = "250"
	elif Global.kills == 250:
		Global.speed=500
		spawnCount = 2
		milestone = "1000"
	elif Global.kills == 500:
		Global.chargeSpeed=0.35
		spawnCD.wait_time = 3.25
		milestone = "1250"
	elif Global.kills == 1250:
		spawnCD.wait_time = 3
		Global.spawnCap=1024
		milestone = "2500"
	elif Global.kills == 2500:
		Global.chargeSpeed=0.3
		Global.speed=750
		spawnCount = 3
		milestone = "5000"
	elif Global.kills == 5000:
		spawnCD.wait_time = 2.75
		milestone = "12050"
	elif Global.kills == 12050:
		Global.chargeSpeed=0.25
		Global.speed=1000
		spawnCD.wait_time = 2.25
		milestone = "25000"
	elif Global.kills == 25000:
		spawnCD.wait_time = 2
		spawnCount = 5
		milestone = "100000"
	elif Global.kills == 100000:
		Global.chargeSpeed=0.1
		Global.speed=1500
		spawnCD.wait_time = 1
		spawnCount = 6
		milestone = "500000"
	elif Global.kills == 500000:
		Global.chargeSpeed=0.03
		spawnCD.wait_time = 0.5
		milestone = "5000000"
	elif Global.kills == 5000000:
		milestone = "∞"

func _on_zombie_timer_timeout():
	
	for x in spawnCount:
		if bushes <= Global.spawnCap:
			var zombie = load("res://zombie.tscn").instantiate()
			
			var xpos = randf_range(0,72)*16
			var ypos = randf_range(0,40)*16
			zombie.position = Vector2(xpos,ypos)
			add_child(zombie)
			bushes += 1
