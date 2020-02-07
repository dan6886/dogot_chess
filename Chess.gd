extends TextureButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal select_button
export var chess_type = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_chess_button_down():
	emit_signal("select_button",self)
	pass # Replace with function body.
