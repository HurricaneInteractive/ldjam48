extends Node2D


func _on_TextureButton_button_up():
	get_tree().change_scene("res://investigate/scenes/Camera2DTest.tscn")
