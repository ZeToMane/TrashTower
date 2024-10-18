extends Node2D

signal menu_song

@onready var music_managers = get_tree().get_nodes_in_group("MusicManager")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#emit_signal("menu_song")
	for music_manager in music_managers:
		print(music_manager)
		music_manager._on_menu_song()  # This will trigger the method manually
		#self.connect("menu_song", Callable(music_manager, "_on_menu_song"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
