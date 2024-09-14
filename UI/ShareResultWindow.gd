extends WindowDialog

signal accept(username)

func _on_AcceptButton_pressed():
	emit_signal("accept",$UserName.text)
	hide()
	pass

func _on_CancelButton_pressed():
	hide()
	pass
