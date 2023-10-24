extends Node2D


#This code is not being used anymore


@onready var img=preload("res://icon.svg")
@onready var player=$CharacterBody2D

var head_dir=0 # (0,down),(1,right),(2,up),(3,left)

func _process(_delta):
	if Input.is_action_pressed("Down"):
		head_dir=0
	elif Input.is_action_pressed("Up"):
		head_dir=2
	elif Input.is_action_pressed("Right"):
		head_dir=1
	elif Input.is_action_pressed("Left"):
		head_dir=3
		
	if Input.is_action_just_pressed("Left_mouse"):
		on_click_left_mouse()

func on_click_left_mouse():
	#creating new nodes
	var CB=CharacterBody2D.new()
	var S2d=Sprite2D.new()
	var COb= CollisionShape2D.new()
	
	S2d.set_texture(img)#setting sprite texture to img
	
	var colling_rect=RectangleShape2D.new()#creating new rectangle object for collison shape
	colling_rect.set_size(Vector2(128.5,128))# setting size
	COb.set_shape(colling_rect)#setting collider shape

	#adding child node to char body
	CB.add_child(S2d)
	CB.add_child(COb)
	self.add_child(CB)# adding char body to main 2d node
	
	setpos(CB)
	
func setpos(CB):
	if head_dir==0: #up
		CB.set_position(Vector2(player.position.x,player.position.y+161))
	elif head_dir==2:#down
		CB.set_position(Vector2(player.position.x,player.position.y-161))
	elif head_dir==1:#right
		CB.set_position(Vector2(player.position.x+161,player.position.y))
	elif head_dir==3:#left
		CB.set_position(Vector2(player.position.x-161,player.position.y))
