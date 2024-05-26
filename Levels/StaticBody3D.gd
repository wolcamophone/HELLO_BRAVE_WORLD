extends StaticBody3D

@onready var animation: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("mover")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
