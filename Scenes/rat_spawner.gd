extends StaticBody2D

class_name ratSpawner

signal rat_spawn

var rat_scene = preload("res://Scenes/rat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawnRat():
	var rat_instance = rat_scene.instantiate()
	
	rat_instance.position = position

	get_parent().add_child(rat_instance)
	
	emit_signal("rat_spawn")
	self.connect("rat_spawn", Callable($"../SoundManager", "_on_rat_spawn"))
	
	var tween = get_tree().create_tween()
	tween.tween_property(rat_instance, "position:x", 100, 4)
	tween.tween_callback(Callable(rat_instance, "queue_free"))
	print("rat spawned")
