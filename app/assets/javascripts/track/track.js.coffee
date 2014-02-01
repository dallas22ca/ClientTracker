@remetric ||= {}

remetric.api_key = false
remetric.debug = false

remetric.log = (data) ->
	console.log data if remetric.debug

remetric.responder = (response, callback) ->
	callback(response) if typeof callback == "function"
	remetric.log response

remetric.detectPushes = ->
	@_CT ||= []

	_CT.push = (args) ->
		a = Array.prototype.push.call this, args
		remetric.log "remetric has received a(n) #{args[0]} event."
		setTimeout remetric.parseEvents, 20
		a

remetric.contacts = (path, data, callback = false) ->
	Zepto.post "/contacts#{path}.json",
		api_key: remetric.api_key
		contact:
			data: data
	, (response) ->
		remetric.responder response, callback

remetric.track = (description, data, callback = false) ->
	Zepto.post "/events.json",
		api_key: remetric.api_key
		event:
			data: data
			description: description
	, (response) ->
		remetric.responder response, callback

remetric.parseEvents = ->
	for event in _CT
		event = _CT.shift()
	
		if event[0] == "saveContact"
			remetric.log "remetric is attempting to save contact..."
			remetric.contacts "/save", event[1], event[2], event[3]
		else if event[0] == "overwriteContact"
			remetric.log "remetric is attempting to replace contact..."
			remetric.contacts "/overwrite", event[1], event[2], event[3]
		else if event[0] == "track"
			desc = Mustache.render event[1], event[2]
			remetric.log "remetric is tracking \"#{desc}\" for #{event[1]}..."
			remetric.track event[1], event[2], event[3]
		else if event[0] == "api_key"
			remetric.api_key = event[1]
			remetric.log "remetric API Key is set to #{remetric.api_key}."
		else if event[0] == "debug"
			remetric.debug = true
			remetric.log "remetric is set to debug mode."

	remetric.detectPushes()

remetric.parseEvents()