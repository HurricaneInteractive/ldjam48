extends Node2D
class_name Core

onready var Glossary = get_node("/root/Glossary")

onready var crime_label = $ColorRect/PlayArea/Container/HSplitContainer/PrisonerInfo/MarginContainer/VBoxContainer/Crime
onready var likes_label = $ColorRect/PlayArea/Container/HSplitContainer/PrisonerInfo/MarginContainer/VBoxContainer/Likes
onready var dislikes_label = $ColorRect/PlayArea/Container/HSplitContainer/PrisonerInfo/MarginContainer/VBoxContainer/Dislikes

onready var timer_label = $ColorRect/TimerLabel
onready var timer_node = $Timer

onready var choices_container = $ColorRect/PlayArea/Container/HSplitContainer/Choices/MarginContainer/ChoicesContainer
export (PackedScene) var button_template;
var number_of_choices = 3;

onready var anger_control = $ColorRect/PlayArea/Container/HSplitContainer/ProgressionLevels/MarginContainer/VBoxContainer/HBoxContainer/Anger
onready var confession_control = $ColorRect/PlayArea/Container/HSplitContainer/ProgressionLevels/MarginContainer/VBoxContainer/HBoxContainer/Confession
onready var suspicion_control = $ColorRect/PlayArea/Container/HSplitContainer/ProgressionLevels/MarginContainer/VBoxContainer/HBoxContainer/Suspicion

onready var audio__click_effect = $ClickEffect

onready var camera = get_parent()

onready var convicted_scene = $Convicted
onready var fired_scene = $YoureFired

var anger_progress = 0
var anger_goal = 100

var confession_progress = 0
var confession_goal = 100

var suspicion_progress = 0
var suspicion_goal = 100

var suspect_crime
var suspect_like
var suspect_dislike

export (int) var play_time = 90

var game_is_over = false

func _ready():
	start_interrogation()


func start_interrogation():
	game_is_over = false
	
	convicted_scene.visible = false
	fired_scene.visible = false
	
	timer_node.stop()
	timer_node.wait_time = play_time
	timer_node.start()
	
	anger_progress = 0
	confession_progress = 0
	suspicion_progress = 0
	
	generate_suspect()
	generate_choices()


func generate_suspect():
	suspect_crime = Glossary.random_enum_value(Glossary.Crimes)
	suspect_like = Glossary.random_enum_value(Glossary.Likes)
	suspect_dislike = Glossary.random_enum_value(Glossary.Dislikes)
	
	crime_label.text = Glossary.crime_nice_name(suspect_crime)
	likes_label.text = Glossary.likes_nice_name(suspect_like)
	dislikes_label.text = Glossary.dislikes_nice_name(suspect_dislike)


func generate_choices():
	for n in choices_container.get_children():
		choices_container.remove_child(n)
		n.queue_free()

	for i in number_of_choices:
		var button_instance = button_template.instance()
		choices_container.add_child(button_instance)
		button_instance.bind_event_handler(self, "_on_choice_select")


func alter_anger(amount: int):
	anger_progress += amount
	
	if anger_progress < 0:
		anger_progress = 0
	
	if anger_progress >= 100:
		anger_progress = 100
		trigger_fail()
		pass


func alter_confession(amount: int):
	confession_progress += amount
	
	if confession_progress < 0:
		confession_progress = 0
	
	if confession_progress >= 100:
		confession_progress = 100
		trigger_win()
		pass


func alter_suspicion(amount: int):
	suspicion_progress += amount
	
	if suspicion_progress < 0:
		suspicion_progress = 0
	
	if suspicion_progress > 100:
		suspicion_progress = 100


func _process(delta):
	timer_label.text = String( floor( timer_node.time_left ) )
	
	display_progress(anger_control, anger_progress, anger_goal)
	display_progress(confession_control, confession_progress, confession_goal)
	display_progress(suspicion_control, suspicion_progress, suspicion_goal)
	
	if timer_node.time_left <= 10:
		timer_label.add_color_override("font_color", Color("#c71010"))
	elif timer_node.time_left <= 30:
		timer_label.add_color_override("font_color", Color("#ff5a00"))
	else:
		timer_label.add_color_override("font_color", Color("#ffffff"))
	
	if game_is_over:
		if Input.is_action_just_released("restart"):
			start_interrogation()
		
		if Input.is_action_just_released("menu"):
			get_tree().change_scene("res://investigate/scenes/StartScreen.tscn")


func display_progress(control: Control, progress: float, goal: float):
	var FG = control.get_node("FG")
	var BG = control.get_node("BG")
	
	if FG and BG:
		var BG_height = BG.rect_size.y
		var percentage_progressed = (progress / goal) * 100
		var grow_to = BG_height * (percentage_progressed / 100)
		FG.rect_size.y = grow_to
		FG.rect_position.y = 55 - grow_to


func _on_choice_select(btn: ChoiceButton, choice: ChoiceBase):
	audio__click_effect.play()
	choice.process_choice(self)
	generate_choices()


func shake_camera():
	camera.add_trauma(0.5)


func _on_Timer_timeout():
	trigger_fail()


func trigger_win():
	game_is_over = true
	timer_node.stop()
	camera.add_trauma(0.5)
	convicted_scene.visible = true


func trigger_fail():
	game_is_over = true
	timer_node.stop()
	camera.add_trauma(0.8)
	fired_scene.visible = true
