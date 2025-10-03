extends Node

@export var a_doors : Array[Door]
@export var b_doors : Array[Door]
@export var ab_switches : Array[Switch]

@export var symbol_a : Texture
@export var symbol_b : Texture

enum ABState{
	A,
	B
}

@export var current_abstate : ABState = ABState.A

func _ready() -> void:
	_setup_symbols()
	_setup_doors()
	_setup_switches()
	

func _setup_symbols():
	for door in a_doors:
		door.setup_symbols(symbol_a)
	for door in b_doors:
		door.setup_symbols(symbol_b)
	
	for switch in ab_switches:
		switch.setup_symbols(symbol_a,symbol_b)
		switch.connect("pressed",_on_ab_switch_press)
	
func _setup_doors():
	if current_abstate == ABState.A:
		for door in a_doors:
			door.open(false)
		for door in b_doors:
			door.close(false)
	else:
		for door in a_doors:
			door.close(false)
		for door in b_doors:
			door.open(false)

func _setup_switches():
	if current_abstate == ABState.A:
		for switch in ab_switches:
			switch.to_top(false)
	else:
		for switch in ab_switches:
			switch.to_bottom(false)

func swap_ab_doors(animate : bool = true):
	if current_abstate == ABState.A:
		for door in a_doors:
			door.close(animate)
		for door in b_doors:
			door.open(animate)
		current_abstate = ABState.B

	else:
		for door in a_doors:
			door.open(animate)
		for door in b_doors:
			door.close(animate)
		current_abstate = ABState.A

func _on_ab_switch_press():
	if current_abstate == ABState.A:
		for switch in ab_switches:
			switch.to_bottom(false)
	else:
		for switch in ab_switches:
			switch.to_top(false)
	
	swap_ab_doors()
