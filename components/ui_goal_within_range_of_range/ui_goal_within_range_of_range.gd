extends Control

## Minimum value.
## Range is clamped if [value_range_start] is less than [min_value].
@export var editable: bool = true:
	get:
		return editable
	set(value):
		if %HSlider:
			%HSlider.editable = value

## Minimum value.
## Range is clamped if [value_range_start] is less than [min_value].
@export var min_value: float = 0.0:
	get:
		return min_value
	set(value):
		if %ProgressBarOverlapBelowValue:
			%ProgressBarOverlapBelowValue.min_value = value
		if %ProgressBarValueRangeEnd:
			%ProgressBarValueRangeEnd.min_value = value
		if %HSlider:
			%HSlider.min_value = value
		if %LabelMinValue:
			%LabelMinValue.text = (
				_float_to_string_truncate_decimal_if_whole_number(value)
			)

## Maximum value.
## Range is clamped if [value_range_end] is greater than [max_value].
@export var max_value: float = 100.0:
	get:
		return max_value
	set(value):
		if %ProgressBarOverlapBelowValue:
			%ProgressBarOverlapBelowValue.max_value = value
		if %ProgressBarValueRangeEnd:
			%ProgressBarValueRangeEnd.max_value = value
		if %HSlider:
			%HSlider.max_value = value
		if %LabelMaxValue:
			%LabelMaxValue.text = (
				_float_to_string_truncate_decimal_if_whole_number(value)
			)

## Lowest end of the current value.
@export var value_range_start: float = 0.0:
	get:
		return value_range_start
	set(value):
		if %ProgressBarOverlapBelowValue:
			%ProgressBarOverlapBelowValue.value = value
		if %LabelValueRangeStart:
			%LabelValueRangeStart.text = (
				_float_to_string_truncate_decimal_if_whole_number(value)
			)

## Highest end of the current value.
@export var value_range_end: float = 0.0:
	get:
		return value_range_end
	set(value):
		if %ProgressBarValueRangeEnd:
			%ProgressBarValueRangeEnd.value = value
		if %LabelValueRangeEnd:
			%LabelValueRangeEnd.text = (
				_float_to_string_truncate_decimal_if_whole_number(value)
			)

## Highest end of the current value.
@export var value: float = 0.0:
	get:
		return value
	set(value):
		if %HSlider:
			%HSlider.value = value
		if %LabelValue:
			%LabelValue.text = (
				_float_to_string_truncate_decimal_if_whole_number(value)
			)

func _ready():
	min_value = min_value
	max_value = max_value
	value_range_start = value_range_start
	value_range_end = value_range_end


## Set a goal as a range from [value_range_start] to [value_range_end].
func set_value_range(start: float, end: float) -> void:
	value_range_start = start
	value_range_end = end


func _float_to_string_truncate_decimal_if_whole_number(incoming_value: float) -> String:
	if incoming_value == int(incoming_value):
		return str(int(incoming_value))
	else:
		return str(incoming_value)


func _on_h_slider_value_changed(incoming_value: float) -> void:
	value = incoming_value
