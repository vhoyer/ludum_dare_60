@tool
class_name RadialMenuItem
extends Node

signal on_selected()

@export
var color: Color = Color(0.787, 0.291, 0.546)

var polygon: PackedVector2Array
var angle: Vector2
var half_theta: float


func is_input_over(angle: Vector2) -> bool:
	return self.angle.dot(angle) > cos(half_theta)
