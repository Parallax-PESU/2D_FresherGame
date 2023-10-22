extends Control

var peer


func _ready():
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(Connected_to_sever)
	multiplayer.connection_failed.connect(Connection_fail)
func _process(delta):
	pass

func PlayerConnected(id):
	print("player connected "+str(id))

func PlayerDisconnected(id):
	print("player disconnected"+str(id))

func Connected_to_sever(id):
	print("connected to server")

func Connection_fail(id):
	print("couldnt connect")

@rpc("any_peer","call_local")
func StartGame():
	var scene =load("res://character_body_3d.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func _on_host_button_down():
	peer= ENetMultiplayerPeer.new()
	var error = peer.create_server(135,2)
	if error!= OK:
		print("faield to host: " +str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players: ")

func _on_join_button_down():
	peer=ENetMultiplayerPeer.new()
	peer.create_client("localhost",135)
	peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	multiplayer.set_multiplayer_peer(peer)
	
func _on_start_button_down():
	StartGame.rpc()
	pass # Replace with function body.
