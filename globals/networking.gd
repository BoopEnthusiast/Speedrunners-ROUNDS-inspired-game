extends Node


var steam_id: int = 0
var steam_username: String = ""


func _init() -> void:
	print("Log file is in: ")
	print(OS.get_user_data_dir())
	
	print("Setting Steam app/game environment variables...")
	OS.set_environment("SteamAppID", str(3540120))
	OS.set_environment("SteamGameID", str(3540120))


func _ready() -> void:
	var steam_init_response: Dictionary = Steam.steamInitEx()
	print("Steam init response: ", steam_init_response)
	
	if steam_init_response['status'] > Steam.STEAM_API_INIT_RESULT_OK:
		print("Failed to initialize Steam, shutting down: ", steam_init_response)
	
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	print("Steam ID: ", steam_id)
	print("Steam Username: ", steam_username)


func _process(_delta: float) -> void:
	Steam.run_callbacks()
