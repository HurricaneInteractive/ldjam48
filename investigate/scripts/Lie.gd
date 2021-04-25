extends ChoiceBase

onready var Glossary = get_node("/root/Glossary")

onready var murder_icon = $Murder
onready var theft_icon = $Theft
onready var trespassing_icon = $Trespassing

var icons
var crime_icon_idx = 0;

export (int) var mismatch_pently = 20
export (int) var match_reward = 10
export (int) var default_suspicion_increase = 10
export (int) var suspicion_increase_on_fail = 20
export (int) var anger_increase = 8
export (int) var confession_increase = 10
export (int) var confession_decrease = 15

func _ready():
	 icons = [murder_icon, theft_icon, trespassing_icon]


func process_choice(core: Core):
	randomize()
	
	var current_suspicion = float(core.suspicion_progress)
	var goal = float(core.suspicion_goal)
	var percentage_filled = floor( (current_suspicion / goal) * 100 )
	var upper_limit = goal - percentage_filled
	
	if core.suspect_crime != crime_icon_idx:
		upper_limit -= mismatch_pently
	else:
		if percentage_filled > 75:
			# Bit of a boost at higher level suspicion
			upper_limit += match_reward + 5
		else:
			upper_limit += match_reward
	
	var random = rand_range(0, goal)
	
	if random <= upper_limit:
		core.alter_confession(confession_increase)
		core.alter_suspicion(default_suspicion_increase)
		core.alter_anger(floor(anger_increase / 2))
	else:
		core.alter_confession(confession_decrease * -1)
		core.alter_anger(anger_increase)
		core.alter_suspicion(suspicion_increase_on_fail)
		core.shake_camera()


func choose_icon(core: Core):
	crime_icon_idx = Glossary.random_enum_value(Glossary.Crimes)
	for ico in icons:
		ico.visible = false
	
	icons[crime_icon_idx].visible = true
