extends Node

var network = NetworkedMultiplayerENet.new()
var ip_address = "127.0.0.1"
var port = 1909

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
