extends Node2D

var score_count = 0
var miss_count = 0

signal score_updated
signal miss_updated

#@onready var score_label = get_node("HUD").get_node("score_label")
#@onready var miss_label = get_node("HUD").get_node("miss_label")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	#score_label.text = str(score_count)
	
	#miss_label.text = str(miss_count)
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_trash_score():
	score_count += 1
	#print("Score: " + str(score_count))
	#score_label.text = str(score_count)
	#print("it was called score")
	emit_signal("score_updated")

func _on_trash_miss():
	miss_count += 1
	#print("Misses: " + str(miss_count))
	#miss_label.text = str(miss_count)
	#print("it was called miss")
	emit_signal("miss_updated")

func update_hud(score_label: Label, miss_label: Label):
	score_label.text = str(score_count)
	miss_label.text = str(miss_count)
	
func update_score_display(t: AnimatedSprite2D, h: AnimatedSprite2D, d: AnimatedSprite2D, u: AnimatedSprite2D):
	score_count = clamp(score_count, 0, 9999)
	
	var thousandth_digit = score_count / 1000
	var hundred_digit = (score_count / 100) % 10
	var decimal_digit = (score_count / 10) % 10
	var unit_digit = score_count % 10
	
	print("my score: " + str(score_count) + " Thousandth: " + str(thousandth_digit) + " Hundred: " + str(hundred_digit) + " Decimal: " + str(decimal_digit) + " Unit: " + str(unit_digit))
	t.frame = thousandth_digit
	h.frame = hundred_digit
	d.frame = decimal_digit
	u.frame = unit_digit
	
func update_miss_display(h: AnimatedSprite2D, d: AnimatedSprite2D, u: AnimatedSprite2D):
	miss_count = clamp(miss_count, 0, 999)
	
	var hundred_digit = (miss_count / 100) % 10
	var decimal_digit = (miss_count / 10) % 10
	var unit_digit = miss_count % 10
	
	h.frame = hundred_digit
	d.frame = decimal_digit
	u.frame = unit_digit
	
func return_score():
	return score_count

func return_miss():
	return miss_count
