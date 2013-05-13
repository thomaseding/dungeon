// ==UserScript==
// @name        Quickmeme remove addbar
// @namespace   thomas
// @description see title
// @include     http://www.quickmeme.com/*
// @include     http://www.quickmeme.com/latest/*
// @version     1
// ==/UserScript==


(function () {
	var cw = document.getElementsByClassName("centerwrapper")[0];
	cw.removeChild(cw.getElementsByTagName("div")[0]);
})();







