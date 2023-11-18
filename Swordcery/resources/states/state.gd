extends Node
class_name State

signal Transitioned

@export var transitionState : State

func Enter_State():
	pass

func Exit_State():
	pass

func Update_State(_delta: float):
	pass

func Physics_Update_State(_delta: float):
	pass
