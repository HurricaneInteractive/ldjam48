extends ChoiceBase

onready var Glossary = get_node("/root/Glossary")

onready var search_icon = $Search
onready var file_icon = $File
onready var note_icon = $Note

var icons

export (int) var confession_increase = 10
export (int) var suspicion_increase = 10
export (int) var anger_increase = 5

func _ready():
	 icons = [search_icon, file_icon, note_icon]


func process_choice(core: Core):
	core.alter_confession(confession_increase)
	core.alter_suspicion(suspicion_increase)
	
	# Play catch up to make the player choose other options
	if core.suspicion_progress >= 50 and core.confession_progress >= 50 and core.anger_progress < 50:
		core.alter_anger(anger_increase)


func choose_icon(core: Core):
	for ico in icons:
		ico.visible = false
	
	icons[randi() % len(icons)].visible = true
