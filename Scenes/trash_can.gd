extends CollisionShape2D

@onready var animatedSprite = $trashCanSprite
@onready var parent_node = get_parent().get_parent()


var i = 0
var trash_cans = ["trash_brown", "trash_yellow"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("Mon parent est " + str(get_parent().get_parent()))
	#if parent_node.name == "Level03":
	#	print("mon quoicubeh est bien au niveau 3")
	if parent_node.name == "Level03":
		animatedSprite.set_animation(str(trash_cans[0]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parent_node.name == "Level03":
		if Input.is_action_just_pressed("ChangeTrashCan"):
			animatedSprite.set_animation(str(trash_cans[i]))
			#animatedSprite.frame(0)
			i += 1
			if i == 2:
				i = 0

func _on_trash_score():
	if parent_node.name == "Level03":
		animatedSprite.play(str(animatedSprite.get_animation()))
	else:
		animatedSprite.play("default")
	
