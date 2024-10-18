extends Sprite2D

@export var next_scene_path = "res://Scenes/credit.tscn"

@export var menu_node: NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if the action (left mouse click or whatever you've defined) is pressed
	if Input.is_action_just_pressed("Click"):  # Make sure this is in your Input Map
		if is_mouse_over_sprite():
			_on_click()

func is_mouse_over_sprite() -> bool:
	var mouse_pos = get_global_mouse_position()
	var sprite_rect = Rect2(global_position - (texture.get_size() * global_scale * 0.5), texture.get_size() * global_scale)
	return sprite_rect.has_point(mouse_pos)

func _on_click() -> void:
	#print("pressed")
	var menu = get_node(menu_node)
	if menu:
		menu.queue_free()  # Remove the menu scene

	# Load the new scene (level01) and add it to mainGame
	var new_scene = load(next_scene_path).instantiate()
	var main_game = get_node("/root/mainGame")  # Assuming mainGame is the root or a high-level node
	if main_game:
		main_game.add_child(new_scene)
