extends CharacterBody2D

@export var SPEED := 100.01
@export var JUMP_VELOCITY := -300.0

# Reference to this objects sprite
# To recreate, click and drag the Sprite2D from the Scene into the script (hold ctrl when releasing mouse click)
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# TODO: Add input mapping in the project settings (mostly so you can jump with the up arrow key)
func _physics_process(delta):
	# Set walking animation
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "run"
	else:
		sprite_2d.animation = "idle"
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jump"

	# Handle jump.
	# In Godot, up is negative Y
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	var isFacingLeft = velocity.x < 0 || sprite_2d.flip_h && !velocity.x > 1
	sprite_2d.flip_h = isFacingLeft
