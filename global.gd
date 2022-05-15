extends Node

# TODO: Make sure this file location still works when you've built and installed the game please
var filepath = "res://keybinds.ini"
var configFile
var keybinds = {}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	configFile = ConfigFile.new()
	if configFile.load(filepath) == OK:
		for key in configFile.get_section_keys("keybinds"):
			var val = configFile.get_value("keybinds", key)
			if str(val) != "":
				keybinds[key] = val
			else:
				keybinds[key] = null
	else:
		print("CONFIG FILE NOT FOUND")
		get_tree().quit()
	
	set_game_binds()

func set_game_binds():
	for key in keybinds.keys():
		var val = keybinds[key]
		
		var actionList = InputMap.get_action_list(key)
		if !actionList.empty():
			InputMap.action_erase_event(key, actionList[0])
		
		if val != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(val)
			InputMap.action_add_event(key, new_key)

func write_game_binds():
	for key in keybinds.keys():
		var val = keybinds[key]
		if val != null:
			configFile.set_value("keybinds", key, val)
		else:
			configFile.set_value("keybinds", key, "")
	configFile.save(filepath)
	
