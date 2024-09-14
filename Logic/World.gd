extends Node

class_name WorldEngine

var XSize := 0
var YSize := 0
var player_pos := Vector2()
var monsters_seen := []
var monsters_count := 0
var player_attemps = 1
var bussy_rows := []
var bussy_columns := []
var free_cells := []
var max_bussy_row := -1
var directions = Directions.new()

func _init(n:int):
	XSize = n
	YSize = n + 1
	monsters_count = n - 1
	for i in range(XSize):
		free_cells.append(Vector2(i,0))
		free_cells.append(Vector2(i,YSize - 1))
		pass
	randomize()
	player_pos = Vector2(int(rand_range(0,XSize)),YSize - 1)
	pass

func _is_in_range(pos:Vector2) -> bool:
	if pos.x < 0 or pos.x >= XSize or pos.y < 0 or pos.y >= YSize:
		return false
	return true

func move_player(dir:Vector2) -> void:
	_adapt(dir)
	if _is_in_range(player_pos + dir) and not game_over():
		if not player_pos + dir in monsters_seen:
			player_pos += dir
			free_cells.append(player_pos)
			pass
		else:
			player_pos = Vector2(int(rand_range(0,XSize)),YSize - 1)
			player_attemps += 1
			pass
		pass
	pass

func _adapt(dir:Vector2) -> void:
	randomize()
	var r = int(rand_range(0,1))
	if max_bussy_row == -1 and monsters_seen.size() < monsters_count:
		var possible_pos:Vector2 = player_pos + dir
		if player_pos.y == 2:
			if not possible_pos.y in bussy_rows and not possible_pos.x in bussy_columns and not possible_pos in free_cells:
				monsters_seen.append(player_pos + dir)
				bussy_columns.append(possible_pos.x)
				bussy_rows.append(possible_pos.y)
				max_bussy_row = possible_pos.y
				pass
			pass
		elif player_pos.y < YSize - 2:
			if r == 0 and not possible_pos.y in bussy_rows and not possible_pos.x in bussy_columns and not possible_pos in free_cells:
				monsters_seen.append(player_pos + dir)
				bussy_columns.append(possible_pos.x)
				bussy_rows.append(possible_pos.y)
				max_bussy_row = possible_pos.y
				pass
			pass
		pass
	elif monsters_seen.size() < monsters_count:
		var possible_pos:Vector2 = player_pos + dir
		if player_pos.y - max_bussy_row == 2:
			if not possible_pos.y in bussy_rows and not possible_pos.x in bussy_columns and not possible_pos in free_cells:
				monsters_seen.append(player_pos + dir)
				bussy_columns.append(possible_pos.x)
				bussy_rows.append(possible_pos.y)
				max_bussy_row = max(possible_pos.y,max_bussy_row)
				pass
			pass
		elif player_pos.y < YSize - 2:
			if r == 0 and not possible_pos.y in bussy_rows and not possible_pos.x in bussy_columns and not possible_pos in free_cells:
				monsters_seen.append(player_pos + dir)
				bussy_columns.append(possible_pos.x)
				bussy_rows.append(possible_pos.y)
				max_bussy_row = possible_pos.y
				pass
			pass
		pass
	pass

func game_over() -> bool:
	return player_pos.y == 0

func read_ranking() -> Array:
	var file_reader = File.new()
	file_reader.open('data.json',File.READ)
	var data = parse_json(file_reader.get_as_text())
	file_reader.close()
	return data

func save_ranking(user:String,attemps:int) -> void:
	var file_writer = File.new()
	file_writer.open('data.json',File.READ_WRITE)
	var data = parse_json(file_writer.get_as_text())
	_insert_sorted(user,attemps,data)
	file_writer.store_string(JSON.print(data))
	file_writer.close()
	pass

func _insert_sorted(username:String,attemps:int,list:Array,start:int=0,length:int=-1,inserted=false) -> void:
	if list.size() == 0:
		list.append({'name':username,'attemps':attemps})
		inserted = true
		pass
	if length == 1 and not inserted:
		if list[start]['attemps'] > attemps:
			list.insert(start,{'name':username,'attemps':attemps})
			inserted = true
			pass
		else:
			list.insert(start + 1,{'name':username,'attemps':attemps})
			inserted = true
			pass
		pass

	if length == -1 and not inserted:
		if list[list.size() / 2]['attemps'] > attemps:
			_insert_sorted(username,attemps,list,0,int(list.size() / 2),inserted)
			pass
		else:
			_insert_sorted(username,attemps,list,int(list.size() / 2),list.size() - int(list.size() / 2),inserted)
			pass
		pass
	elif list[start + int(length / 2)]['attemps'] > attemps and not inserted:
		_insert_sorted(username,attemps,list,start,int(length / 2),inserted)
		pass
	elif not inserted:
		_insert_sorted(username,attemps,list,start + int(length / 2),length - int(length / 2),inserted)
		pass
	pass

func restart() -> void:
	monsters_seen.clear()
	bussy_columns.clear()
	bussy_rows.clear()
	free_cells.clear()
	player_attemps = 1
	for i in range(XSize):
		free_cells.append(Vector2(i,0))
		free_cells.append(Vector2(i,YSize - 1))
		pass
	randomize()
	player_pos = Vector2(int(rand_range(0,XSize)),YSize - 1)
	pass
