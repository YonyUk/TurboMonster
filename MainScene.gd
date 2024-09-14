extends Node2D

var X:int = 20
var world: WorldVisual = null
var screen_size = Vector2()
var directions = Directions.new()
var movement_latency = 0
var static_latency = 5
var ranking = 10

func _ready():
	OS.window_fullscreen = true
	screen_size = OS.get_screen_size() - Vector2(0,50)
	screen_size = Vector2(min(screen_size.x,screen_size.y),min(screen_size.x,screen_size.y)) + Vector2(100,0)
	world = WorldVisual.new(screen_size,40)
	$UI/AttempsLabel.rect_global_position = Vector2(0,screen_size.y)
	var restart_button_size = $UI/RestartButton.get_rect().size
	$UI/RestartButton.rect_global_position = OS.get_screen_size() - Vector2(restart_button_size.x + 40, restart_button_size.y + 20)
	$UI/SaveButton.rect_global_position = $UI/RestartButton.rect_global_position - Vector2(restart_button_size.x / 4,restart_button_size.y * 2)
	$UI/RichTextLabel.text = world.Ranking(ranking)
	update()
	pass

func _draw():
	world.update_size(screen_size)
	draw_world(world)
	pass

func draw_world(world:WorldVisual) -> void:
	var rect_size = Vector2(world.XWidth(),world.YWidth())
	for cell in world.FreeCells():
		var rect_pos = Vector2(cell.x * world.XWidth(),cell.y * world.YWidth())
		draw_rect(Rect2(rect_pos,rect_size),Color(0.3,0.7,0))
		pass
	for line in world.get_grid():
		draw_line(line[0],line[1],Color(0,0,0),2)
		pass
	for monster in world.MonstersSeen():
		draw_circle(monster,world.item_radius,Color(0,0,0))
		pass
	draw_circle(world.Player(),world.item_radius,Color(1,0,0))
	if world.GameOver():
		Win()
		$UI/SaveButton.disabled = false
		pass
	else:
		$UI/SaveButton.disabled = true
		pass
	pass

func _process(delta):
	if movement_latency <= 0:
		movement_latency = static_latency
		if Input.is_action_pressed("move_up"):
			world.MovePlayer(directions.UP)
			pass
		elif Input.is_action_pressed("move_down"):
			world.MovePlayer(directions.DOWN)
			pass
		elif Input.is_action_pressed("move_left"):
			world.MovePlayer(directions.LEFT)
			pass
		elif Input.is_action_pressed("move_right"):
			world.MovePlayer(directions.RIGHT)
			pass
		pass
	else:
		movement_latency -= 1
		pass
	$UI/AttempsLabel.text = 'Attemps: %d' % [world.Attemps()]
	update()
	pass

func Win():
	var color = Color(0.3,0,1,0.7)
	var width = 40
	var start_pos = Vector2(screen_size.x / 5,screen_size.y / 4) + Vector2(0,50)
	draw_line(start_pos, start_pos + Vector2(120,250),color,width)
	draw_line(start_pos + Vector2(120,250),start_pos + Vector2(240,0),color,width)
	draw_line(start_pos + Vector2(240,0),start_pos + Vector2(360,250),color,width)
	draw_line(start_pos + Vector2(360,250),start_pos + Vector2(480,0),color,width)
	draw_line(start_pos + Vector2(600,0),start_pos + Vector2(600,250),color,width)
	draw_line(start_pos + Vector2(720,0),start_pos + Vector2(720,250),color,width)
	draw_line(start_pos + Vector2(720,0),start_pos + Vector2(840,250),color,width)
	draw_line(start_pos + Vector2(840,250),start_pos + Vector2(840,0),color,width)
	pass


func _on_UI_restart():
	world.Restart()
	$UI/RichTextLabel.text = world.Ranking(ranking)
	pass # Replace with function body.


func _on_UI_share_result():
	$ShareResultWindow.show()
	$ShareResultWindow.popup_centered()
	pass # Replace with function body.


func _on_ShareResultWindow_accept(username):
	world.Save(username,world.Attemps())
	pass # Replace with function body.
