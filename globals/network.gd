extends Node


const PACKET_READ_LIMIT: int = 32

var is_host: bool = false
var lobby_id: int = 0
var lobby_members: Array = []
var lobby_members_max: int = 5


func _ready() -> void:
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.p2p_session_request.connect(_on_p2p_session_request)
	Steam.p2p_session_connect_fail.connect(_on_p2p_session_connect_fail)
	
	# Check if the game was run by joining a friend's lobby # TODO: Come back after setting up steamworks
	var these_arguments: Array = OS.get_cmdline_args()
	# There are arguments to process
	if these_arguments.size() > 0:
		# A Steam connection argument exists
		if these_arguments[0] == "+connect_lobby":
			# Lobby invite exists so try to connect to it
			if int(these_arguments[1]) > 0:
				# At this point, you'll probably want to change scenes
				# Something like a loading into lobby screen
				print("Command line lobby ID: ", these_arguments[1])
				join_lobby(int(these_arguments[1]))


func _process(_delta: float) -> void:
	if lobby_id > 0:
		read_all_p2p_packets()


func create_lobby() -> void:
	if lobby_id == 0:
		is_host = true
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, lobby_members_max)


func _on_lobby_created(connect: int, this_lobby_id: int):
	if connect == 1:
		lobby_id = this_lobby_id
		print("Created lobby: ", lobby_id)
		
		Steam.setLobbyJoinable(lobby_id, true)
		
		Steam.setLobbyData(lobby_id, "name", "New Lobby")
		Steam.setLobbyData(lobby_id, "mode", "GodotSteam test")
		
		var set_relay: bool = Steam.allowP2PPacketRelay(true)
		print("Allowing Steam to be relay backup: ", set_relay)


func join_lobby(this_lobby_id: int): 
	print("Attempting to join lobby: " + str(this_lobby_id))
	lobby_members.clear()
	Steam.joinLobby(this_lobby_id)


func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int):
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		print("Joined lobby: " + str(this_lobby_id))
		lobby_id = this_lobby_id
		
		get_lobby_members()
		
		make_p2p_handshake()
		
		Nodes.game_manager.join_lobby()
		
	else:
		var fail_reason: String
		
		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST: fail_reason = "This lobby no longer exists."
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED: fail_reason = "You don't have permission to join this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL: fail_reason = "The lobby is now full."
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR: fail_reason = "Uh... something unexpected happened!"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED: fail_reason = "You are banned from this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED: fail_reason = "You cannot join due to having a limited account."
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED: fail_reason = "This lobby is locked or disabled."
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN: fail_reason = "This lobby is community locked."
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU: fail_reason = "A user in the lobby has blocked you from joining."
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER: fail_reason = "A user you have blocked is in the lobby."
		
		print("Failed to join this chat room: " +  fail_reason)


func get_lobby_members():
	lobby_members.clear()
	
	var num_of_lobby_members: int = Steam.getNumLobbyMembers(lobby_id)
	
	for member in range(0, num_of_lobby_members):
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id, member)
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		
		lobby_members.append({"steam_id": member_steam_id, "steam_name": member_steam_name})


func send_p2p_packet(this_target: int, packet_data: Dictionary, send_type: int = 0):
	var channel: int = 0
	var this_data: PackedByteArray
	this_data.append_array(var_to_bytes(packet_data))
	
	# If this_target is 0 it sends the packet to everyone
	if this_target == 0:
		if lobby_members.size() > 1:
			for member in lobby_members:
				if member['steam_id'] != Networking.steam_id:
					Steam.sendP2PPacket(member['steam_id'], this_data, send_type, channel)
	else:
		Steam.sendP2PPacket(this_target, this_data, send_type, channel)


func _on_p2p_session_request(remote_id: int):
	var this_requester: String = Steam.getFriendPersonaName(remote_id)
	
	Steam.acceptP2PSessionWithUser(remote_id)
	
	make_p2p_handshake()


func _on_p2p_session_connect_fail():
	pass


func make_p2p_handshake():
	print("Attemtping p2p handshake" + str({"message": "handshake", "steam_id": Networking.steam_id, "username": Networking.steam_username}))
	send_p2p_packet(0, {"message": "handshake", "steam_id": Networking.steam_id, "username": Networking.steam_username})


func read_all_p2p_packets(read_count: int = 0):
	if read_count >= PACKET_READ_LIMIT:
		return
	
	if Steam.getAvailableP2PPacketSize() > 0:
		print("Reading all p2p packets")
		read_p2p_packet()
		read_all_p2p_packets(read_count + 1)


func read_p2p_packet():
	var packet_size: int = Steam.getAvailableP2PPacketSize()
	
	if packet_size > 0:
		var this_packet: Dictionary = Steam.readP2PPacket(packet_size)
		
		var packet_sender: int = this_packet['remote_steam_id']
		
		var packet_code: PackedByteArray = this_packet['data']
		var readable_data: Dictionary = bytes_to_var(packet_code)
		
		if readable_data.has("message"):
			match readable_data["message"]:
				"handshake":
					print("Player: ", readable_data["username"], " has joined!")
					get_lobby_members()
