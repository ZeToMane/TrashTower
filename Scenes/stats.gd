extends Node2D

@export var next_scene_path = "res://Scenes/menu.tscn"
@export var stats_node: NodePath

@onready var opening = $Opening
@onready var closing = $Closing
@onready var note_sprite = $Notes

@onready var unit_sprite_score = $score_stat/unit
@onready var decimal_sprite_score = $score_stat/decimal
@onready var hundred_sprite_score = $score_stat/hundred
@onready var thousandth_sprite_score = $score_stat/thousandth

@onready var unit_sprite_miss = $miss_stat/unit
@onready var decimal_sprite_miss = $miss_stat/decimal
@onready var hundred_sprite_miss = $miss_stat/hundred

@onready var music_managers = get_tree().get_nodes_in_group("MusicManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Called every frame. 'delta' is the elapsed time since the previous frame.
	MainGame.update_score_display(thousandth_sprite_score, hundred_sprite_score, decimal_sprite_score, unit_sprite_score)
	MainGame.update_miss_display(hundred_sprite_miss, decimal_sprite_miss, unit_sprite_miss)
	
	var score = MainGame.return_score()
	var miss = MainGame.return_miss()
	
	var accuracy:float = (float(score - miss) / score) * 100  # Calculate accuracy as a percentage
	print("Score: " + str(score) + "Miss "+ str(miss))

	if accuracy >= 90.0:
		note_sprite.frame = 0  # Best score
		print("A true: " + str(accuracy))
	elif accuracy >= 70.0:
		note_sprite.frame = 1
		print("B true: " + str(accuracy))
	elif accuracy >= 50.0:
		note_sprite.frame = 2
		print("C true: " + str(accuracy))
	elif accuracy >= 30.0:
		note_sprite.frame = 3
		print("D true: " + str(accuracy))
	elif accuracy >= 25.0:
		note_sprite.frame = 4
		print("E true: " + str(accuracy))
	else:
		note_sprite.frame = 5  # Worst score for anything below 25%
		print("F true " + str(accuracy))
		
	for music_manager in music_managers:
		print(music_manager)
		music_manager._on_menu_song()
		
func _process(delta: float) -> void:
	# Check if the action (left mouse click or whatever you've defined) is pressed
	if Input.is_action_just_pressed("Jump"):  # Make sure this is in your Input Map
			var tween = get_tree().create_tween()
			closing.show()
			tween.tween_callback(Callable(closing, "play").bind("default"))
			closing.connect("animation_finished", Callable(self, "_on_closing_animation_finished"))

func _on_action() -> void:
	var stats = get_node(stats_node)
	if stats:
		stats.queue_free()  # Remove the menu scene

	# Load the new scene (level01) and add it to mainGame
	var new_scene = load(next_scene_path).instantiate()
	var main_game = get_node("/root/mainGame")  # Assuming mainGame is the root or a high-level node
	if main_game:
		main_game.add_child(new_scene)
		
	
func _on_closing_animation_finished():
	_on_action()
