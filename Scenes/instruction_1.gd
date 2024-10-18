extends Node2D

@export var next_scene_path = "res://Scenes/level01.tscn"
@export var instruction_node: NodePath

@onready var opening = $Opening
@onready var closing = $Closing

@onready var music_managers = get_tree().get_nodes_in_group("MusicManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Called every frame. 'delta' is the elapsed time since the previous frame.
	for music_manager in music_managers:
		print(music_manager)
		music_manager._on_menu_song()
#
	
func _process(delta: float) -> void:
	# Check if the action (left mouse click or whatever you've defined) is pressed
	if Input.is_action_just_pressed("Jump"):  # Make sure this is in your Input Map
			var tween = get_tree().create_tween()
			closing.show()
			tween.tween_callback(Callable(closing, "play").bind("default"))
			closing.connect("animation_finished", Callable(self, "_on_closing_animation_finished"))

func _on_action() -> void:
	var instruction = get_node(instruction_node)
	if instruction:
		instruction.queue_free()  # Remove the menu scene

	# Load the new scene (level01) and add it to mainGame
	var new_scene = load(next_scene_path).instantiate()
	var main_game = get_node("/root/mainGame")  # Assuming mainGame is the root or a high-level node
	if main_game:
		main_game.add_child(new_scene)
		
	
func _on_closing_animation_finished():
	_on_action()
