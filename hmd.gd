tool
extends Spatial

export var iod = 6.5 # our iod in cms, we'll be positioning things in dms
export var do_lookat = true
export var do_hmd = false
export var screen_width = 10.5 # width of screen in cms
export var screen_dist = 7.0 # distance of screen to eyes in cms
export var z_near = 0.1
export var z_far = 100.0
export var view_scale = 10.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)

func _process(delta):
	var origin = get_node("Origin")
	var lookat = get_node("Lookat")
	var left_eye = origin.get_node("Lefteye")
	var right_eye = origin.get_node("Righteye")
	var screen = origin.get_node("Screen")
	var left_lens = origin.get_node("LeftLens")
	var right_lens = origin.get_node("RightLens")
	var aspect = 1024.0 / 760.0
	
	# first we always orientate our origin to face our lookat
	origin.look_at(lookat.get_translation(), Vector3(0.0, 1.0, 0.0))
	
	# lets size and position our example screens
	var width = screen_width / (2.0 * view_scale)
	screen.set_scale(Vector3(width, 0.5 * width / aspect, 0.01))
	screen.set_translation(Vector3(0.0, 0.0, -screen_dist / view_scale))
	
	# now always position our cameras based on our iod
	left_eye.set_translation(Vector3(-iod/(2.0 * view_scale), 0.0, 0.0))
	right_eye.set_translation(Vector3(iod/(2.0 * view_scale), 0.0, 0.0))
	
	# position our lenses as well
	left_lens.set_translation(Vector3(-iod/(2.0 * view_scale), 0.0, -0.5 * screen_dist / view_scale))
	right_lens.set_translation(Vector3(iod/(2.0 * view_scale), 0.0, -0.5 * screen_dist / view_scale))
	
	# adjust our eyes
	if (do_lookat):
		left_eye.look_at(lookat.get_translation(), Vector3(0.0, 1.0, 0.0))
		right_eye.look_at(lookat.get_translation(), Vector3(0.0, 1.0, 0.0))
	else:
		left_eye.set_rotation(Vector3(0.0, 0.0, 0.0))
		right_eye.set_rotation(Vector3(0.0, 0.0, 0.0))
	
	if (do_hmd):
		var f1 = (iod / 2.0) / screen_dist
		var f2 = ((screen_width - iod) / 2.0) / screen_dist
		var f3 = (screen_width / (4.0 * aspect)) / screen_dist

		left_eye.set_frustum(-f2 / aspect, f1 / aspect, f3, -f3, z_near, z_far)
		right_eye.set_frustum(-f1 / aspect, f2 / aspect, f3, -f3, z_near, z_far)
	else:
		var sinfov = sin(30.0)
		left_eye.set_frustum(-sinfov,sinfov,sinfov,-sinfov, z_near, z_far)
		right_eye.set_frustum(-sinfov,sinfov,sinfov,-sinfov, z_near, z_far)
		
