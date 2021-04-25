extends ChoiceBase

onready var Glossary = get_node("/root/Glossary")

onready var prison_icon = $Prison
onready var cops_icon = $Cops
onready var chilli_icon = $Chilli
onready var coffee_icon = $Coffee
onready var bee_icon = $Bee
onready var fish_icon = $Fish

var icons
var dislike_icon_idx = 0;

export (int) var anger_increase = 10
export (int) var suspicion_decrease = -5
export (int) var confession_decrease = -5

export (int) var match_reward = 5

func _ready():
	 icons = [bee_icon, prison_icon, cops_icon, chilli_icon, coffee_icon, fish_icon]


func process_choice(core: Core):
	var alteration = 0
	var anger_alteration = 0
	var suspicion_alteration = 0
	
	if core.suspect_dislike == dislike_icon_idx:
		alteration = match_reward
	
	if core.suspicion_progress >= 50:
		anger_alteration += 3
	
	if core.anger_progress >= 75:
		suspicion_alteration += 5
	
	core.alter_confession(confession_decrease)
	core.alter_suspicion(suspicion_decrease - alteration - suspicion_alteration)
	core.alter_anger(anger_increase + alteration + anger_alteration)
 

func choose_icon(core: Core):
	dislike_icon_idx = Glossary.random_enum_value(Glossary.Dislikes)
	for ico in icons:
		ico.visible = false
	
	icons[dislike_icon_idx].visible = true
