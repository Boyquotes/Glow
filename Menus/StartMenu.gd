extends Control

onready var settingsMenuPopup = get_node("SettingsMenu")

func _ready():
	VisualServer.set_default_clear_color(Color.dimgray)

func _on_StartButton_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_SettingsButton_pressed():
	settingsMenuPopup.visible = true

func _on_QuitButton_pressed():
	get_tree().quit()
