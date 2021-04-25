extends Node
class_name ChoiceBase

func process_choice(core):
	pass


func choose_icon(core):
	pass

func _on_Mouse_Entered():
	self.modulate.a = 0.8


func _on_Mouse_Exited():
	self.modulate.a = 1
