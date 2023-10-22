extends TextEdit

@onready var time=0

func _physics_process(delta):
	time+=delta
	if time<30:
		self.text=str(time)
	else:
		goldentime()
	
func goldentime():
	pass
