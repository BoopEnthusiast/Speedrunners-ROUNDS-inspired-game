class_name LevelEditor
extends Node2D


const TEST = preload("res://levels/test.tscn")

@export var camera_speed: int = 1.0

var level: Level

var selected_tile: Vector2i = Vector2i(0, 0)

@onready var camera: Camera2D = $Camera


func _ready() -> void:
	level = TEST.instantiate()
	add_child(level)


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		# Place selected cell
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			place_cell(event.global_position)
		# Erase cell
		elif event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			level.main_tile_map.erase_cell(level.main_tile_map.get_cell_at_global(level.main_tile_map.get_local_mouse_position()))
		# Pan the screen when moving the mouse and holding LMB
		if event is InputEventMouseMotion:
			if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
				camera.position += -event.relative / camera_speed / camera.zoom
		# Zoom the camera
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera.zoom *= 0.9
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera.zoom *= 1.1


func place_cell(global_pos: Vector2) -> void:
	var tile = level.main_tile_map.get_cell_at_global(level.main_tile_map.get_local_mouse_position())
	level.main_tile_map.set_cell(tile, 0, Vector2i(0, 0), 1)
