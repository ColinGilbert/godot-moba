extends Node

var network = NetworkedMultiplayerENet.new()
var ip_address = "127.0.0.1"
var port = 1909
var r_id = 0
onready var scene_handler = get_node("/root/SceneHandler")

func _ready():
	start_client()
	
func start_client():
	network.create_client(ip_address, port)
	get_tree().network_peer = network
	get_tree().connect("connected_to_server", self, "connection_success")
	get_tree().connect("connection_failed", self, "connection_failed")

func connection_success():
	print("Connection success.")
	
func connection_failed():
	print("Connection failed.")

func create_room():
	rpc_id(1, "create_room")

func add_client():
	rpc_id(1, "add_client", r_id)

remote func enter_room(room_id):
	if get_tree().get_rpc_sender_id() != 1: # Important: Checks if it's the server.
		return
	r_id = int(room_id)
	var res = scene_handler.get_node_or_null("MainMenu")
	if res != null:
		print("Entering room " + str(r_id))
		res.enter_room()
	else:
		res = scene_handler.get_node_or_null("Lobby")
		if res != null:
			res.enter_room()
		else:
			print("Could not enter room")
		
func update_clients():
	rpc_id(1, "update_clients", r_id)

remote func updated_clients(client_list):
	if get_tree().get_rpc_sender_id() != 1: # Important: Checks if it's the server.
		return
	var results = scene_handler.get_node_or_null("RoomScene")
	if results != null:
		results.update_clients(client_list)

func exit_room():
	rpc_id(1, "exit_room", r_id)	

func update_rooms():
	rpc_id(1, "update_rooms")
	
remote func updated_rooms(rooms_list):
	if get_tree().get_rpc_sender_id() != 1:
		return
	var res = scene_handler.get_node_or_null("Lobby")
	if res != null:
		print("Updating rooms")
		res.updated_rooms(rooms_list)
	else:
		print("Couldn't find node Lobby")
		
func request_enter(room_id):
	rpc_id(1, "request_enter", room_id)

remote func switch_team():
	rpc_id(1, "switch_team", r_id)
