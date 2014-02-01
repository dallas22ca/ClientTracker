@Remetric ||= {}

Remetric.domain = "https://secure.remetric.com"
Remetric.api_key = false
Remetric.debug = false

Remetric.log = (data) ->
	console.log data if Remetric.debug

Remetric.responder = (response, callback) ->
	callback(response) if typeof callback == "function"
	Remetric.log response

Remetric.detectPushes = ->
	@_RM ||= []

	_RM.push = (args) ->
		a = Array.prototype.push.call this, args
		Remetric.log "Remetric has received a(n) #{args[0]} event."
		setTimeout Remetric.parseEvents, 20
		a

Remetric.contacts = (path, data, callback = false) ->
	Zepto.ajax "#{Remetric.domain}/contacts#{path}.json",
		type: "POST"
		dataType: "jsonp"
		data:
			api_key: Remetric.api_key
			contact:
				data: data
		complete: (response) ->
			Remetric.responder response, callback

Remetric.track = (description, data, callback = false) ->
	Zepto.ajax "#{Remetric.domain}/events.json",
		type: "POST"
		dataType: "jsonp"
		data:
			api_key: Remetric.api_key
			event:
				data: data
				description: description
		complete: (response) ->
			Remetric.responder response, callback

Remetric.parseEvents = ->
	for event in _RM
		event = _RM.shift()
	
		if event[0] == "domain"
			Remetric.domain = event[1]
			Remetric.log "Remetric domain is set to #{Remetric.domain}."
		else if event[0] == "saveContact"
			Remetric.log "Remetric is attempting to save contact..."
			Remetric.contacts "/save", event[1], event[2], event[3]
		else if event[0] == "overwriteContact"
			Remetric.log "Remetric is attempting to replace contact..."
			Remetric.contacts "/overwrite", event[1], event[2], event[3]
		else if event[0] == "track"
			desc = Mustache.render event[1], event[2]
			Remetric.log "Remetric is tracking \"#{desc}\" for #{event[1]}..."
			Remetric.track event[1], event[2], event[3]
		else if event[0] == "api_key"
			Remetric.api_key = event[1]
			Remetric.log "Remetric API Key is set to #{Remetric.api_key}."
		else if event[0] == "debug"
			Remetric.debug = true
			Remetric.log "Remetric is set to debug mode."

	Remetric.detectPushes()

Remetric.parseEvents()