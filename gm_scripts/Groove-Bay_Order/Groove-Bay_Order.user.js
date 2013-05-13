// ==UserScript==
// @name        Groove-Bay: Order
// @namespace   thomas
// @include     http://groove-bay.com/Order/
// @include     http://www.groove-bay.com/Order/
// @version     1
// ==/UserScript==



(function () {
	Array.filter(document.getElementsByTagName("input"), function (elt) {
		return elt.value === "PURCHASE";
	})[0].click();
})();


