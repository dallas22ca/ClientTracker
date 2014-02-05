@Time =
	init: ->
		$(document).on "click change", "#time_picker input, #time_picker select", ->
			$("#logo").hide()
			$("#loading_logo").show()
			$(this).closest("form").submit()