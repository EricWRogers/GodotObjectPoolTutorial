extends Spawnable
class_name Pickup

var pu_value : int = 1

var _lucky_sack : LuckySack

func _ready():
	self.connect("body_entered", self, "_body_entered")
	_lucky_sack = get_node("/root/World/LuckySack")
	print(_lucky_sack)

func _body_entered(body : Node):
	if body.name == "Player":
		_lucky_sack.add_score(pu_value)
		clean_up()
