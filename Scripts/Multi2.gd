extends Control

var peer
@export var add="127.0.0.1"
@export var port = 8910

func _ready():
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(Connected_to_sever)
	multiplayer.connection_failed.connect(Connection_fail)

func _process(delta):
	pass

func PlayerConnected(id):
	SendInfo.rpc_id(1,"Player2",multiplayer.get_unique_id())
	print("player connected "+str(id))

func PlayerDisconnected(id):
	print("player disconnected"+str(id))

func Connected_to_sever(id):
	print("connected to server")

func Connection_fail(id):
	print("couldnt connect")

@rpc("any_peer")
func SendInfo(name,id):
	if !GameManager.Players.has(id):
		GameManager.Players[id]={
			"name":name,
			"id" :id,
			"score":0
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendInfo.rpc(GameManager.Players[i].name,i)

@rpc("any_peer","call_local")
func StartGame():
	var scene =load("res://Scenes/MainScene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func _on_host_button_down():
	peer= ENetMultiplayerPeer.new()
	var error = peer.create_server(port,2)
	if error!= OK:
		print("faield to host: " +str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players: ")
	SendInfo("Player1",multiplayer.get_unique_id())

func _on_join_button_down():
	peer=ENetMultiplayerPeer.new()
	peer.create_client(add,port)
	peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	multiplayer.set_multiplayer_peer(peer)
	
func _on_start_button_down():
	StartGame.rpc()
	pass # Replace with function body.
