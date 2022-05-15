extends Control

onready var speech = get_node("Speech")
onready var typingTimer = get_node("TypingTimer")
onready var voicePlayer = get_node("VoicePlayer")

signal message_completed

var randomNumberGenerator = RandomNumberGenerator.new()
var playing_voice = false

func _ready():
	randomNumberGenerator.randomize()

func play(from_position):
	voicePlayer.pitch_scale = randomNumberGenerator.randf_range(0.95, 1.08)
	voicePlayer.play(from_position)

func update_message(message):
	speech.bbcode_text = message
	speech.visible_characters = 0
	typingTimer.start()
	playing_voice = true
	play(0.007)

func message_is_fully_visible():
	return speech.visible_characters == speech.text.length()

func _on_TypingTimer_timeout():
	if speech.visible_characters < speech.text.length():
		speech.visible_characters += 1
	else:
		typingTimer.stop()
		playing_voice = false
		emit_signal("message_completed")

func _on_VoicePlayer_finished():
	if playing_voice:
		play(0.007)
