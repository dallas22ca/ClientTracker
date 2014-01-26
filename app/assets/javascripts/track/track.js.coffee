@ClientTracker ||= {}

ClientTracker.api_key = false
ClientTracker.debug = false

ClientTracker.log = (data) ->
	console.log data if ClientTracker.debug

ClientTracker.responder = (response, callback) ->
	callback(response) if typeof callback == "function"
	ClientTracker.log response

ClientTracker.detectPushes = ->
	@_CT ||= []

	_CT.push = (args) ->
		a = Array.prototype.push.call this, args
		ClientTracker.log "ClientTracker has received a(n) #{args[0]} event."
		setTimeout ClientTracker.parseEvents, 20
		a

ClientTracker.contacts = (path, data, callback = false) ->
	key = data["key"]
	delete data["key"]

	Zepto.post "/contacts#{path}.json",
		contact:
			key: key
			data: data
	, (response) ->
		ClientTracker.responder response, callback

ClientTracker.track = (description, data, callback = false) ->
	key = data["key"]
	delete data["key"]
	
	Zepto.post "/contacts/#{key}/events.json",
		event:
			key: key
			data: data
			description: description
	, (response) ->
		ClientTracker.responder response, callback

ClientTracker.parseEvents = ->
	for event in _CT
		event = _CT.shift()
	
		if event[0] == "saveContact"
			ClientTracker.log "ClientTracker is attempting to save contact..."
			ClientTracker.contacts "/save", event[1], event[2], event[3]
		else if event[0] == "overwriteContact"
			ClientTracker.log "ClientTracker is attempting to replace contact..."
			ClientTracker.contacts "/overwrite", event[1], event[2], event[3]
		else if event[0] == "track"
			desc = Mustache.render event[1], event[2]
			ClientTracker.log "ClientTracker is tracking \"#{desc}\" for #{event[1]}..."
			ClientTracker.track event[1], event[2], event[3]
		else if event[0] == "api_key"
			ClientTracker.api_key = event[1]
			ClientTracker.log "ClientTracker API Key is set to #{ClientTracker.api_key}."
		else if event[0] == "debug"
			ClientTracker.debug = true
			ClientTracker.log "ClientTracker is set to debug mode."

	ClientTracker.detectPushes()

ClientTracker.parseEvents()