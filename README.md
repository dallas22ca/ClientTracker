## Todo

- Event index query
- Subscriptions
- Blog post
- Search
- Quickstart
- Contact Search
- Event Search
- Delta graph query
- Contact Show
- Contact Index
- Mobile

## Useful Event Charts

- See all events where product_name == Lively
- How many signups this week/day/month
- Click to see details of events in time period
- List of events by popularity
- Map of event locations
- Browser/Device info
- Chart where specific var is queried

## Useful Contact Charts

- How many added this week/day/month
- 10 recents?

## How to Use

```
<script type="text/javascript">
	this._RM || (this._RM = []);
	_RM.push(["debug"]);
	_RM.push(["api_key", "XXXXXXXXXXXXXXXXXX"]);
  _RM.push(["track", "added to {{ plan }} for {{ price }}", {
    key: "dallas",
    plan: "Awesome Plan",
    price: "$9.99"
  }, function(data) {
	  alert(data);
	}]);
	
  (function() {
    var rm = document.createElement("script"); rm.type = "text/javascript";
		rm.async = true;  rm.src = "https://secure.remetric.com/track.js";
		var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(rm, s);
  })();
</script>
```


## Functions

### Tracking

`contact`.`key` is always required. This is a unique token for each contact.

A `track` is the main event. Event's `contact` info is also saved to the contact.

If the contact doesn't exist, it will be created.

```
_RM.push(["track", "added to {{ plan }} for {{ price }}", {
  contact: {
    key: "dallas"
  },
  plan: "Awesome Plan",
  price: "$9.99"
}]);
```