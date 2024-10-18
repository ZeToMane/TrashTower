extends Node2D

@onready var score_label = $score_label
@onready var miss_label = $miss_label

@onready var unit_sprite = $score_board/unit
@onready var decimal_sprite = $score_board/decimal
@onready var hundred_sprite = $score_board/hundred
@onready var thousandth_sprite = $score_board/thousandth

@onready var unit_sprite_wave = $wave_board/unit

@onready var unit_sprite_clock = $clock_board/unit
@onready var decimal_sprite_clock = $clock_board/decimal
@onready var hundred_sprite_clock = $clock_board/hundred

@onready var unit_sprite_miss = $miss_board/unit
@onready var decimal_sprite_miss = $miss_board/decimal
@onready var hundred_sprite_miss = $miss_board/hundred

@onready var parent = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thousandth_sprite.frame = 0
	hundred_sprite.frame = 0
	decimal_sprite.frame = 0
	unit_sprite.frame = 0
	
	parent.update_wave_display(unit_sprite_wave)
	parent.connect("wave_updated", Callable(self, "_on_wave_updated"))
	
	parent.update_clock_display(hundred_sprite_clock, decimal_sprite_clock, unit_sprite_clock)
	parent.connect("clock_updated", Callable(self, "_on_clock_updated"))
	
	MainGame.update_score_display(thousandth_sprite, hundred_sprite, decimal_sprite, unit_sprite)
	print("Score updated my reuf")
	MainGame.connect("score_updated", Callable(self, "_on_score_updated"))
	
	MainGame.update_miss_display(hundred_sprite_miss, decimal_sprite_miss, unit_sprite_miss)
	MainGame.connect("miss_updated", Callable(self, "_on_miss_updated"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	MainGame.update_hud(score_label, miss_label)

func _on_score_updated():
	MainGame.update_score_display(thousandth_sprite, hundred_sprite, decimal_sprite, unit_sprite)

func _on_wave_updated():
	parent.update_wave_display(unit_sprite_wave)
	
func _on_clock_updated():
	parent.update_clock_display(hundred_sprite_clock, decimal_sprite_clock, unit_sprite_clock)
	
func _on_miss_updated():
	MainGame.update_miss_display(hundred_sprite_miss, decimal_sprite_miss, unit_sprite_miss)
