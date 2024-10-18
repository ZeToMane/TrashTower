extends StaticBody2D

class_name trashSpawner

var trash_scene = preload("res://Scenes/trash.tscn")

@onready var window_sound = $window_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func spawnTrash():
	var trash_instance = trash_scene.instantiate()
	
	var animated_sprite = $AnimatedSprite2D
	
	trash_instance.position = position

	get_parent().add_child(trash_instance)
	
	animated_sprite.play("openWindow")
	window_sound.play()
	
	trash_instance.connect("trash_score", Callable(MainGame, "_on_trash_score"))
	
	trash_instance.connect("trash_score", Callable($"../Player/trashCan", "_on_trash_score"))
	
	trash_instance.connect("trash_miss", Callable($"../SoundManager", "_on_trash_miss"))
	
	trash_instance.connect("trash_score", Callable($"../SoundManager", "_on_trash_score"))
	
	trash_instance.connect("trash_miss", Callable(MainGame, "_on_trash_miss"))
