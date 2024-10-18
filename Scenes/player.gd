extends CharacterBody2D

signal player_left

@export var SPEED = 10.0
@export var MAX_SPEED = 500
const JUMP_VELOCITY = -350.0

var last_direction = 0

var i = 0

var win_happened = false
var rat_happened = false

@onready var animatedSprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var rat_happened_timer = $"../ratHappenedTimer"
@onready var rat_effect_material = preload("res://Scenes/flash.gdshader")

@onready var parent = get_parent()

func _ready() -> void:
	parent.connect("win", Callable(self, "_on_win"))

func _process(delta: float):
	for child in get_parent().get_children():

		if child is Rat:
			if not child.is_connected("rat_touched", Callable(self, "_on_rat_touch")):
				child.connect("rat_touched", Callable(self, "_on_rat_touch"))
	# Add the gravity.
	if !win_happened and !rat_happened:
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.

		if Input.is_action_just_pressed("Left"):
			last_direction = -1
			animatedSprite.play("walkLeft")
		elif Input.is_action_just_pressed("Right"):
			last_direction = 1
			animatedSprite.play("walkRight")

		# Handle movement using last direction
		var direction := Input.get_axis("Left", "Right")

		if direction == 0 and (Input.is_action_pressed("Left") or Input.is_action_pressed("Right")):
			direction = last_direction
		elif direction == 0:
			animatedSprite.play("default")

		if direction != 0:
			if velocity.x >= MAX_SPEED:
				velocity.x = direction + MAX_SPEED
				animatedSprite.play("runRight")
			elif velocity.x <= -MAX_SPEED:
				velocity.x = direction - MAX_SPEED
				animatedSprite.play("runLeft")
			else:
				velocity.x += direction * SPEED
				
			if velocity.x > 0:
				if direction < 0:
					velocity.x = move_toward(velocity.x, 0, 20)
					animatedSprite.play("walkLeft")
			elif velocity.x < 0:
				if direction > 0:
					velocity.x = move_toward(velocity.x, 0, 20)
					animatedSprite.play("walkRight")
			#print("player speed: " + str(velocity.x))
			
		else:
			velocity.x = move_toward(velocity.x, 0, 15)
			
		#print("player speed: " + str(velocity.x))
	else:
		if !rat_happened:
			collision.set_disabled(true)
			self.collision_layer = 0
			self.collision_mask = 0
			animatedSprite.play("walkRight")
			velocity.x = 0
			velocity.y = 0
			self.position.x = move_toward(position.x, 0, -2)
			self.position.y = move_toward(position.y, 619.776123046875, 20)
			#print("Position " + str(position.x))
			if position.x >= 980 and i == 0:
				self.hide()
				emit_signal("player_left")
				i += 1
	
func _on_win():
	win_happened = true

func _on_rat_touch():
	rat_happened = true
	rat_happened_timer.start()
	
	velocity.x = 0
	velocity.y = 0
	
	
	var shader_material = ShaderMaterial.new()
	shader_material.shader = rat_effect_material
	
	animatedSprite.material = shader_material
	
	shader_material.set("shader_param/current_frame", 6)
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(shader_material, "shader_param/current_frame", 6, 0.5)
	
func _on_rat_happened_timer_timeout() -> void:
	rat_happened = false
	rat_happened_timer.stop()
	
	animatedSprite.play("default")
	animatedSprite.material = null

func _physics_process(delta: float) -> void:
	move_and_slide()
