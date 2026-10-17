@tool
class_name RadialMenuRenderer
extends Control

var menu: RadialMenu
var items: Array
var item_count: int

var center: Vector2
var mouse_position: Vector2
var input_angle: Vector2

const OUTER_RADIUS = 32.5
const SEMI_OUTER_RADIUS = 30.5
const INNER_RADIUS = 16
const SEMI_INNER_RADIUS = 14
const BORDER_ANGLE = 2


func _ready() -> void:
	center = self.get_rect().get_center()

	items = menu.find_children('*', "RadialMenuItem", false)
	item_count = items.size()
	var item_theta = 360.0 / item_count
	var half_theta = item_theta / 2.0
	var nb_points = item_theta / 10
	for i in item_count:
		var item = items[i]
		var points_arc = PackedVector2Array()

		var angle_offset = -90 + item_theta * i
		var angle_from = -1 * half_theta + angle_offset
		var angle_to = half_theta + angle_offset

		for j in range(nb_points + 1):
			var outer_from = angle_from + BORDER_ANGLE
			var outer_to = angle_to - BORDER_ANGLE
			var angle_point = deg_to_rad(
					angle_from + j * (angle_to-angle_from) / nb_points)
			points_arc.push_back(
				center + Vector2(cos(angle_point), sin(angle_point)) * SEMI_OUTER_RADIUS)

		for j in range(nb_points + 1):
			var inner_from = angle_from + BORDER_ANGLE * 2
			var inner_to = angle_to - BORDER_ANGLE * 2
			var angle_point = deg_to_rad(
					inner_from + (nb_points - j) * ((inner_to) - (inner_from)) / nb_points)
			points_arc.push_back(
				center + Vector2(cos(angle_point), sin(angle_point)) * SEMI_INNER_RADIUS)

		item.polygon = points_arc
		item.angle = Vector2(cos(deg_to_rad(angle_offset)), sin(deg_to_rad(angle_offset)))
		item.half_theta = deg_to_rad(half_theta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = event.position


func _process(_delta: float) -> void:
	input_angle = (mouse_position - center).normalized()
	queue_redraw()


func _draw() -> void:
	var bg_color = Color(0.0, 0.26, 0.26)
	var item_bg_color = Color(0.0, 0.372, 0.372)

	draw_circle(center, OUTER_RADIUS, bg_color)

	for i in item_count:
		var item: RadialMenuItem = items[i]
		draw_colored_polygon(item.polygon, item.color if item.is_input_over(input_angle) else item_bg_color)
