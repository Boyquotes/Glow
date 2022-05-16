extends CanvasLayer

const DialogueScene = preload("res://UI/Dialogue.tscn")

signal message_requested
signal message_completed

signal finished

var messages = []
var active_dialogue_offset = 0
var is_active = false
var current_dialogue_instance

func show_message(message_list, position):
	if is_active:
		return
	
	is_active = true
	messages = message_list
	active_dialogue_offset = position
	
	var dialogue = DialogueScene.instance()
	dialogue.connect("message_completed", self, "_on_message_completed")
	
	get_tree().get_root().add_child(dialogue)
	current_dialogue_instance = dialogue
	
	show_current()

func show_current():
	emit_signal("message_requested")
	var message = messages[active_dialogue_offset]
	current_dialogue_instance.update_message(message)

func _input(event):
	if (
		event.is_pressed() and 
		!event.is_echo() and 
		event is InputEventKey and 
		Input.is_action_just_pressed("next")
		and is_active 
		and current_dialogue_instance.message_is_fully_visible()
	):
		if active_dialogue_offset < messages.size() - 1:
			active_dialogue_offset += 1
			show_current()
		else:
			hide()

func _on_message_completed():
	emit_signal("message_completed")

func hide():
	current_dialogue_instance.disconnect("message_completed", self, "_on_message_completed")
	current_dialogue_instance.queue_free()
	current_dialogue_instance = null
	is_active = false
	emit_signal("finished")
