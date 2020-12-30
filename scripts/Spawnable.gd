extends Area2D
class_name Spawnable

export (float) var speed = 150

var _visibility_notifier : VisibilityNotifier2D
var _object_pool : ObjectPool

func _ready():
	_object_pool = get_node("/root/ObjectPoolSingleton")
	_visibility_notifier = get_node("VisibilityNotifier2D")
	_visibility_notifier.connect("screen_exited", self, "_exit_screen")

func _physics_process(delta):
	position = Vector2( position.x - (speed * delta), position.y )

func _exit_screen():
	clean_up()

func clean_up():
	_object_pool.return_node(self)
