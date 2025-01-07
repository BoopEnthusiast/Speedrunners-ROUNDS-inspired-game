class_name GameManager
extends Node2D


# Game Manager variables
const PLAYER = preload("res://entities/player.tscn")

@export 
var selected_level: PackedScene

var players: Array[Player]
var level: Level

@onready 
var base_menu_layer: CanvasLayer = $BaseMenuLayer
@onready 
var main_menu: MainMenu = $BaseMenuLayer/MainMenu
@onready 
var lobby_list: LobbyList = $BaseMenuLayer/LobbyList


func _enter_tree() -> void:
	Nodes.game_manager = self


func _on_main_menu_play_pressed() -> void:
	main_menu.visible = false
	
	var new_player = PLAYER.instantiate()
	players.append(new_player)
	add_child(new_player)
	
	level = selected_level.instantiate()
	add_child(level)

func _on_main_menu_join_pressed() -> void:
	main_menu.visible = false
	lobby_list.visible = true
	lobby_list.refresh()


func join_lobby() -> void:
	lobby_list.visible = false
	main_menu.visible = false
	
	var new_player = PLAYER.instantiate()
	players.append(new_player)
	add_child(new_player)
	
	level = selected_level.instantiate()
	add_child(level)
