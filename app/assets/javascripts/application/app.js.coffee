$(document).on "click", ".delete_field", ->
	$(this).closest(".field").remove()
	false

load = ->
	Contacts.init()
	Segments.init()

document.addEventListener "page:change", load