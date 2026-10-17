class_name URL

var scheme: String
var authority: String
var path: String
var fragment: String
var query: Dictionary = {}

var query_string: String:
	set(value):
		if value == '': return

		query = {}
		for pair in value.split('&'):
			var parts = pair.split('=')
			query[parts[0]] = parts[1]
	get():
		var pair_list = query.keys().map(func(key):
			var value = query.get(key)
			if typeof(value) == TYPE_ARRAY:
				return '&'.join(value.map(func(v): return str(key) + '=' + str(v)))
			return str(key) + '=' + str(value)
			)
		return '&'.join(pair_list)

var href: String:
	get():
		var full = ''
		if scheme:
			full += scheme + '://'
		if authority:
			full += authority
		if path:
			full += path
		if query:
			full += '?' + query_string
		if fragment:
			full += fragment
		return full

func _init(raw: String = ''):
	if raw == '': return

	var regex = RegEx.new()
	regex.compile('^((?<scheme>[^:/?#]+):)?(//(?<authority>[^/?#]*))?(?<path>[^?#]*)(\\?(?<query>[^#]*))?(?<fragment>#(.*))?')

	var result = regex.search(raw)
	if !result:
		assert(false, 'Error: Not a valid URL')
		return

	scheme = get_group_from_regex(result, 'scheme')
	authority = get_group_from_regex(result, 'authority')
	path = get_group_from_regex(result, 'path')
	fragment = get_group_from_regex(result, 'fragment')
	query_string = get_group_from_regex(result, 'query')

func get_group_from_regex(regex_match: RegExMatch, group_name: String) -> String:
	var group_id = regex_match.names.get(group_name, null)
	if group_id == null: return ''
	return regex_match.get_string(group_id)
