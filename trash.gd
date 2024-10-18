extends RigidBody2D

class_name Trash

signal trash_score
signal trash_miss

var factor

var trash_array = ["trash_brown", "trash_yellow"]

var collision_anim_scene = preload("res://Scenes/trash_hit.tscn") 


@onready var gameManager = get_parent()
@onready var trashSprite = $trashSprite
@onready var trashCanSprite = get_node("../Player/trashCan/trashCanSprite")
@onready var trash_sound = $trash_sound

@export var TRASH_MAX_SPEED = 500
@export var TRASH_MIN_SPEED = 300
@export var ROTATION_SPEED = 5
@export var UPWARD_IMPULSE = -300
@export var X_IMPULSE = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#trash_sound.play()  # Test if this sound works
	#trash_fall_sound.play()  # Test if this sound works
	#trash_fall_player_sound.play() 
	
	#if gameManager.name == "Level03":
	#	TRASH_MAX_SPEED = 300
	#	TRASH_MIN_SPEED = 100
	#	X_IMPULSE = 25
	#print("Trash Can Sprite Node" + str(trashCanSprite))
	factor = (TRASH_MAX_SPEED - TRASH_MIN_SPEED)/gameManager.wave_count 
	
	var random_rotation = randi_range(-ROTATION_SPEED, ROTATION_SPEED)
	var random_x_impulse = X_IMPULSE
	if randi() % 2 == 0:
		random_x_impulse = -X_IMPULSE
	print(str(random_x_impulse))
	apply_impulse(Vector2(random_x_impulse, UPWARD_IMPULSE), Vector2(0, 0))
	set_angular_velocity(random_rotation)
	
	if gameManager.name == "Level03":
		var rand_trash_index = randi_range(0,1)
		
		trashSprite.set_animation(str(trash_array[rand_trash_index]))
		
		var rand_trash_sprite = randi_range(0,4)
		trashSprite.frame = rand_trash_sprite
	else:	
		var rand_trash_sprite = randi_range(0,18)
		trashSprite.set_animation("default")
		trashSprite.frame = rand_trash_sprite
	
	print("trash sound")
	trash_sound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#set_linear_velocity(get_linear_velocity() + get_gravity() * delta * 0.2)
	#print(get_linear_velocity().y)
	
	var trash_speed = TRASH_MIN_SPEED + factor * gameManager.wave
	var current_velocity = get_linear_velocity()

	if current_velocity.y >= trash_speed:
		current_velocity.y = trash_speed  # Modify only the Y component
		set_linear_velocity(current_velocity) 
		
	#print("Trash speed: " + str(current_velocity))


func _on_area_2d_body_entered(body: Node2D) -> void:
	#var game = get_parent().get_parent()
	#print(game)
	
	if(body.name == "Floor"):
		print("wow collisions")
		#game.miss()
		emit_signal("trash_miss")
		_create_collision_effect(self.position)
		queue_free()
	elif body.name == "Player":
		#game.score()
		if gameManager.name == "Level03":
			if trashCanSprite.get_animation() == trashSprite.get_animation():
				emit_signal("trash_score")
				#print("Same type trash and trash can, emit score")
			else:
				emit_signal("trash_miss")
				#print("Not same type trash and trash can, emit miss")
			queue_free()
		else:
			emit_signal("trash_score")
			queue_free()

func _create_collision_effect(position: Vector2):
	var offset_position = position + Vector2(0, -30)
	# Instantiate the animated sprite scene
	var collision_anim = collision_anim_scene.instantiate() as AnimatedSprite2D
	
	# Set the position of the animation to the collision point
	collision_anim.global_position = offset_position
	
	print(str(position))
	print(collision_anim)
	
	# Add the animated sprite to the scene (add it to the root or a specific parent node)
	get_parent().add_child(collision_anim)
	
	# Optionally, play the animation if it's not set to autoplay
	collision_anim.play("default")  # Replace with the correct animation name if necessary
	
	# Connect to the animation_finished signal to free the animated sprite after it finishes playing
	#collision_anim.connect("animation_finished", collision_anim, queue_free())
	collision_anim.connect("animation_finished", Callable(self, "_on_animation_finished").bind(collision_anim))
	
func _on_animation_finished(anim_sprite: AnimatedSprite2D):
	print("Animation finished")
	anim_sprite.queue_free()
