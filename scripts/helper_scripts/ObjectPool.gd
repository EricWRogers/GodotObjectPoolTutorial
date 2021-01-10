extends Node
class_name ObjectPool

export var min_load_amount = 10
export var object_pool: Dictionary = {}

var _return_queue : Array = []

func _process(delta):
	# This is done so that returning the node happens after collision is done
	# calculating to avoid error.
	_clean_return_queue()

# Given a path to a scene file, take_node returns said scene from pool.
# @param path should be "*.tscn" scene files.
# @return the node from the pool that you asked for.
func take_node(path: String):
	var object
	if not path in object_pool:
		_load_object(path)
	
	object = object_pool[path][0]
	object_pool[path].erase(object)
	
	if (len(object_pool[path]) < 1):
		object_pool.erase(path)
	
	return object

# return_node will add the node to the _return_queue.
# @param object is a node you wish to return to the pool.
func return_node(object):
	if _return_queue.has(object):
		return
	_return_queue.append(object)

# Given a path to a scene file, _load_node adds said scene to the object pool
# times the min_load_amount.
# @param path should be "*.tscn" scene files.
func _load_object(path: String):
	var resource = load(path)
	for _i in min_load_amount:
		var object = resource.instance()
		if path in object_pool:
			object_pool[path].append(object)
		else:
			object_pool[path] = [object]

# Given _return_queue is not empty, _clean_return_queue will remove the objects
# from the tree then add them back to the pool.
func _clean_return_queue():
	while len(_return_queue) != 0:
		var object = _return_queue.pop_front()
		if object == null:
			return
		var par = object.get_parent()
		if par == null:
			return
		par.remove_child(object)
		if object.filename in object_pool:
			object_pool[object.filename].append(object)
		else:
			object_pool[object.filename] = [object]
