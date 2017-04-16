tool
extends Spatial

export var iod = 6.5 # our iod in cms, we'll be positioning things in dms
export var do_lookat = true
export var do_converge = false
export var z_near = 0.1
export var z_far = 100.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)

func _process(delta):
	var origin = get_node("Origin")
	var lookat = get_node("Lookat")
	var left_eye = origin.get_node("Lefteye")
	var right_eye = origin.get_node("Righteye")
	var aspect = 1024.0 / 760.0
	
	# first we always orientate our origin to face our lookat
	origin.look_at(lookat.get_translation(), Vector3(0.0, 1.0, 0.0))
	
	# now always position our cameras based on our iod
	left_eye.set_translation(Vector3(-iod/20.0, 0.0, 0.0))
	right_eye.set_translation(Vector3(iod/20.0, 0.0, 0.0))
	
	# adjust our eyes
	if (do_lookat):
		left_eye.look_at(lookat.get_translation(), Vector3(0.0, 1.0, 0.0))
		right_eye.look_at(lookat.get_translation(), Vector3(0.0, 1.0, 0.0))
	else:
		left_eye.set_rotation(Vector3(0.0, 0.0, 0.0))
		right_eye.set_rotation(Vector3(0.0, 0.0, 0.0))
	
	if (do_converge):
		var dist = lookat.get_translation()-origin.get_translation()
		var converge = dist.length()
		left_eye.set_perspective_for_eye(60.0, z_near, z_far, Camera.EYE_LEFT, iod / (aspect * 10.0), converge)
		right_eye.set_perspective_for_eye(60.0, z_near, z_far, Camera.EYE_RIGHT, iod / (aspect * 10.0), converge)
	else:
		var sinfov = sin(30.0)
		left_eye.set_frustum(-sinfov,sinfov,sinfov,-sinfov, z_near, z_far)
		right_eye.set_frustum(-sinfov,sinfov,sinfov,-sinfov, z_near, z_far)
		
