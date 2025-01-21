class_name Level
extends Node2D
## Root class for all levels
##
## To create a new level, please create an inherited scene of "res://levels/level.tscn"

@onready var main_tile_map: LevelMainTileMap = $MainTileMap
