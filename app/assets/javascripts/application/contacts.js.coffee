@Contacts =
	addData: (data) ->
		template = $(".template[data-template='contact-data']").clone()
		template.removeClass "template"
		
		for k, v of data
			template.find("[name='data_label[]']").val k
			template.find("[name='data_content[]']").val v

		template.appendTo $(".contact_data")
	
	init: ->
		if $(".contact_data").length
			data = $(".contact_data").data("contact-data")
		
			for k, v of data
				c = {}
				c[k] = v
				Contacts.addData c

$(document).on "click", ".add_contact_data", ->
	data = {}
	Contacts.addData data
	false