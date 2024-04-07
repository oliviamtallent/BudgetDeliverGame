extends Node2D

var rng = RandomNumberGenerator.new();
var gas_box_visible = false;
var gas = 0;
var apple_cost = 0;

var move_right = false
var move_left = false
var move_up = false
var move_down = false
var order_arr = [Vector2(721, 100), Vector2(939,84), Vector2(1155, 248), Vector2(827, 424)]
var order_spawn_timer
var orders_full = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Car.position = Global.car_position
	if (Global.tutorial_step == 1):
		$Tutorial/FirstItem.visible = true
	if(Global.tutorial_step == 7):
		order_spawn_timer = Timer.new()
		order_spawn_timer.wait_time = randi_range(1,10)
		order_spawn_timer.timeout.connect(spawn_order)
		add_child(order_spawn_timer)
		order_spawn_timer.start()
	else:
		for item in Global.orders:
			if item != null:
				add_child(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.car_position = $Car.position
	$BarNode/GasLabel.text = str(Global.gas)
	$BarNode/MoneyLabel.text = str(Global.money)
	$BarNode/AppleLabel.text = str(Global.num_apples)
	if !gas_box_visible:
		$GasStationNode/GasExclaim.visible = $Car/Area2D.get_overlapping_areas().has($GasStationNode/GasStation/GasStationArea)
	elif (gas_box_visible && !$Car/Area2D.get_overlapping_areas().has($GasStationNode/GasStation/GasStationArea)):
		$GasStationNode/GasBox.visible = false
		
	$BankNode/BankExclaim.visible = $Car/Area2D.get_overlapping_areas().has($BankNode/Bank/BankArea)
	$PlayerHouse/ArrowNext.visible = $Car/Area2D.get_overlapping_areas().has($PlayerHouse/PlayerHouseArea)
	
	if move_right:
		var tween = get_tree().create_tween()
		tween.tween_property($Car, "position", Vector2($Car.position.x + 15, $Car.position.y), .25)
	if move_left:
		var tween = get_tree().create_tween()
		tween.tween_property($Car, "position", Vector2($Car.position.x - 15, $Car.position.y), .25)
	if move_up:
		var tween = get_tree().create_tween()
		tween.tween_property($Car, "position", Vector2($Car.position.x, $Car.position.y - 15), .25)
	if move_down:
		var tween = get_tree().create_tween()
		tween.tween_property($Car, "position", Vector2($Car.position.x, $Car.position.y + 15), .25)
	if orders_full:
		if (Global.orders.size() < 3):
			if (Global.tutorial_step == 7):
				$Tutorial/Tutorial7.visible = true
			order_spawn_timer.wait_time = randi_range(1,10)
			order_spawn_timer.start()
			orders_full = false

func _on_arrow_left_input_event(viewport, event, shape_idx):
	
	if (event is InputEventMouseButton && event.pressed):
		$Car.set_texture(load("res://src/car_left.png"))
		move_left = true
	else:
		move_left = false


func _on_arrow_right_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$Car.set_texture(load("res://src/car_right.png"))
		move_right = true
	else:
		move_right = false


func _on_arrow_up_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		move_up = true
	else:
		move_up = false

func _on_arrow_down_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		move_down = true
	else:
		move_down = false


func _on_gas_exclaim_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		gas_box_visible = true;
		$GasStationNode/GasExclaim.visible = false
		$GasStationNode/GasBox.visible = true
		


func _on_gas_purchase_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		Global.money -= 5
		Global.gas += 1
		if (Global.gas == 3 and Global.tutorial_step == 5):
			$Tutorial/Tutorial5.visible = true

func _on_bank_exclaim_area_input_event(viewport, event, shape_idx):
		if (event is InputEventMouseButton && event.pressed):
			get_tree().change_scene_to_file("res://bank.tscn")


func _on_arrow_next_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		get_tree().change_scene_to_file("res://orchard.tscn")


func _on_done_arrow_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$Tutorial/FirstItem.visible = false
		Global.tutorial_step = 2


func _on_tutorial5_arrow_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$Tutorial/Tutorial5.visible = false
		Global.tutorial_step = 6

func spawn_order():
	if (Global.orders.size() < 3):
		var scene = load("res://order.tscn")
		var order = scene.instantiate()
		var index = randi_range(0, 3)
		while (Global.which_order.has(index)):
			index = randi_range(0, 3)
		order.position = order_arr[index]
		order.init(randi_range(1, 15),randi_range(1, 15))
		Global.orders.append(order)
		Global.which_order.append(index)
		order.scale = Vector2(.35,.35)
		add_child(order)
		order_spawn_timer.wait_time = randi_range(1,10)
		order_spawn_timer.start()
	else:
		orders_full = true


func _on_house_3_area_area_entered(area):
	if (area == $Car/Area2D):
		var index = Global.which_order.find(0)
		if (index != -1):
			var order = Global.orders[index]
			if order != null:
				order.show_order()


func _on_fish_shop_area_entered(area):
	if (area == $Car/Area2D):
		var index = Global.which_order.find(3)
		if (index != -1):
			var order = Global.orders[index]
			if order != null:
				order.show_order()

func _on_fish_shop_area_exited(area):
	if (area == $Car/Area2D):
		var index = Global.which_order.find(3)
		if (index != -1):
			var order = Global.orders[index]
			if order != null:
				order.hide_order()


func _on_house_2_area_entered(area):
	if (area == $Car/Area2D):
		var index = Global.which_order.find(1)
		if (index != -1):
			var order = Global.orders[index]
			if order != null:
				order.show_order()


func _on_house_2_area_exited(area):
	if (area == $Car/Area2D):
		var index = Global.which_order.find(1)
		if (index != -1):
			var order = Global.orders[index]
			if (order != null):
				order.hide_order()


func _on_house_1_area_entered(area):
	if (area == $Car/Area2D):
		var index = Global.which_order.find(2)
		if (index != -1):
			var order = Global.orders[index]
			if order != null:
				order.show_order()


func _on_house_1_area_exited(area):
	if (area == $Car/Area2D):
		var index = Global.which_order.find(2)
		if (index != -1):
			var order = Global.orders[index]
			if order != null:
				order.hide_order()


func _on_house_3_area_exited(area):
	if (area == $Car/Area2D):
		var index = Global.which_order.find(0)
		if (index != -1):
			var order = Global.orders[index]
			if order != null:
				order.hide_order()

func show_error(msg):
	$Tutorial/ErrorMsg/Label.text = msg
	$Tutorial/ErrorMsg.visible = true

func _on_error_arrow_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$Tutorial/ErrorMsg.visible = false


func _on_secret_pothole_area_entered(area):
	if (area == $Car/Area2D):
		if (Global.tutorial_step > 7):
			$Tutorial/PotHoleMsg.visible = true


func _on_pothole_arrow_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$Tutorial/PotHoleMsg.visible = false


func _on_tutorial7_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$Tutorial/Tutorial7.visible = false
		Global.tutorial_step = 8
