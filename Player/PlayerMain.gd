class_name Player
extends KinematicBody2D

export (int) var speed: int = 60

onready var sprite = $Sprite

var digProcessPercentage: float = 0.0
onready var digProgressBar = $DigProcess
onready var digProgressBarBG = $DigProcess/BG
onready var digProgressBarFG = $DigProcess/FG
var digProgressBarMaxWidth;

onready var pressE = $PressE

var velocity: Vector2 = Vector2()

var digAvailable: bool = false
var isDigging: bool = false
var activeTombstone: Node2D
var digProcess: float = 0
var digTimer: Timer = null
var digDamage: float = 20

func _ready():
	digProgressBarMaxWidth = $DigProcess/BG.get_size().x


func get_input():
	velocity = Vector2()
	
	if Input.is_action_pressed("right"):
		sprite.scale.x = 1;
		velocity.x += 1
	if Input.is_action_pressed("left"):
		sprite.scale.x = -1;
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed;


func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)


func _process(delta):
	pressE.visible = digAvailable and !activeTombstone.is_dug();
	digProgressBar.visible = isDigging;
	
	if digAvailable:
		if Input.is_action_pressed("dig") and !activeTombstone.is_dug():
			isDigging = true
			if digTimer == null:
				performDigging()
		else:
			isDigging = false
			if digTimer != null:
				clear_timer()
			digProcess = 0
			digProgressBarFG.rect_size.x = 0


func performDigging():
	digTimer = Timer.new()
	add_child(digTimer)
	
	digTimer.connect("timeout", self, "_on_Dig_Timer_Timeout")
	digTimer.set_wait_time(0.5)
	digTimer.set_one_shot(false) # Make sure it loops
	digTimer.start()


func clear_timer():
	digTimer.stop()
	remove_child(digTimer)
	digTimer = null


func _on_Dig_Timer_Timeout():
	activeTombstone.currentHealth -= digDamage
	var percentageDown = 100 - (activeTombstone.currentHealth / activeTombstone.health) * 100
	var growTo = digProgressBarMaxWidth * (percentageDown / 100)
	digProgressBarFG.rect_size.x = growTo


func entered_dig_zone(tombstone: Node2D):
	activeTombstone = tombstone;
	digAvailable = true;


func exited_dig_zone():
	activeTombstone = null;
	digAvailable = false;
