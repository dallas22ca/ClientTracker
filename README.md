## Todo

- Choose a name
- Push to Server
- Script on Amazon
- Add to Lively Plugin
- Add to Lively Script
- Add to CoScreen Plugin
- Add to CoScreen Script
- Search
  

## How to Use

```
<script type="text/javascript">
	this._CT || (this._CT = []);
	_CT.push(["debug"]);
	_CT.push(["api_key", "XXXXXXXXXXXXXXXXXX"]);
	_CT.push(["saveContact", {
		name: "Dallas Read",
    location: "Halifax, NS",
		key: "dallas"
	}, function(data) {
	  alert(data);
	}]);
	
  (function() {
    var ct = document.createElement("script"); ct.type = "text/javascript";
		ct.async = true;  ct.src = "//localhost:3000/assets/track.js";
		var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(ct, s);
  })();
</script>
```


## Functions

### Tracking

`key` is always required. This is a unique token for each contact.

A `track` is the main event. Event's data is also passed to the contact.

If the contact doesn't exist, it will be created.

```
_CT.push(["track", "added to {{ plan }} for {{ price }}", {
  key: "dallas",
  plan: "Awesome Plan",
  price: "$9.99"
}]);
```

### Contacts

The `key` element is always required and must be unique per contact. We'd recommend using your app's unique token or ID for that contact.

#### Updating a Contact

Save a contact with their data. If a contact already exists, new data will be merged with old data.

```
_CT.push(["saveContact", {
  key: "dallas",
  name: "Dallas Read",
  location: "Halifax, NS"
}]);
```

#### Overwriting A Contact's Data

This will overwrite contact's existing data with the new data. Contact will be created if it doesn't already exist.

```
_CT.push(["overwriteContact", {
  key: "dallas",
  name: "Dallas Read",
  location: "Halifax, NS"
}]);
```