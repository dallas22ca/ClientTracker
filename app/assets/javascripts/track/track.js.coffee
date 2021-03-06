@Remetric ||= {}

Remetric.domain = "https://secure.remetric.com"
Remetric.api_key = false
Remetric.debug = false

Remetric.log = (data) ->
	console.log data if Remetric.debug

Remetric.detectPushes = ->
	@_RM ||= []

	_RM.push = (args) ->
		a = Array.prototype.push.call this, args
		Remetric.log "Remetric has received a(n) #{args[0]} event."
		setTimeout Remetric.parseEvents, 20
		a

Remetric.parseEvents = ->
	for event in _RM
		event = _RM.shift()
	
		if event[0] == "domain"
			Remetric.domain = event[1]
			Remetric.log "Remetric domain is set to #{Remetric.domain}."
		else if event[0] == "track"
			Remetric.log "Remetric has tracked \"#{event[1]}\"."
			Remetric.track event[1], event[2]
		else if event[0] == "api_key"
			Remetric.api_key = event[1]
			Remetric.log "Remetric API Key is set to #{Remetric.api_key}."
		else if event[0] == "debug"
			Remetric.debug = true
			Remetric.log "Remetric is set to debug mode."

	Remetric.detectPushes()

Remetric.track = (data) ->
	img = document.createElement("img")
	img.style.display = "none"
	params = data
	params["remetric_api_key"] = Remetric.api_key
	base64 = encodeURIComponent btoa(JSON.stringify(params))
	img.src = "#{Remetric.domain}/events/img/#{base64}"
	document.body.appendChild img

Remetric.parseEvents()