extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

var _camera_input_direction := Vector2.ZERO

@onready var _camera_pivot: Node3D = %"Camera Pivot"

## _input hooks into the games mouse and keyboard inputs
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

## Only capture mouse movement which is in the game window
func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	## Rotate the x axis of the camera
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	## Restrict the camera from rotating all the way around on the x
	## this would result in the sreen being flipped horizontally
	## the following code limits the camera's x to roughly -30 degrees to 60 degrees
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI / 6.0, PI / 3.0)
	## Rotate the y axis of the camera
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	## Reset the camera direction at the end of the process so it stops rotating
	_camera_input_direction = Vector2.ZERO
