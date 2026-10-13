extends Node

@export var unit: Node3D
@export var base_hp: float
@export var base_crew_amount: float
var hp: float = 1
var crew_amount: float = 10

var is_crew_damaged_recently: bool
@export var base_crew_regen_delay: float
var crew_regen_delay: float
@export var crew_regen_rate: float

var is_dead: bool
@export var death_delay: float

@export var hp_bar: ProgressBar
@export var crew_bar: ProgressBar

# sets variables once loaded
func _ready() -> void:
	hp = base_hp
	crew_amount = base_crew_amount
	hp_bar.max_value = base_hp
	hp_bar.value = hp
	crew_bar.max_value = base_crew_amount
	crew_bar.value = crew_amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# enemy death, if crew or hp is <= 0
	if hp <= 0 and is_dead == false:
		_enemy_death()
	
	if crew_amount <= 0 and is_dead == false:
		_enemy_death()
	
	# death delay so can be removed from everything without crashing game
	if is_dead == true:
		death_delay -= delta
		if death_delay <= 0:
			unit.queue_free()
	
	# crew regen, if hasn't been damaged in a while
	if is_crew_damaged_recently == false && crew_amount != base_crew_amount:
		_crew_regen()
		
	
	# crew regen delay
	elif is_crew_damaged_recently == true:
		crew_regen_delay -= delta
		if crew_regen_delay <= 0:
			is_crew_damaged_recently = false
			crew_regen_delay = base_crew_regen_delay
	
	# sets UI value's for unit
	hp_bar.value = hp
	crew_bar.value = crew_amount

func _enemy_death():
	# emits unit death signal
	SignalManager.unit_died.emit(unit)
	
	# takes away number of alive unit depending on faction
	if unit.is_in_group("Friendly"):
		GameManager.number_of_friendly_units -= 1
	else:
		GameManager.number_of_enemy_units -= 1
	
	is_dead = true

# resets crew delay
func _crew_killed():
	crew_regen_delay = base_crew_regen_delay
	is_crew_damaged_recently = true

# increases crew amount overtime, till max is reached
func _crew_regen():
	crew_amount += crew_regen_rate
	
	if crew_amount > base_crew_amount:
		crew_amount = base_crew_amount
