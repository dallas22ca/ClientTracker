@Time =
	init: ->
		$(document).on "click change", "#time_picker input, #time_picker select", ->
			$(this).closest("form").submit()