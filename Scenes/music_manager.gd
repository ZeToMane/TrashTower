extends AudioStreamPlayer2D

var menu = preload("res://Assets/SoundDesign/Music/menu_song.mp3")
var level1 = preload("res://Assets/SoundDesign/Music/level1_song.mp3")
var level2 = preload("res://Assets/SoundDesign/Music/level2_song.mp3")
var level3 = preload("res://Assets/SoundDesign/Music/level3_song.mp3")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("MusicManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_menu_song():
	self.set_stream(menu)
	self.set_volume_db(-12)
	#menu.loop = true 
	self.play()

func _on_level1_song():
	self.set_stream(level1)
	self.set_volume_db(-12)
	self.play()
	
func _on_level2_song():
	self.set_stream(level2)
	self.set_volume_db(-12)
	self.play()

func _on_level3_song():
	self.set_stream(level3)
	self.set_volume_db(-12)
	self.play()
