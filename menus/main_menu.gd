class_name MainMenu
extends Control


signal play_pressed
signal join_pressed
signal editor_pressed

@onready var lobby_id: LineEdit = $VBoxContainer/LobbyID


func _on_host_pressed() -> void:
	Network.create_lobby()


func _on_join_pressed() -> void:
	join_pressed.emit()
	#var id: int = int(lobby_id.text.strip_edges())
	#Network.join_lobby(id)
	


func _on_play_pressed() -> void:
	play_pressed.emit()


func _on_editor_pressed() -> void:
	editor_pressed.emit()
