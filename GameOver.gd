extends Node2D


func _ready():
	if Global.time < 0:
		$Lost.show()
	else:
		$Won.show()
	
