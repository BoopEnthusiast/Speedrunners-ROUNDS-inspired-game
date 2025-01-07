class_name Lobby
extends Control


var lobby_name: String:
	set(value):
		lobby_name = value
		if _name_node:
			_name_node.text = value
		else:
			call_deferred("set_lobby_name")
var mode_name: String:
	set(value):
		mode_name = value
		if _mode:
			_mode.text = value
		else:
			call_deferred("set_lobby_mode")
var player_count_amount: int:
	set(value):
		player_count_amount = value
		if _player_count:
			_player_count.text = str(value)
		else:
			call_deferred("set_lobby_mode")

var lobby_id: int

@onready var _name_node: Label = $HBox/Name
@onready var _mode: Label = $HBox/Mode
@onready var _player_count: Label = $HBox2/PlayerCount
@onready var _join: Button = $HBox2/Join


func _on_join_pressed() -> void:
	Network.join_lobby(lobby_id)


func set_lobby_name() -> void:
	assert(is_instance_valid(_name_node), "Name node could not be found for a lobby")
	_name_node.text = lobby_name


func set_lobby_mode() -> void:
	assert(is_instance_valid(_mode), "Mode node could not be found for a lobby")
	_mode.text = mode_name


func set_player_count() -> void:
	assert(is_instance_valid(_player_count), "Player count node could not be found for a lobby")
	_player_count.text = str(player_count_amount)
