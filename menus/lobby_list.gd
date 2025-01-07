class_name LobbyList
extends Control


const LOBBY = preload("res://menus/lobby.tscn")

@onready var list_box: VBoxContainer = $Margin/Scroll/HBox/List


func _ready() -> void:
	Steam.lobby_match_list.connect(_on_lobby_match_list)


func refresh() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	
	print("Requesting a lobby list")
	Steam.requestLobbyList()


func _on_lobby_match_list(these_lobbies: Array) -> void:
	print("Lobbies found: ", these_lobbies)
	for child in list_box.get_children():
		child.queue_free()
	for this_lobby in these_lobbies:
		var new_lobby_node: Lobby = LOBBY.instantiate()
		list_box.add_child(new_lobby_node)
		
		new_lobby_node.lobby_id = this_lobby
		new_lobby_node.name = "Lobby: " + str(this_lobby)
		
		new_lobby_node.lobby_name = Steam.getLobbyData(this_lobby, "name")
		new_lobby_node.mode_name = Steam.getLobbyData(this_lobby, "mode")
		new_lobby_node.player_count_amount = Steam.getNumLobbyMembers(this_lobby)
