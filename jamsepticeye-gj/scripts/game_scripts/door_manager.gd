extends Node

@export var sword_doors : Array[Door]
@export var shield_doors : Array[Door]
@export var sun_doors : Array[Door]
@export var moon_doors : Array[Door]

@export var sunmoon_switches : Array[Switch]
@export var swordshield_switches : Array[Switch]

@export var symbol_sprites : Array

enum SwordShieldState {
	Sword,
	Shield
}

enum SunMoonState{
	Sun,
	Moon
}

@export var current_swordshieldstate : SwordShieldState = SwordShieldState.Sword
@export var current_sunmoonstate : SunMoonState = SunMoonState.Sun

func _ready() -> void:
	_setup_symbols()
	_setup_doors()
	_setup_switches()
	

func _setup_symbols():
	for door in sun_doors:
		door.setup_symbols(symbol_sprites[0])
	for door in moon_doors:
		door.setup_symbols(symbol_sprites[1])
	for door in sword_doors:
		door.setup_symbols(symbol_sprites[2])
	for door in shield_doors:
		door.setup_symbols(symbol_sprites[3])
	
	for switch in sunmoon_switches:
		switch.setup_symbols(symbol_sprites[0],symbol_sprites[1])
		switch.connect("pressed",_on_sunmoon_switch_press)
	
	for switch in swordshield_switches:
		switch.setup_symbols(symbol_sprites[2],symbol_sprites[3])
		switch.connect("pressed", _on_swordshield_switch_press)
	
func _setup_doors():
	if current_sunmoonstate == SunMoonState.Sun:
		for door in sun_doors:
			door.open(false)
		for door in moon_doors:
			door.close(false)
	else:
		for door in sun_doors:
			door.close(false)
		for door in moon_doors:
			door.open(false)
	
	if current_swordshieldstate == SwordShieldState.Sword:
		for door in sword_doors:
			door.open(false)
		for door in shield_doors:
			door.close(false)
	else:
		for door in sword_doors:
			door.close(false)
		for door in shield_doors:
			door.open(false)

func _setup_switches():
	if current_sunmoonstate == SunMoonState.Sun:
		for switch in sunmoon_switches:
			switch.to_top(false)
	else:
		for switch in sunmoon_switches:
			switch.to_bottom(false)
	
	if current_swordshieldstate == SwordShieldState.Sword:
		for switch in swordshield_switches:
			switch.to_top(false)
	else:
		for switch in swordshield_switches:
			switch.to_bottom(false)

func swap_sunmoon_doors(animate : bool = true):
	if current_sunmoonstate == SunMoonState.Sun:
		for door in sun_doors:
			door.close(animate)
		for door in moon_doors:
			door.open(animate)
		current_sunmoonstate = SunMoonState.Moon

	else:
		for door in sun_doors:
			door.open(animate)
		for door in moon_doors:
			door.close(animate)
		current_sunmoonstate = SunMoonState.Sun

func swap_swordshield_doors(animate : bool = true):
	if current_swordshieldstate == SwordShieldState.Sword:
		for door in sword_doors:
			door.close(animate)
		for door in shield_doors:
			door.open(animate)
		current_swordshieldstate = SwordShieldState.Shield
	else:
		for door in sword_doors:
			door.open(animate)
		for door in shield_doors:
			door.close(animate)
		current_swordshieldstate = SwordShieldState.Sword


func _on_sunmoon_switch_press():
	if current_sunmoonstate == SunMoonState.Sun:
		for switch in sunmoon_switches:
			switch.to_bottom(false)
	else:
		for switch in sunmoon_switches:
			switch.to_top(false)
	
	swap_sunmoon_doors()
	
func _on_swordshield_switch_press():
	if current_swordshieldstate == SwordShieldState.Sword:
		for switch in swordshield_switches:
			switch.to_bottom(false)
	else:
		for switch in swordshield_switches:
			switch.to_top(false)
	
	swap_swordshield_doors()
