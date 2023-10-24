extends CharacterBody2D


@export var SPEED = 600.0
@export var JUMP_VELOCITY = -700.0
@onready var img=preload("res://icon.svg")
var head_dir=0 # (0,down),(1,right),(2,up),(3,left)


func _ready():
	$"../MultiplayerSynchronizer".set_multiplayer_authority(str($"..".name).to_int())

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	if $"../MultiplayerSynchronizer".get_multiplayer_authority() == multiplayer.get_unique_id():
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("Up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		if Input.is_action_pressed("Down"):
			head_dir=0
		elif Input.is_action_pressed("Up"):
			head_dir=2
		elif Input.is_action_pressed("Right"):
			head_dir=1
		elif Input.is_action_pressed("Left"):
			head_dir=3
			
		if Input.is_action_just_pressed("Left_mouse"):
			on_click_left_mouse.rpc(delta)
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()

@rpc("any_peer",'call_local')
func on_click_left_mouse(delta):
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
	$"..".add_child(CB)# adding char body to main 2d node

	var time=Timer.new()
	CB.add_child(time)
	time.one_shot=true
	time.autostart=false
	time.wait_time=2
	time.timeout.connect(_time)
	time.start()
	
	#$"../MultiplayerSynchronizer".set_replication_config.add_property(CB.position)

	setpos(CB)

func _time():
	$"..".remove_child($"..".get_child(3))
	pass

func setpos(CB):
	if head_dir==0: #down
		CB.set_position(Vector2(self.position.x,self.position.y+161))
	elif head_dir==2:#up
		CB.set_position(Vector2(self.position.x,self.position.y-96))
	elif head_dir==1:#right
		CB.set_position(Vector2(self.position.x+130,self.position.y+33))
	elif head_dir==3:#left
		CB.set_position(Vector2(self.position.x-130,self.position.y+33))
