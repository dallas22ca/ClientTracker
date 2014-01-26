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

A `track` is our mainstay. Events data is also passed on to the contact (which is created if necessary).

```
_CT.push(["track", "added to {{ plan }} for {{ price }}", {
	plan: "Awesome Plan",
	price: "$9.99",
  key: "dallas"
}]);
```

### Contacts

The `key` element is always required and must be unique per contact. We'd recommend using your app's unique token or ID for that contact.

#### Save a Contact

Save a contact with their data. New data will be merged with already saved data.

```
_CT.push(["saveContact", {
	name: "Dallas Read",
  location: "Halifax, NS",
	key: "dallas"
}]);
```

#### Overwrite A Contact's Data

This will overwrite contact's existing data with the new data.

```
_CT.push(["overwriteContact", {
	name: "Dallas Read",
  location: "Halifax, NS",
	key: "dallas"
}]);
```