extends "res://game/GameWorld.gd"


const TEAM2_MORE_TO_MINE_LOG_NAME := "Team2-MoreToMine:GameWorld"

@onready var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")
@onready var team_2_globals: Team2Globals = team_2_mod_node.globals


func prepareCleanData():
	super.prepareCleanData()

	for resource in team_2_globals.resources:
		Data.apply("inventory.%s" % resource.type, 0)
