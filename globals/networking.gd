extends Node


var steam_id: int = 0
var steam_username: String = ""


func _init() -> void:
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))


func _ready() -> void:
	var steam_init_response: Dictionary = Steam.steamInitEx()
	print("Steam init: ", steam_init_response)
	
	if steam_init_response['status'] > 0:
		print("Failed to initialize Steam, shutting down: ", steam_init_response)
		get_tree().quit()
	
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()


func _process(_delta: float) -> void:
	Steam.run_callbacks()
