// ==UserScript==
// @name        SMBC
// @namespace   thomas
// @include     http://www.smbc-comics.com/index.php*
// @version     1
// @grant		none
// ==/UserScript==


window.addEventListener("keydown", function (e) {
	var createUrl = function (comicId) {
		return "http://www.smbc-comics.com/index.php?db=comics&id=" + comicId + "#comic";
	};

	var comicId;

	var url = window.location.href;

	if (url.indexOf("?") >= 0) {
		comicId = /\?db=comics&id=(\d+)(?:$|#)/.exec(url)[1] - 0;
	}
	else {
		var scripts = window.document.getElementsByTagName("script");
		Array.every(scripts, function (script) {
			var res = /var num = Math\.floor\(Math\.random\(\)\*(\d+)\)/.exec(script.innerHTML);
			if (res) {
				comicId = res[1] - 0;
				return false;
			}
			return true;
		});
	}

	var prevUrl = createUrl(comicId - 1);
	var nextUrl = createUrl(comicId + 1);

	var LEFT_ARROW = 37;
	var RIGHT_ARROW = 39;
	switch (e.keyCode) {
		case LEFT_ARROW:
			window.location.href = prevUrl;
			break;
		case RIGHT_ARROW:
			window.location.href = nextUrl;
			break;
	}
}, false);


window.addEventListener("keydown", function (e) {
	var ENTER = 13;
	switch (e.keyCode) {
		case ENTER:
			unsafeWindow.xMousePos = 20;
			unsafeWindow.yMousePos = 180 + window.pageYOffset;
			unsafeWindow.mouseOverMenu = true;
			unsafeWindow.currentMenu = "aftercomic";
			showSubmenu("aftercomic");
			var style = getStyle("aftercomic");
			style.zIndex = 999999;
			break;
	}
}, false);


window.addEventListener("keyup", function (e) {
	var ENTER = 13;
	switch (e.keyCode) {
		case ENTER:
			unsafeWindow.xMousePos = 2000;
			unsafeWindow.yMousePos = 18000 + window.pageYOffset;
			unsafeWindow.mouseOverMenu = false;
			hideSubmenu("aftercomic");
			break;
	}
}, false);










