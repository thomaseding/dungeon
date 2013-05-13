// ==UserScript==
// @name        Groove-Bay: NewMember
// @namespace   thomas
// @include     http://groove-bay.com/Registration/?note=NewMember
// @include     http://www.groove-bay.com/Registration/?note=NewMember
// @version     1
// ==/UserScript==



(function () {
	var randInt = function (lo, hi) {
		return Math.floor(Math.random() * (hi - lo)) + lo;
	};
	var randWord = function (len) {
		var alphas = "abcdefghijklmnopqrstuvwxyz".split("");
		var word = "";
		for (var i = 0; i < len; ++i) {
			word += alphas[randInt(0, alphas.length)];
		};
		return word;
	};
	var padLeft = function (str, padding, size) {
		str = "" + str;
		while (str.length < size) {
			str = padding + str;
		}
		return str;
	};
	var $ = function (id) {
		return document.getElementById(id);
	};

	$("rid_email").value = randWord(6) + "@" + randWord(5) + ".com";
	$("rid_password").value = randWord(8);
	$("rid_repassword").value = $("rid_password").value;
	$("rid_name").value = randWord(6);
	$("rid_sname").value = randWord(7);
	$("rid_gender").selectedIndex = randInt(0, 2);
	$("rid_birth_year").value = randInt(1965, 1995);
	$("rid_birth_month").value = padLeft(randInt(0, 12) + 1, "0", 2);
	$("rid_birth_day").value = randInt(0, 28) + 1;

	$("ver-txt-code").focus();


	var decodeCaptcha = function (captchaImg) {
		var convertImageToCanvas = function (image) {
			var canvas = document.createElement("canvas");
			canvas.width = image.width;
			canvas.height = image.height;
			canvas.getContext("2d").drawImage(image, 0, 0);
			return canvas;
		};

		var Color = function (r, g, b, a) {
			if (a === undefined) {
				a = 255;
			}
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		};

		Color.prototype.toString = function () {
			return "[" + [this.r, this.g, this.b, this.a].join(",") + "]";
		};

		Color.prototype.equals = function (c) {
			return this.r === c.r && this.g === c.g && this.b === c.b && this.a === c.a;
		};

		Color.BLACK = new Color(0, 0, 0);
		Color.WHITE = new Color(255, 255, 255);
		Color.RED = new Color(255, 0, 0);

		var imageDataToRows = function (imgData) {
			var data = imgData.data;
			var rows = [];
			for (var r = 0; r < imgData.height; ++r) {
				var row = [];
				rows.push(row);
				for (var c = 0; c < imgData.width; ++c) {
					var idx = 4 * (c + imgData.width * r);
					var color = new Color();
					row.push(color);
					color.r = data[idx + 0];
					color.g = data[idx + 1];
					color.b = data[idx + 2];
					color.a = data[idx + 3];
				}
			}
			return rows;
		};

		var rowsToCols = function (rows) {
			var cols = [];
			var numRows = rows.length;
			var numCols = rows[0].length;
			for (var c = 0; c < numCols; ++c) {
				var col = [];
				cols.push(col);
				for (var r = 0; r < numRows; ++r) {
					col.push(rows[r][c]);
				}
			}
			return cols;
		};

		var normalizeColors = function (color2dArray) {
			return color2dArray.map(function (colors) {
				return colors.map(function (color) {
					return color.equals(Color.RED) ? Color.BLACK : Color.WHITE;
				});
			});
		};

		var extractDigit = function (cols) {
			while (true) {
				var col = cols[0];
				var hasBlack = col.some(function (color) {
					return color.equals(Color.BLACK);
				});
				if (hasBlack) {
					break;
				}
				cols.shift();
			}
			var digit = [];
			while (true) {
				var col = cols[0]
				var hasBlack = col.some(function (color) {
					return color.equals(Color.BLACK);
				});
				if (!hasBlack) {
					break;
				}
				Array.prototype.push.apply(digit, cols.shift());
			}
			return digit;
		};

		var getDigits0123456789 = function () {
			var url = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFkAAAAeCAYAAABHVrJ7AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAGdSURBVGhD7ZnBEsMgCERr//+f2+iMGcoAi0nk0Nkeq2HxsaJp2+f4vPjZSuC9NTqDDwKEXGAEQibkAgIFEnQyIRcQKJCgkwm5gECBBJ1cALnpN77W2pD1XgSj8Tk289Yx9HikM2NoPStGVk/mE8XReaF19fnRnB/IKJgc9wDO7z041kJRQeWikQlQcdCvCChvSx89c7YLOVGDsiold5klbMHWC7R0NKQruznKZyVeZl2ZOQNyZmIH4rkgGosW5blyxa19Ltr6XjvRuWndyGxoR8jY2w4+1LufACyL64GeRUCF8PKRoDNmtHb9FsjIiR4c9NzszXrneG2nx8sWwjuEURvV58XU3OrkDCi9fbXLLPchJ1ptSW7pqBAZwCjnWUyrjQwnP9V7VgB7UGSyHqQrwC29u/lmD+mzXaDeg05llLB1QKFnIndK0FcOrIz2ivmifNIvI557eiLIWdFVDZ3S6ICMbg46r5U7unVFvax1CPM/PrRNb45vuV3czOnvHifkgpISMiEXECiQoJMJuYBAgQSdTMgFBAok6OQCyF9khXAtv8XVkAAAAABJRU5ErkJggg==";
			var img = document.createElement("img");
			img.src = url;
			var canvas = convertImageToCanvas(img);
			var imgData = canvas.getContext("2d").getImageData(0, 0, canvas.width, canvas.height);
			var rows = imageDataToRows(imgData);
			var cols = rowsToCols(rows);
			var digits = [];
			for (var i = 0; i < 10; ++i) {
				digits.push(extractDigit(cols));
			}
			return digits;
		};

		var canvas = convertImageToCanvas(captchaImg);
		var imgData = canvas.getContext("2d").getImageData(0, 0, canvas.width, canvas.height);

		var rows = normalizeColors(imageDataToRows(imgData));
		var cols = rowsToCols(rows);

		var captchaDigits = [];
		for (var i = 0; i < 4; ++i) {
			captchaDigits.push(extractDigit(cols));
		}

		var allDigits = getDigits0123456789();

		var captchaCode = "";

		for (var i = 0; i < captchaDigits.length; ++i) {
			var captchaDigit = captchaDigits[i];
			var matchedNumber = -1;
			for (var j = 0; j < allDigits.length; ++j) {
				var matchesDigit = true;
				for (var k = 0; k < captchaDigit.length; ++k) {
					if (!captchaDigit[k].equals(allDigits[j][k])) {
						matchesDigit = false;
						break;
					}
				}
				if (matchesDigit) {
					matchedNumber = j;
					captchaCode += matchedNumber;
				}
			}
		}

		return captchaCode;
	};

	var startTime = new Date();
	var captchaImg = $("id_regform").getElementsByTagName("img")[0];
	var captchaField = $("ver-txt-code");
	var initialCaptchaVal = captchaField.value;
	var intervalId = setInterval(function () {
		captchaField.value = decodeCaptcha(captchaImg);
		var changed = initialCaptchaVal !== captchaField.value;
		var currTime = new Date();
		var diffMillSec = currTime - startTime
		if (changed || diffMillSec > 5000) {
			clearTimeout(intervalId);
			var inputs = document.getElementsByTagName("input");
			for (var i = 0; i < inputs.length; ++i) {
				var input = inputs[i];
				if (input.type.toLowerCase() === "submit" && input.value === "Register!") {
					input.click();
				}
			}
		}
	}, 10);
})();










