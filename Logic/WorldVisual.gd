extends Node

class_name WorldVisual

var world: WorldEngine = null
var width := 0
var height := 0
var h_space :int = 0
var v_space :int = 0
var offset  := Vector2()
var item_radius := 0

func _init(size:Vector2,columns: int):
	width = size.x
	height = size.y
	world = WorldEngine.new(columns)
	h_space = width / world.XSize
	v_space = height / world.YSize
	offset = Vector2(h_space / 2,v_space / 2)
	item_radius = min(h_space,v_space) / 2
	pass

func XWidth() -> int:
	return h_space

func YWidth() -> int:
	return v_space

func update_size(size:Vector2) -> void:
	width = size.x
	height = size.y
	h_space = width / world.XSize
	v_space = height / world.YSize
	offset = Vector2(h_space / 2,v_space / 2)
	item_radius = min(h_space,v_space) / 2
	pass

func get_grid() -> Array:
	var lines := []
	for i in range(world.YSize + 1):
		var line = [Vector2(0,i*v_space),Vector2(world.XSize*h_space,i*v_space)]
		lines.append(line)
		pass
	for i in range(world.XSize + 1):
		var line = [Vector2(i*h_space,0),Vector2(i*h_space,world.YSize*v_space)]
		lines.append(line)
		pass
	return lines

func FreeCells() -> Array:
	var cells = []
	for cell in world.free_cells:
		cells.append(cell)
		pass
	return cells

func MonstersSeen() -> Array:
	var monsters = []
	for monster in world.monsters_seen:
		monsters.append(Vector2(monster.x * h_space,monster.y*v_space) + offset)
		pass
	return monsters

func Player() -> Vector2:
	return Vector2(world.player_pos.x * h_space,world.player_pos.y * v_space) + offset

func MovePlayer(dir:Vector2) -> void:
	world.move_player(dir)
	pass

func Attemps() -> int:
	return world.player_attemps

func GameOver() -> bool:
	return world.game_over()

func Ranking(count:int) -> String:
	var result = ''
	var ranking := world.read_ranking()
	for i in range(min(count,ranking.size())):
		result += '%s: %d\n' % [ranking[i]['name'],ranking[i]['attemps']]
		pass
	return result

func Save(user:String,attemps:int) -> void:
	world.save_ranking(user,attemps)

func Restart() -> void:
	world.restart()
	pass
