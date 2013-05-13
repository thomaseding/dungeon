// ==UserScript==
// @name        Quickmeme Keyboard Navigation
// @namespace   thomas
// @description use arrow keys to navigate
// @include     http://www.quickmeme.com/*
// @version     1
// ==/UserScript==

(function () {
	var scripts = window.document.getElementsByTagName("scripts");
	Array.every(scripts, function (script) {
		var comicNum = /var num = Math.floor\(Math.random\(\)*(\d+)\)/.exec(script.innerHTML)[1];
		return true;
	});
})();


(function () {
	var previousPage;
	var nextPage;
	Array.prototype.forEach.call(document.getElementsByTagName("a"), function (anchor) {
		if (anchor.innerHTML === " « previous page") {
			previousPage = anchor.href;
		}
		if (anchor.innerHTML === "next page »") {
			nextPage = anchor.href;
		}
	});

	window.addEventListener("keyup", function (e) {
		var LEFT = 37;
		var RIGHT = 39;
		switch (e.keyCode) {
			case LEFT:
				window.location.href = previousPage;
				break;
			case RIGHT:
				window.location.href = nextPage;
				break;
			default:
				return;
		}
	});
})();





