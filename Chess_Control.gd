extends Node2D
signal move_start
signal move_end
onready var tween:Tween = $"tween"
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var _target = null
func move(target):
	print("move")
	_target = target
	tween.interpolate_property(self,"position",position,target.position,2,Tween.EASE_IN,Tween.EASE_IN)
	tween.start()
	pass
	

func _on_tween_tween_completed(object, key):
	print(object,key)
	emit_signal("move_end",self,_target)
	pass # Replace with function body.

func _on_tween_tween_started(object, key):
	print(object,key)
	emit_signal("move_start",self,_target)
	pass # Replace with function body.

func set_button_disable(disable):
	print("enable1:",disable)
	get_node("chess").set_disabled(disable)
	print("enable2:",get_node("chess").is_disabled())