class_name LevelEditor
extends Node2D


const TEST = preload("res://levels/test.tscn")

var level: Level


func _ready() -> void:
	level = TEST.instantiate()
	add_child(level)
