(function(){this.Remetric||(this.Remetric={}),Remetric.domain="https://secure.remetric.com",Remetric.api_key=!1,Remetric.debug=!1,Remetric.log=function(e){return Remetric.debug?console.log(e):void 0},Remetric.detectPushes=function(){return this._RM||(this._RM=[]),_RM.push=function(e){var t;return t=Array.prototype.push.call(this,e),Remetric.log("Remetric has received a(n) "+e[0]+" event."),setTimeout(Remetric.parseEvents,20),t}},Remetric.parseEvents=function(){var e,t,i;for(t=0,i=_RM.length;i>t;t++)e=_RM[t],e=_RM.shift(),"domain"===e[0]?(Remetric.domain=e[1],Remetric.log("Remetric domain is set to "+Remetric.domain+".")):"track"===e[0]?(Remetric.log('Remetric has tracked "'+e[1]+'".'),Remetric.track(e[1],e[2])):"api_key"===e[0]?(Remetric.api_key=e[1],Remetric.log("Remetric API Key is set to "+Remetric.api_key+".")):"debug"===e[0]&&(Remetric.debug=!0,Remetric.log("Remetric is set to debug mode."));return Remetric.detectPushes()},Remetric.track=function(e){var t,i,r;return i=document.createElement("img"),i.style.display="none",r=e,r.remetric_api_key=Remetric.api_key,t=encodeURIComponent(btoa(JSON.stringify(r))),i.src=""+Remetric.domain+"/events/img/"+t,document.body.appendChild(i)},Remetric.parseEvents()}).call(this);