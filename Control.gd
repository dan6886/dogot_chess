extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var maps = []
const OFFSET_X = 0
const OFFSET_Y = 0
const OFFSET = Vector2(60,40)
const CELL_WIDTH = 55
const CELL_HEIGHT = 55
enum {BCHE,BMA,BXIANG,BSHI,BJIANG,BPAO,BZU,RCHE,RMA,RXIANG,RSHI,RJIANG,RPAO,RZU,NULL}
var _textures = [
'res://res/bche.png',
'res://res/bma.png',
'res://res/bxiang.png',
'res://res/bshi.png',
'res://res/bjiang.png',
'res://res/bpao.png',
'res://res/bzu.png',
'res://res/rche.png',
'res://res/rma.png',
'res://res/rxiang.png',
'res://res/rshi.png',
'res://res/rshuai.png',
'res://res/rpao.png',
'res://res/rbing.png'
]
var is_moving = false
const images = {
	'black':{
		'che':'res://res/bche.png',
		'bjiang':'res://res/bjiang.png',
		'bma':'res://res/bma.png',
		'bxaing':'res://res/bxiang.png',
		'bpao':'res://res/bpao.png',
		'bshi':'res://res/bshi.png',
		'bzu':'res://res/bzu.png'
	},
	'red':{
		'rhe':'res://res/rche.png',
		'rjiang':'res://res/rjiang.png',
		'rma':'res://res/rma.png',
		'rxaing':'res://res/rxiang.png',
		'rpao':'res://res/rpao.png',
		'rshi':'res://res/rshi.png',
		'rzu':'res://res/rzu.png'
	}
}
onready var Chess = preload("res://Chess.tscn")

var selected_chess=null
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(10):
		maps.append([])
		for y in range(9):
			var type  = _get_type(Vector2(x,y))
			if !type == NULL:
				var button = Chess.instance()
				button.position = Vector2(y*CELL_WIDTH,x*CELL_HEIGHT)+OFFSET
#				button.get_node("chess").rect_position = Vector2(y*CELL_WIDTH,x*CELL_HEIGHT)+OFFSET
#				button.get_node("chess").rect_scale = Vector2(0.8,0.8)
				button.get_node("chess").texture_normal = load(_textures[type])
				button.get_node("chess").connect("select_button",self,"_chess_selected")
				button.connect("move_start",self,"move_start")
				button.connect("move_end",self,"move_end")
				button.get_node("chess").chess_type = type
				button.set_meta("x",x)
				button.set_meta("y",y)
				maps[x].append(button)
				add_child(button)
				button.add_to_group("chesses")

			else:
				var empty = Node2D.new()
				empty.position = Vector2(y*CELL_WIDTH,x*CELL_HEIGHT)+OFFSET
				empty.set_meta("x",x)
				empty.set_meta("y",y)
				maps[x].append(empty)
	pass # Replace with function body.
func _get_type(pos = Vector2.ZERO):
#	排列初始化的棋盘
	if (pos.x == 0 && pos.y == 0)||(pos.x ==0 && pos.y == 8):
		return BCHE
	elif (pos.x == 0 && pos.y == 1)||(pos.x ==0 && pos.y == 7):
		return BMA
	elif (pos.x == 0 && pos.y == 2)||(pos.x ==0 && pos.y == 6) :
		return BXIANG
	elif (pos.x == 0 && pos.y == 3 )||(pos.x ==0 && pos.y == 5):
		return BSHI
	elif pos.x == 0 && pos.y == 4:
		return BJIANG
	elif (pos.x == 2 && pos.y == 1) || (pos.x ==2 && pos.y == 7):
		return BPAO
	elif (pos.x == 3 && pos.y == 0)||(pos.x == 3 && pos.y == 2)||(pos.x == 3 && pos.y == 4)||(pos.x == 3 && pos.y == 6)||(pos.x == 3 && pos.y == 8):
		return BZU

	if (pos.x == 9 && pos.y == 0)||(pos.x ==9 && pos.y == 8):
		return RCHE
	elif (pos.x == 9 && pos.y == 1)||(pos.x ==9 && pos.y == 7):
		return RMA
	elif (pos.x == 9 && pos.y == 2)||(pos.x ==9 && pos.y == 6) :
		return RXIANG
	elif (pos.x == 9 && pos.y == 3 )||(pos.x ==9 && pos.y == 5):
		return RSHI
	elif pos.x == 9 && pos.y == 4:
		return RJIANG
	elif (pos.x == 7 && pos.y == 1) || (pos.x ==7 && pos.y == 7):
		return RPAO
	elif (pos.x == 6 && pos.y == 0)||(pos.x == 6 && pos.y == 2)||(pos.x == 6 && pos.y == 4)||(pos.x == 6 && pos.y == 6)||(pos.x == 6 && pos.y == 8):
		return RZU
	return NULL
# Called every frame. 'delta' is the elapsed time since the previous frame.
#warning-ignore:unused_argument
func _process(delta):
	pass

func _chess_selected(chess):
	get_node("focus2").position = chess.get_parent().position
	get_node("focus2").visible = true
	selected_chess = chess.get_parent()
	print("chess selected",chess.chess_type)
	

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
#			这里点击鼠标选择对应的位置
			print(event.position)
			var map_position = get_index_with_position(event.position)
			if map_position!=null&&!is_moving:
#				点击到了棋盘上 获取点击内容
				var target = maps[map_position.x][map_position.y]
				print(target.name)
				if target.get_child_count() !=0:
#					点击到棋子上
					selected_chess = target
					print(maps[map_position.x][map_position.y])
				else:
#					点击到棋盘上空白处
					print("click empty block")
					move_chess(selected_chess,target)
	pass
			
func get_index_with_position(input_position):
	var position_with_panel = input_position-OFFSET
	print(position_with_panel)
#	这里为了取数组方便，注意下标
	var y_index = int((position_with_panel.x+CELL_WIDTH*0.5)/CELL_WIDTH)
	var x_index = int((position_with_panel.y+CELL_HEIGHT*0.5)/CELL_HEIGHT)
	print("x:",int((position_with_panel.x+CELL_WIDTH*0.5)/CELL_WIDTH))
	print("y:",int((position_with_panel.y+CELL_HEIGHT*0.5)/CELL_HEIGHT))
	if y_index>-1&&y_index<9&&x_index>-1&&x_index<10:
		return Vector2(x_index,y_index)
	else:
		return null

func move_chess(chess,pos):
		chess.move(pos)
		pass

func move_start(chess,target):
	is_moving = true
	get_tree().call_group("chesses","set_button_disable",true)
	print("move start",target)
	get_node("focus2").set_visible(false)
	selected_chess = null
	target.position = chess.position
	pass

func move_end(chess,target):
	var x1 = target.get_meta("x")
	var y1 = target.get_meta("y")
	var x2 = chess.get_meta("x")
	var y2 = chess.get_meta("y")
	maps[x1][y1] = chess
	maps[x2][y2] = target
	chess.set_meta("x",x1)
	chess.set_meta("y",y1)
	target.set_meta("x",x2)
	target.set_meta("y",y2)
	is_moving = false
	get_tree().call_group("chesses","set_button_disable",false)
	print("move end:",x1,y1)
	print("move end:",x2,y2)
	
	
	
	
	pass	