class_name CSV

var current: Dictionary:
	get():
		var dict = {};
		for i in columns.size():
			var value = null if line.size() <= i else line[i];
			dict[columns[i]] = value;
		return dict;

var file: FileAccess;
var line: PackedStringArray;

var columns: PackedStringArray;

func _init(path: String, columns: PackedStringArray = []):
	file = FileAccess.open(path, FileAccess.READ)
	if (columns.size() == 0):
		next();
		self.columns = line;
		line = []
	else:
		self.columns = columns;
	pass

func close():
	file.close()

func has_next() -> bool:
	return file.get_position() < file.get_length();

func next() -> bool:
	var has_next = self.has_next();
	line = file.get_csv_line();
	return has_next;
