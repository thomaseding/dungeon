// ==UserScript==
// @name        Spacebar Paging
// @namespace   thomas
// @include     *
// @version     1
// ==/UserScript==

(function () {

	var mkHandleSpacebar = function (offsetFunc) {
		var dontHandle = (function () {
			var tags = {
				input: true,
				textarea: true
			};
			return function (tag) {
				return tag in tags;
			};
		})();

		return function (e) {
			if (dontHandle(document.activeElement.tagName.toLowerCase())) {
		//		return;
			}
			if (e.keyCode == ' '.charCodeAt(0)) {
				var x = window.pageYOffset;
				var y = window.pageYOffset;
				window.scrollTo(x, y + offsetFunc(y));
				e.preventDefault();
				//e.stopPropagation();
				//return false;
			}
		};
	};

	window.addEventListener("keydown", mkHandleSpacebar(function (y) {
		return window.innerHeight / 2;
	}), false);

})();


