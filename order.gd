extends Node2D

var count
var price
var order_arr = [Vector2(721, 100), Vector2(939,84), Vector2(1155, 248), Vector2(827, 424)]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init(amount, cost):
	count = amount;
	price = cost;

func show_order():
	$ExclaimNode/Exclaim.visible = false
	$OrderBoxNode/PriceLabel.text = "$" + str(price)
	$OrderBoxNode/AmountLabel.text = "x" + str(count)
	$OrderBoxNode.visible = true
	
func hide_order():
	$ExclaimNode/Exclaim.visible = true
	$OrderBoxNode.visible = false

func _on_check_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if (Global.num_apples < count):
			get_tree().get_root().get_node("main").show_error("Not enough apples.")
		elif (Global.gas < 1):
			get_tree().get_root().get_node("main").show_error("Not enough gas.")
		else:
			Global.money += price
			Global.num_apples -= count
			Global.gas -= 1
			var index = order_arr.find(position)
			print(index)
			print(Global.orders)
			Global.orders.remove_at(index)
			Global.which_order.remove_at(index)
			print(Global.orders)
			queue_free()


func _on_x_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		var index = order_arr.find(position)
		Global.orders.remove_at(index)
		Global.which_order.remove_at(index)
		queue_free()
