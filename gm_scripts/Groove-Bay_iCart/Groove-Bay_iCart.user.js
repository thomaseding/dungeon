// ==UserScript==
// @name        Groove-Bay: iCart
// @namespace   thomas
// @include     http://groove-bay.com/iCart/*
// @include     http://www.groove-bay.com/iCart/*
// @version     1
// ==/UserScript==


(function () {
	var getTags = function (name) {
		return document.getElementsByTagName(name);
	};

	var boxes = Array.filter(getTags("input"), function (elt) {
		return elt.type.toLowerCase() === "checkbox";
	});
	if (boxes.length === 0) {
		var downloads = Array.filter(getTags("a"), function (elt) {
			return elt.innerHTML === "Download";
		});
		if (downloads.length !== 1) {
			alert("Userscript: huh? number of downloads isn't 1...");
		}
		else {
			window.location.href = downloads[0].href;
		}
	}
	else if (boxes.length === 1) {
		Array.forEach(boxes, function (box) {
			box.checked = true;
		});
		document.getElementById("id_ipurchase").click();
	}
	else {
		alert("Userscript: Too many songs to purchase!\nTry again.");
	}
})();




