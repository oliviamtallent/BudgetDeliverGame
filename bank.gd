extends Node2D

var money = Global.money
var saved = Global.saved
var took_loan = false
var clicked = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if (Global.tutorial_step == 2):
		$Tutorial/Tutorial2.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$DepositsNode/Label.text = str(saved)
	$WithdrawsNode/Label.text = str(saved)
	Global.money = money
	Global.saved = saved
	
	$PaymentsNode/PaymentsMenu/Pay/PaymentsLabel.text = "You currently owe: " + str(Global.list[0])
	

	


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_loans_button_pressed():
	if (Global.loan == 0):
		$LoansNode.visible = true
		$BankMainMenu.visible = false
	else:
		$LoansNode.visible = true
		$BankMainMenu.visible = false
		$LoansNode/Button.visible = false
		$LoansNode/Button2.visible = false
		$LoansNode/Button3.visible = false
		if Global.loan == 1:
			$LoansNode/Check.visible = true
		elif Global.loan == 2:
			$LoansNode/Check2.visible = true
		elif Global.loan == 3:
			$LoansNode/Check3.visible = true
			


func _on_deposits_button_pressed():
	$DepositsNode.visible = true
	$BankMainMenu.visible = false



func _on_withdraws_button_pressed():
	$DepositsNode.visible = false
	$LoansNode.visible = false
	$PaymentsNode.visible = false
	$WithdrawsNode.visible = false
	$BankMainMenu.visible = true


func _on_button_pressed():
	if (Global.tutorial_step == 4):
		$Tutorial/Tutorial4.visible = true
	$LoansNode/Check2.visible = false
	$LoansNode/Check3.visible = false
	$LoansNode/Check.visible = true 

func _on_button_3_pressed():
	if (!$Tutorial/Tutorial4.visible):
		if (Global.tutorial_step == 4):
			$Tutorial/ErrorTutorial.visible = true
		$LoansNode/Check3.visible = false
		$LoansNode/Check.visible = false
		$LoansNode/Check2.visible = true 


func _on_button_2_pressed():
	if (!$Tutorial/Tutorial4.visible):
		if (Global.tutorial_step == 4):
			$Tutorial/ErrorTutorial.visible = true
		$LoansNode/Check2.visible = false
		$LoansNode/Check.visible = false
		$LoansNode/Check3.visible = true 


func _on_confirm_button_pressed():
	$LoansNode/Button3.visible = false
	$LoansNode.visible = false


	if $LoansNode/Check.visible == true:
		money += 25
		Global.loan = 1
	elif $LoansNode/Check2.visible == true:
		money += 50
		Global.loan = 2
	elif $LoansNode/Check3.visible == true:
		money += 200
		Global.loan = 3


func _on_done_arrow2_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton):
		if (clicked && !event.pressed):
			$Tutorial/Tutorial2.visible = false
			$Tutorial/Tutorial3.visible = true
			Global.tutorial_step = 3
		else:
			clicked = event.pressed


func _on_done_arrow3_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		Global.tutorial_step = 4
		$Tutorial/Tutorial3.visible = false


func _on_error_arrow_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		Global.lives -= 1
		$Tutorial/ErrorTutorial.visible = false


func _on_tutorial4_arrow_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		Global.tutorial_step = 5
		$Tutorial/Tutorial4.visible = false

func _on_texture_button_pressed():
	$WithdrawsNode.visible = true
	$BankMainMenu.visible = false


func _on_payments_button_pressed():
	$PaymentsNode.visible = true
	$BankMainMenu.visible = false


func _on_add_10_pressed():
	Deposit(10)

func _on_add_11_pressed():
	Deposit(30)

func _on_add_12_pressed():
	Deposit(50)

func _on_x_pressed():
	Withdraw(10)
func _on_x_1_pressed():
	Withdraw(30)
func _on_x_2_pressed():
	Withdraw(50)

func Withdraw(number):
	if saved >= number:
		money += number
		saved -= number
	else:
		$OhNo.visible = true
	
func Deposit(number):
	if money >= number:
		money -= number
		saved += number
	else:
		$OhNo.visible = true
	
func _on_oh_no_button_pressed():
	$OhNo.visible = false

