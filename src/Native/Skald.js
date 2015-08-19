// Copyright 2015 Ian D. Bollinger
//
// Licensed under the MIT license <LICENSE or
// http://opensource.org/licenses/MIT>. This file may not be copied, modified,
// or distributed except according to those terms.

Elm.Native.Skald = {};
Elm.Native.Skald.make = function(elm) {
	elm.Native = elm.Native || {};
	elm.Native.Skald = elm.Native.Skald || {};
	if (elm.Native.Skald.values)
	{
		return elm.Native.Skald.values;
	}

	function scrollToBottom(ignored)
	{
		var d = document;
		var height = Math.max(
			d.body.scrollHeight || d.documentElement.scrollHeight,
			d.body.offsetHeight || d.documentElement.offsetHeight,
			d.body.clientHeight || d.documentElement.clientHeight);
		window.scrollTo(0, height);
		return ignored;
	}

	return elm.Native.Skald.values = {
		scrollToBottom: scrollToBottom,
	};
};
