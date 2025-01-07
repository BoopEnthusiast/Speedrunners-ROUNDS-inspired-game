class_name GameManager
extends Node2D


# Game Manager variables
const MAIN_MENU = preload("res://menus/main_menu.tscn")
const PLAYER = preload("res://entities/player.tscn")

@export 
var selected_level: PackedScene

var main_menu: MainMenu
var players: Array[Player]
var level: Level

@onready 
var base_menu_layer: CanvasLayer = $BaseMenuLayer


func _ready() -> void:
	main_menu = MAIN_MENU.instantiate()
	base_menu_layer.add_child(main_menu)
	main_menu.play_pressed.connect(_on_main_menu_play_pressed)


func _on_main_menu_play_pressed() -> void:
	main_menu.queue_free()
	
	var new_player = PLAYER.instantiate()
	players.append(new_player)
	add_child(new_player)
	
	level = selected_level.instantiate()
	add_child(level)
