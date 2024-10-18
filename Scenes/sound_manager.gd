extends AudioStreamPlayer2D

var score = preload("res://Assets/SoundDesign/objet_recolte.wav")
var miss = preload("res://Assets/SoundDesign/objet_pas_recolte.wav")
var npc = preload("res://Assets/SoundDesign/ouverture-volet.wav")
var rat = preload("res://Assets/SoundDesign/rat.wav")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_trash_miss():
	self.set_pitch_scale(1)
	self.set_stream(miss)
	self.set_volume_db(-6)
	self.play()
	
func _on_trash_score():
	self.set_pitch_scale(1)
	self.set_stream(score)
	self.set_volume_db(-6)
	self.play()
	
func _on_npc_out():
	self.set_pitch_scale(1)
	self.set_stream(npc)
	self.set_volume_db(-6)
	self.play()

func _on_rat_spawn():
	self.set_pitch_scale(1.25)
	self.set_stream(rat)
	self.set_volume_db(-3)
	self.play()
