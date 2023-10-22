extends ProgressBar

var Health=100
var knockback=1

@onready var player=$"../CharacterBody2D"
@onready var ray=$"../CharacterBody2D/RayCast2D"
@onready var timer=$Timer
@onready var pos=player.position.x

func _ready():
	timer.start()

func _physics_process(delta):
	self.value=Health
	knockback=101-Health
	ray.set_target_position(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Damage"):
		var vect_knock=ray.get_target_position().normalized()
		print(vect_knock)
		player.velocity.x+= -vect_knock[0]*knockback
		player.velocity.y+= -vect_knock[1]*knockback
		Health-=10

func _on_timer_timeout():
	if pos==player.position.x:
		Health-=10
	pos=player.position.x	
	timer.start()
