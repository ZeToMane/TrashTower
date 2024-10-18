extends Node2D

var spawners = []
var rat_spawner

var has_rat = false

var score_count = 0
var miss_count = 0
var wave = 1
var i = 0
var i_rat = 0

signal wave_updated
signal clock_updated
signal win

@export var countdown = 3
@export var game_timer_count: = 2
@export var wave_count = 5

var game_timer_counter = game_timer_count



var last_rand = -99

@onready var countdown_label = $countdown
@onready var countdown_sprite = $Countdown
@onready var timer_start = $gameStartTimer
@onready var game_timer = $gameTimer
@onready var spawn_timer = $spawnTimer
@onready var game_timer_label = $HUD/timer_label
@onready var win_timer = $winWindow/winTimer
@onready var wave_label = $HUD/wave_label
@onready var rat_timer = $ratTimer
@onready var HUD = $HUD
@onready var win_window = $winWindow
@onready var opening = $Opening

@onready var music_managers = get_tree().get_nodes_in_group("MusicManager")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opening.show()

	var tween = get_tree().create_tween()
	tween.tween_callback(Callable(opening, "play").bind("default_reverse"))
	
	opening.connect("animation_finished", Callable(self, "_on_opening_animation_finished"))
	
	#timer_start.start()
	
	countdown_label.text = "0" + str(countdown)
	countdown_sprite.changeSpriteCountdown(countdown)
	game_timer_label.text = str(game_timer_count)
	wave_label.text = str(wave)
	
	for child in get_children():
		# Check if the child is a TrashSpawner (replace TrashSpawner with the actual class name)
		if child is trashSpawner:
			spawners.append(child)
		
		if child is ratSpawner:
			rat_spawner = child
			has_rat = true
	
	if self.name == "Level01":
		for music_manager in music_managers:
			print(music_manager)
			music_manager._on_level1_song() 
	elif self.name == "Level02":
		for music_manager in music_managers:
			print(music_manager)
			music_manager._on_level2_song() 
	elif self.name == "Level03":
		for music_manager in music_managers:
			print(music_manager)
			music_manager._on_level3_song() 
	
	print("Spawners found: ", spawners)  # Debug output
	print("RatSpawner found: ", rat_spawner) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_start_timer_timeout() -> void:
	countdown -= 1
	
	if countdown >= 0:
			countdown_label.text = "0" + str(countdown)
			countdown_sprite.changeSpriteCountdown(countdown)
	else:
		timer_start.stop()
		
		game_timer.start()
		if rat_timer:
			rat_timer.start()
		
		game_timer_label.text = str(game_timer_count)
		
		countdown_label.hide()
		countdown_sprite.hide()

func _on_game_timer_timeout() -> void:
	if countdown <= 0 and wave <= wave_count :
		game_timer_counter -= 1
		if game_timer_counter >= 0:
			game_timer_label.text = str(game_timer_counter)
			emit_signal("clock_updated")
		else:
			if rat_timer:
				rat_timer.stop()
			game_timer.stop()
			print("Wave: " + str(wave) + " Wave_count: " + str(wave_count))
			if wave != wave_count:
				wave += 1
				wave_label.text = str(wave)
				emit_signal("wave_updated")
				
				countdown = 3
			
				countdown_label.text = "0" + str(countdown)
				countdown_sprite.changeSpriteCountdown(countdown)
				
				countdown_label.show()
				countdown_sprite.show()
				
				game_timer_counter = game_timer_count
				emit_signal("clock_updated")
				
				timer_start.start()
				
				spawn_timer.set_wait_time(spawn_timer.get_wait_time() - (0.05))
				print("Spawn Wait Time: " + str(spawn_timer.get_wait_time()))
			else:
				timer_start.stop()
				countdown_sprite.hide()
				#HUD.hide()
				win_window.show()
				win_window.play("default")
				win_timer.start()

func _on_win_timer_timeout() -> void:
	if i == 1:
		win_window.hide()
		win_timer.stop()
		emit_signal("win")
	else:
		win_window.play("defaultReverse")
		#win_timer.set_wait_time(.05)
	i += 1


func _on_timer_timeout() -> void:
	if countdown < 0 and game_timer_counter > 0:
		#print(last_rand)
		var randSpawner = randi_range(0, spawners.size() - 1)
		if randSpawner == last_rand: #or randSpawner == (last_rand + 2) or randSpawner == (last_rand - 2):
			while randSpawner == last_rand: #or randSpawner == (last_rand + 2) or randSpawner == (last_rand - 2) :
				randSpawner = randi_range(0, spawners.size() - 1)
				#print("in while with : " + str(randSpawner))
		last_rand = randSpawner
		
		spawners[randSpawner].spawnTrash()

func _on_rat_timer_timeout() -> void:
	if countdown <= 0 and game_timer_counter > 0:
		if randi_range(0,9) >= 4 and i_rat <= 0:
			rat_spawner.spawnRat()
			i_rat += 1
		else:
			i_rat = 0


func update_wave_display(u: AnimatedSprite2D):	
	u.frame = wave
	
func update_clock_display(h: AnimatedSprite2D, d: AnimatedSprite2D, u: AnimatedSprite2D):	
	print(game_timer_counter)
	var hundred_digit = (game_timer_counter / 100) % 10
	var decimal_digit = (game_timer_counter / 10) % 10
	var unit_digit = game_timer_counter % 10
	
	h.frame = hundred_digit
	d.frame = decimal_digit
	u.frame = unit_digit

func _on_opening_animation_finished():
	opening.hide()
	timer_start.start()
