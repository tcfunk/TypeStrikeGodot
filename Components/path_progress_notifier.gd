@tool
extends Node3D
class_name PathMarker

signal notify

@onready var path_marker = $PathMarker

@export var path : Path3D

## Distance along path in meters
@export var path_position := 0.5:
	set(p):
		if path:
			var curve := path.curve
			path_position = clampf(p, 0, curve.get_baked_length())
			var curve_position = curve.sample_baked(path_position)
			if path_marker:
				path_marker.global_position = path.to_global(curve_position)
		else:
			path_position = p
	get:
		return path_position

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		_update_marker_position()

func _ready():
	if Engine.is_editor_hint():
		set_notify_transform(true)

	else:
		_hide_markers()
	_update_marker_position()
	path_position = path_position
	
func _hide_markers():
	$"PathMarker".hide()

func _update_marker_position():
	if path:
		var curve := path.curve
		var dist := path_position * curve.get_baked_length()
		var curve_position = curve.sample_baked(dist)
		if path_marker:
			path_marker.global_position = curve_position
