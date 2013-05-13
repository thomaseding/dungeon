// ==UserScript==
// @name           Wikipedia Title Shortener
// @namespace      thomas
// @description    Shortens page titles for Wikipedia
// @include        http://*.wikipedia.org/*
// ==/UserScript==


var title = document.getElementsByTagName("title")[0];
title.innerHTML = title.innerHTML.replace(" - Wikipedia, the free encyclopedia", "");

