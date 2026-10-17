## This is basically an array that only allows one instance of any given item
## to exist in the list
class_name VHDSet

## PRIVATE! DO NOT MODIFY this array outside of the class, use this class' methods instead
var _elements: Array = []

func _init(arr: Array = []) -> void:
	if arr.is_empty(): return
	for item in arr:
		add(item)


func add(value: Variant) -> void:
	if _elements.has(value): return
	_elements.append(value)

func has(value: Variant) -> bool:
	return _elements.has(value)

func has_all(arr: Array) -> bool:
	return arr.all(func(item):
		return self.has(item))

func erase(value: Variant) -> void:
	_elements.erase(value)

func erase_all() -> void:
	_elements.resize(0)

func size() -> int:
	return _elements.size()

func pop_front() -> Variant:
	return _elements.pop_front()

func at(index: int) -> Variant:
	return _elements[index]

## returns a copy of the list of elements to avoid the possibility of outside
## code altering the list manually, cuz that means we lose the trust in the
## list
func values() -> Array:
	return _elements.duplicate()
