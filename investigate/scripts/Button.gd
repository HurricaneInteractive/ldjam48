extends Control
class_name ChoiceButton

onready var Glossary = get_node("/root/Glossary")

enum Type {
	CONFESSION,
	LIKE,
	DISLIKE,
	LIE
}

onready var confession_btn = $Confession
onready var like_btn = $Like
onready var dislike_btn = $Dislike
onready var lie_btn = $Lie

var button_type;

var button_node: ChoiceBase;

func _ready():
	button_type = Glossary.random_enum_value(Type)
	show_btn_option()


func show_btn_option():
	confession_btn.visible = false
	like_btn.visible = false
	dislike_btn.visible = false
	lie_btn.visible = false
	
	match button_type:
		Type.CONFESSION:
			confession_btn.visible = true
			button_node = confession_btn
		Type.DISLIKE:
			dislike_btn.visible = true
			button_node = dislike_btn
		Type.LIE:
			lie_btn.visible = true
			button_node = lie_btn
		Type.LIKE:
			like_btn.visible = true
			button_node = like_btn


func bind_event_handler(node, handler):
	button_node.connect("button_up", node, handler, [self, button_node])
	button_node.choose_icon(node)
