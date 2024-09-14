extends Control

signal restart()
signal share_result()

func _on_Button_pressed():
	emit_signal("restart")
	pass


func _on_SaveButton_pressed():
	emit_signal("share_result")
	pass
