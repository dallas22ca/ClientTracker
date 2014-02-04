@Overview =
	init: ->
		Overview.drawEPM()
		Overview.drawLatestEvents()
	
	drawEPM: ->
		if typeof $("#epm").data("chart") != "undefined"
			$("#epm").highcharts
				chart:
					type: "area"
				title:
					text: "Events / Minute"
					style:
						color: "#777"
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
						text: false
						style:
							color: "#777"
					labels:
						style:
							color: "#cccccc"
					min: 0
				series: [
					name: "E/M"
					color: "#4AA4C9"
					lineWidth: 2
					marker:
						enabled: false
					animation: false
					data: $("#epm").data("chart")
				]
	
	drawLatestEvents: ->
		if typeof $("#latest_events").data("chart") != "undefined"
			$("#latest_events").highcharts
				chart:
					type: "area"
				title:
					text: "Latest Events"
					style:
						color: "#777"
					x: 20
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
						text: "Events"
				legend:
					borderWidth: 0
					layout: "vertical"
				tooltip:
					shared: true
				series: $("#latest_events").data("chart")
	
	poll: ->
		$.getScript window.location.href, ->
			setTimeout ->
				Overview.poll()
			, 15000