extends Node2D

signal npc_out

var i = 1
var i_pos = 400

@onready var player = $"../Player"
@onready var gameManager = get_parent()

@onready var npc1 = $NPC1
@onready var npc2 = $NPC2
@onready var npc3 = $NPC3
@onready var clouds = $"../clouds"
@onready var hud = $"../HUD"
@onready var props = $"../props_group"
@onready var closing = $"../Closing"
@onready var cutsceneTimer = $"../cutsceneTimer"




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(cutsceneTimer)
	player.connect("player_left", Callable(self, "_on_player_left"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_left():
	cutsceneTimer.start()
	print(npc1)
	print("Quoicubeh " + str(cutsceneTimer.get_time_left()))
	#npc1.show()
	hud.hide()


func _on_cutscene_timer_timeout() -> void:
	if i <= 3:
		var present_npc = get_node("NPC" + str(i))
		present_npc.show()
		emit_signal("npc_out")
		self.connect("npc_out", Callable($"../SoundManager", "_on_npc_out"))
		
		var tween = get_tree().create_tween()
		tween.tween_callback(Callable(present_npc, "play").bind("npc_" + str(i) + "_walk"))
		tween.tween_property(present_npc, "position:x", i_pos, 1)
		tween.tween_callback(Callable(present_npc, "play").bind("npc_" + str(i)))
		
		#present_npc.play("npc_1_walk")
		i += 1
		i_pos += 100
		print("npc pos: " + str(present_npc.position.x)) 
		
		print(present_npc)
		print("it's entering timeout")
	else:
		cutsceneTimer.stop()
		var tween = get_tree().create_tween()
		clouds.show()
		tween.tween_callback(Callable(clouds, "play").bind("default"))
		clouds.connect("animation_finished", Callable(self, "_on_animation_finished"))
		props.hide()

func _on_animation_finished():
	if clouds.animation == "default":  # Only react when "default" is done
		clouds.play("shine")
		clouds.connect("animation_finished", Callable(self, "_on_shine_animation_finished"))
	else:
		clouds.hide()

func _on_shine_animation_finished():
	closing.show()
	var tween = get_tree().create_tween()
	tween.tween_callback(Callable(closing, "play").bind("default"))
	closing.connect("animation_finished", Callable(self, "_on_close_animation_finished"))
	
func _on_close_animation_finished():
	if gameManager.name == "Level01":
		gameManager.queue_free()  # Remove the menu scene

		# Load the new scene (level01) and add it to mainGame
		var new_scene = load("res://Scenes/instruction_2.tscn").instantiate()
		var main_game = get_node("/root/mainGame")  # Assuming mainGame is the root or a high-level node
		if main_game:
			main_game.add_child(new_scene)
	elif gameManager.name == "Level02":
		gameManager.queue_free()  # Remove the menu scene

		# Load the new scene (level01) and add it to mainGame
		var new_scene = load("res://Scenes/instruction_3.tscn").instantiate()
		var main_game = get_node("/root/mainGame")  # Assuming mainGame is the root or a high-level node
		if main_game:
			main_game.add_child(new_scene)
	elif gameManager.name == "Level03":
		gameManager.queue_free()  # Remove the menu scene

		# Load the new scene (level01) and add it to mainGame
		var new_scene = load("res://Scenes/stats.tscn").instantiate()
		var main_game = get_node("/root/mainGame")  # Assuming mainGame is the root or a high-level node
		if main_game:
			main_game.add_child(new_scene)
	
