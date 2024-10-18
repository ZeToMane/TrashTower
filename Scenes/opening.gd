extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("default_reverse")
	self.connect("animation_finished", Callable(self, "_on_opening_animation_finished"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_opening_animation_finished():
	self.queue_free()
