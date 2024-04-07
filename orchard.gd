extends Node2D

var basket_pressed = false
var starting_y = 0
var timer_total
var spawn_timer
var is_playing = false;
var apples = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BarNode/GasLabel.text = str(Global.gas)
	$BarNode/MoneyLabel.text = str(Global.money)
	$BarNode/AppleLabel.text = str(Global.num_apples)
	
	if basket_pressed:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.y != starting_y: 
			mouse_pos.y = starting_y
			Input.warp_mouse(mouse_pos)
		followMouse($Basket)
	if is_playing:
		$Timer/Label.text = "00:" + str(int(timer_total.time_left))
		$Timer/AppleLabel.text = str(apples)

func followMouse(sprite):
	sprite.position = Vector2(get_global_mouse_position().x, sprite.position.y)

func _on_basket_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton):
		basket_pressed = event.pressed
		starting_y = get_global_mouse_position().y
		if (!basket_pressed):
			$Basket.set_position(Vector2(121, 529))


func _on_collect_btn_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		$Basket/BasketArea.visible = true
		$ArrowBack.visible = false
		$Timer.visible = true
		$WaterPurchase.visible = false
		$CollectBtn.visible = false
		is_playing = true
		timer_total = Timer.new()
		timer_total.wait_time = 15
		timer_total.timeout.connect(mini_game_done)
		add_child(timer_total)
		spawn_timer = Timer.new()
		spawn_timer.timeout.connect(_spawn_apple)
		spawn_timer.wait_time = randf_range(0,2)
		add_child(spawn_timer)
		spawn_timer.start()
		timer_total.start()
		
		
func _spawn_apple():
	var scene = load("res://apple.tscn")
	var apple = scene.instantiate()
	apple.position = Vector2(randi_range(0, 1000), 0)
	add_child(apple)
	var tween = get_tree().create_tween()
	tween.tween_property(apple, "position", Vector2(apple.position.x,600), .7)
	
	if is_playing:
		if (timer_total.time_left > 1.5):
			spawn_timer.wait_time = randf_range(0,2)
			spawn_timer.start()
		
	await tween.finished
	if (apple != null):
		apple.queue_free()
	
func mini_game_done():
	spawn_timer.stop()
	$Basket.set_position(Vector2(121, 529))
	is_playing = false
	basket_pressed = false
	$Basket/BasketArea.visible = false
	$Timer.visible = false
	$WaterPurchase.visible = true
	$CollectBtn.visible = true
	$ArrowBack.visible = true
	Global.num_apples += apples
	apples = 0
	if (Global.tutorial_step == 6):
		$Tutorial/Tutorial6.visible = true

func _on_basket_area_entered(area):
	if (area != $CollectBtn/CollectBtnArea and area != $ArrowBack/BackArrowArea and area != $Tutorial/Tutorial6/TutorialDoneArrow/DoneArrowArea):
		apples += 1;
		area.get_parent().queue_free()

func _on_back_arrow_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		get_tree().change_scene_to_file("res://main.tscn")


func _on_tutorial6_arrow_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		$Tutorial/Tutorial6.visible = false
		Global.tutorial_step = 7
