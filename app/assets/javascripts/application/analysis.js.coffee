@Analysis =
	
	loadGraph: (element) ->
		element.highcharts
			chart:
				type: "area"
				backgroundColor: ""
			title: false
			colors: ["#777777"]
			xAxis:
				crosshair:
					snap: true
				type: "datetime"
			yAxis:
				title: false
				gridLineWidth: 0
				minorGridLineWidth: 0
			legend: false
			tooltip:
				shared: true
			series: [
				animation: false
				color: "#4AA4C9"
				lineWidth: 2
				marker:
					enabled: false
				data: [[0, 1], [32434234343, 2], [324342343431, 5], [424342343432, 15]] # element.data("graph")
			]