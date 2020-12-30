extends Node

export var first_wave : Array = [
	[0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0]
]

onready var _object_pool : ObjectPool = get_node("/root/ObjectPoolSingleton")
onready var _spawn_timer : Timer = get_node("SpawnTimer")
onready var _wave_timer : Timer = get_node("WaveTimer")

var _wave_queue : Array

export(Array, String, FILE, "*.tscn") var object_paths = []
export var spawn_delay = 0.5
export var wave_delay = 3
export var padding = 50.0

var screen_size : Vector2 = Vector2.ZERO

func _ready():
	screen_size = get_viewport().size
	_spawn_timer.connect("timeout", self, "_spawner_timeout")
	_wave_timer.connect("timeout", self, "_wave_timeout")
	_wave_timer.start(wave_delay)

func _spawner_timeout():
	_start_wave()

func _wave_timeout():
	push_wave_queue(first_wave)
	_spawn_timer.start(spawn_delay)

func _start_wave():
	var _wave = _wave_queue[0].pop_front()
	if _wave == null:
		_wave_timer.start(wave_delay)
		return
	
	_spawn_timer.start(spawn_delay)
	
	var _top_var = (screen_size.y - (padding*2))
	var _space_between_elements : float = screen_size.y /(len(_wave)+2)

	while len(_wave) > 0:
		var _object_key = _wave.pop_front()
		if not _object_key == null:
			var _element : Node2D = _object_pool.take_node(object_paths[_object_key])
			self.add_child(_element)
			var pos : Vector2 = Vector2(
				screen_size.x - padding,
				screen_size.y - _space_between_elements - (len(_wave) * _space_between_elements)
			)
			_element.global_position = pos

func push_wave_queue(the_push: Array):
	if len(_wave_queue) != 0:
		if len(_wave_queue[0]) == 0:
			_wave_queue = []
	_wave_queue.push_back(the_push.duplicate(true))

