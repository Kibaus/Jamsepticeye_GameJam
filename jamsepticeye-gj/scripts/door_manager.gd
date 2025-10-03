extends Node

@export var sword_doors : Array[Door]
@export var shield_doors : Array[Door]
@export var sun_doors : Array[Door]
@export var moon_doors : Array[Door]

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
			door.open(false)
		for door in shield_doors:
			door.close(false)

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
			door.open(false)
		for door in shield_doors:
			door.close(false)

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


func _on_timer_timeout() -> void:
	swap_sunmoon_doors()
