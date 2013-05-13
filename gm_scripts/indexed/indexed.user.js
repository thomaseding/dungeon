// ==UserScript==
// @name           Indexed
// @namespace      thomas
// @description    Keyboard Navigation
// @include        http://thisisindexed.com/*
// ==/UserScript==



(function () {
	var url = window.location.href;

	var PageDir = {
		BACK: -1,
		FORWARD: 1
	};

	var monthly = function (pageDir) {
		var m = /\/(\d{4})\/(\d{2})\/?$/.exec(url);
		var year = m[1] - 0;
		var month = m[2] - 0 + pageDir;
		if (month == 0) {
			month = 12;
			--year;
		}
		else if (month % 13 == 0) {
			month = 1;
			++year;
		}
		month = (month < 10 ? "0" : "") + month;
		window.location.href = "http://thisisindexed.com/" + year + "/" + month + "/";
	}

	var recently = function (pageDir) {
		// TODO
	}

	window.addEventListener("keyup", function (e) {
		var LEFT = 37;
		var RIGHT = 39;
		var pageDir;
		switch (e.keyCode) {
			case LEFT:
				pageDir = PageDir.BACK;
				break;
			case RIGHT:
				pageDir = PageDir.FORWARD;
				break;
			default:
				return;
		}
		if (/\/\d{4}\/\d{2}\/?$/.test(url)) {
			monthly(pageDir);
		}
		else if (/\/?(?:page\/\d+\/?)?$/.test(url)) {
			recently(pageDir);
		}
	}, false);
})();



