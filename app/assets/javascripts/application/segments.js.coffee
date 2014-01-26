@Segments =
	addCondition: (condition) ->
		template = $(".template[data-template='segment-condition']").clone()
		template.removeClass "template"
		template.find("[name='field[]']").val condition[0]
		template.find("[name='matcher[]']").val condition[1]
		template.find("[name='search[]']").val condition[2]

		template.appendTo $(".segment_conditions")
	
	init: ->
		if $(".segment_conditions").length
			conditions = $(".segment_conditions").data("segment-conditions")
		
			for c in conditions
				Segments.addCondition c

$(document).on "click", ".add_segment_condition", ->
	condition = ["", "", ""]
	Segments.addCondition condition
	false