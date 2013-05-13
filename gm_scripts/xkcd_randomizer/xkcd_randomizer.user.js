// ==UserScript==
// @name           xkcd randomizer
// @namespace      thomas
// @description    Ctrl + R = Random Page
// @include        http://xkcd.com/*
// ==/UserScript==
//






(function () {
	window.addEventListener("keyup", function (e) {
		var R = 82;
		switch (e.keyCode) {
			case R:
				window.location.href = "http://dynamic.xkcd.com/random/comic/";
			default:
				return;
		}
	}, false);
})();



