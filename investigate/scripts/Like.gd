extends ChoiceBase

onready var Glossary = get_node("/root/Glossary")

onready var cat_icon = $Cat
onready var dog_icon = $Dog
onready var food_icon = $Food
onready var coffee_icon = $Coffee
onready var running_icon = $Running
onready var reading_icon = $Reading

var icons
var like_icon_idx

export (int) var anger_decrease = -10
export (int) var suspicion_increase = 5
export (int) var confession_decrease = -5

export (int) var match_reward = 5


func _ready():
	icons = [dog_icon, cat_icon, food_icon, running_icon, coffee_icon, reading_icon]


func process_choice(core: Core):
	var alteration = 0
	if core.suspect_like == like_icon_idx:
		alteration = match_reward
	else:
		alteration = -5
	
	core.alter_suspicion(suspicion_increase)
	core.alter_confession(confession_decrease)
	core.alter_anger(anger_decrease - alteration)


func choose_icon(core: Core):
	like_icon_idx = Glossary.random_enum_value(Glossary.Likes)
	for ico in icons:
		ico.visible = false
	
	icons[like_icon_idx].visible = true
