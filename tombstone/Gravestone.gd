class_name Tombstone
extends Node2D

onready var Hole: Node2D = $Hole;
onready var Tombstone: Node2D = $Tombstone;

export (float) var health: float = 100.0
var currentHealth: float = health

enum State {
	Default,
	Dug
}

var current_state = State.Default


func _process(delta):
	if (currentHealth <= 0 and current_state == State.Default):
		current_state = State.Dug
	
	Hole.visible = current_state == State.Dug
	Tombstone.visible = current_state == State.Default


func is_dug() -> bool:
	return current_state == State.Dug

func _on_Area2D_body_entered(body):
	if body is Player:
		body.entered_dig_zone(self)


func _on_Area2D_body_exited(body):
	if body is Player:
		body.exited_dig_zone()
		currentHealth = health
