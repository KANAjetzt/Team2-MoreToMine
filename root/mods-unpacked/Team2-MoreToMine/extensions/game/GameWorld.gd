extends "res://game/GameWorld.gd"


const TEAM2_MORE_TO_MINE_LOG_NAME := "Team2-MoreToMine:GameWorld"

@onready var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")
@onready var team_2_globals: Team2Globals = team_2_mod_node.globals


func prepareCleanData():
	super.prepareCleanData()

	var parts = ['magnetic_screws', 'sintered_metal', 'absorption_hull', 'micro_gear', 'liquefier', 'coated_lens', 'dampener_ring', 'dynamic_dampener',
	'ruby_coated_lens', 'lens_array', 'energy_casing', 'fusion_cell', 'plasma_cell', 'vacuum_energy_cell', 'nano_circuit_board', 'data_matrix', 'crystalic_filter',
	'phase_coil', 'coil_grid', 'pulse_emitter', 'modular_pulse_emitter', 'modular_beam_emitter', 'overload_buffer', 'pivot_mechanism', 'feedback_buffer',
	'rail_track', 'magnetic_rail_system', 'cryo_magnet_rail_system', 'servo_motor', 'servo_drive', 'absorption_field_generator']

	for part in parts:
		Data.apply("inventory.%s" % part, 100)

	for resource in team_2_globals.resources:
		Data.apply("inventory.%s" % resource.type, 100)
