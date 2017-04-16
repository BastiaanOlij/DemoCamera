tool
extends Spatial

export var do_lookat = true
export var animate = false

var screen_dist_from_camera = 2.0
var anim_value = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
#	get_node("Lookat/Screen").get_material_override().set_texture(FixedMaterial.PARAM_DIFFUSE, get_node("Viewport").get_render_target_texture())
	
	set_process(true)
	
func _process(delta):
	var Camera = get_node("Viewport/Camera")
	var Screen = get_node("Lookat/Screen")
	var aspect = 1024.0 / 760.0
	
	if (animate):
		anim_value += delta
		Camera.set_translation(Vector3(sin(anim_value * 1.5) * 3.0, 0.0, 0.0))
	else:
		# reset
		anim_value = 0
	
	if (do_lookat):
		# keep updating our camera matrices
		Camera.look_at(get_node("Lookat").get_translation(), Vector3(0.0, 1.0, 0.0))

		if (1==2):
			# and size/orient our quad to follow
			Screen.set_rotation(Camera.get_rotation())

			# Make sure our screen is always positioned a certain distance from our camera
			var cam_look_dir = get_node("Lookat").get_translation() - Camera.get_translation()
			cam_look_dir *= (cam_look_dir.length() - screen_dist_from_camera) / cam_look_dir.length()
			Screen.set_translation(-cam_look_dir)
			
		else:
			Screen.set_rotation(Vector3(0.0, 0.0, 0.0))
			Screen.set_translation(Vector3(0.0, 0.0, 0.0))
			
			
		if (Camera.get_projection() == Camera.PROJECTION_FRUSTUM):
			var right_top = sin(30.0 * PI / 180.0)
			Camera.set_frustum(-right_top, right_top, right_top, -right_top, 0.1, 100.0)
	else:
		var transform = Camera.get_transform()
		transform.basis = Matrix3()
		Camera.set_transform(transform)

		if (Camera.get_projection() == Camera.PROJECTION_FRUSTUM):
			var half = sin(30.0 * PI / 180.0) * 7.5
			Camera.set_frustum((-(half * aspect) - transform.origin.x) / (7.5 * aspect), ((half * aspect) - transform.origin.x) / (7.5 * aspect), half / 7.5, -half / 7.5, 0.1, 100.0)

	# Size our preview
	var tangent = 2.0 * sin(30.0 * PI / 180.0)
	tangent = tangent * 7.5
	Screen.set_size(Vector2(tangent * aspect, tangent))

	# our follow cam always looks at our lookat
	var FollowCam = get_node("FollowCam")
	FollowCam.set_translation(Camera.get_translation())
	FollowCam.look_at(get_node("Lookat").get_translation(), Vector3(0.0, 1.0, 0.0))
