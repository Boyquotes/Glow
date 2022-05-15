extends Node2D

onready var dialogueManager = get_node("UI/Narration/DialogueManager")
onready var nextLabel = get_node("UI/Narration/NextLabel")

# Todo: read from JSON file
# Have a "next function"?
	# Stretch goal.
	# Can we pause the animation UNTIL next is clicked?

var message_list = ["Fucknuggets!", "Welcome to Godot Wild Jam #45", "Lorem ipsum poo poo poo\nLorem ipsum poo poo poo\nLorem ipsum poo poo poo"]
func _ready():
	dialogueManager.show_message(message_list, 0)

func _on_DialogueManager_message_completed():
	nextLabel.visible = true

func _on_DialogueManager_message_requested():
	nextLabel.visible = false

func _on_DialogueManager_finished():
	nextLabel.visible = false
