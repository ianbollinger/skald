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
		var element = document.getElementById("field");
		var d = document;
		var height = Math.max(
			d.body.scrollHeight || d.documentElement.scrollHeight,
			d.body.offsetHeight || d.documentElement.offsetHeight,
			d.body.clientHeight || d.documentElement.clientHeight);
		if (element != null)
		{
			element.scrollIntoView({block: "end"});
		}
		window.scrollTo(0, height);
		return ignored;
	}

	return elm.Native.Skald.values = {
		scrollToBottom: scrollToBottom,
	};
};
