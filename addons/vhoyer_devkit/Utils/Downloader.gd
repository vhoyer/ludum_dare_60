class_name Downloader

static func save_image(context: Node, url: String, path: String) -> void:
	var http_request := HTTPRequest.new()
	context.add_child(http_request) # Needs to be added to the scene tree to work

	http_request.request_completed.connect(
		func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
			if result != OK or response_code != 200:
				push_error("Failed to download image: HTTP result %d, code %d" % [result, response_code])
				http_request.queue_free()
				return

			var image := Image.new()
			var error := image.load_png_from_buffer(body)
			if error != OK:
				push_error("Failed to load image from buffer.")
				http_request.queue_free()
				return

			error = image.save_png(path)
			if error != OK:
				push_error("Failed to save image to path: %s" % path)

			http_request.queue_free()
	)

	var error := http_request.request(url)
	if error != OK:
		push_error("Failed to start HTTP request.")
		http_request.queue_free()
