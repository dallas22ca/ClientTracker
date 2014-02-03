@Overview =
	init: ->
		$("#epm").highcharts
			chart:
				type: "area"
			title: "Awesome"
			legend: false
			xAxis:
				type: "datetime"
				dateTimeLabelFormats:
					second: '%e. %b'
					minute: '%e. %b'
					hour: '%e. %B'
					day: '%e. %b'
					week: '%e. %b'
					month: '%e. %b'
					year: '%e. %b'
			yAxis:
				title:
					text: "Events / Minute"
					style:
						color: "#777"
				labels:
					style:
						color: "#cccccc"
				min: 0
			series: [
				lineWidth: 2
				name: "E/M"
				color: "#4AA4C9"
				marker:
					enabled: false
				animation: false
				data: $("#epm").data("chart")
			]