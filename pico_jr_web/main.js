
	p8_update_layout();
	p8_update_button_icons();

	var canvas = document.getElementById("canvas");
	Module = {};
	Module.canvas = canvas;

	// from @ultrabrite's shell: test if an AudioContext can be created outside of an event callback.
	// If it can't be created, then require pressing the start button to run the cartridge

	if (p8_autoplay)
	{
		var temp_context = new AudioContext();
		temp_context.onstatechange = function ()
		{
			if (temp_context.state=='running')
			{
				p8_run_cart();
				temp_context.close();
			}
		};
	}

	// pointer lock request needs to be inside a canvas interaction event
	// pico8_state.request_pointer_lock is true when 0x5f2d bit 0 and bit 2 are set -- poke(0x5f2d,0x5) 
	// note on mouse acceleration for future: // https://github.com/w3c/pointerlock/pull/49
	canvas.addEventListener("click", function()
	{
		if (!p8_touch_detected)
			if (pico8_state.request_pointer_lock)
				canvas.requestPointerLock();
	});
	



function $_(e) { return document.getElementById(e); }

// Event listeners:

$_("p8_container").onclick = () => {p8_create_audio_context(); p8_run_cart();}

$_("p8b_full").onclick = () => {p8_give_focus(); p8_request_fullscreen();};
$_("p8b_sound").onclick = () => {p8_give_focus(); p8_create_audio_context(); Module.pico8ToggleSound();};
$_("p8b_close").onclick = () => {p8_close_cart();};

$_("p8b_controls").onclick = () => {p8_give_focus(); Module.pico8ToggleControlMenu();};
$_("p8b_pause").onclick = () => {p8_give_focus(); Module.pico8TogglePaused(); p8_update_layout_hash = -22;};
$_("p8b_sound").onclick = () => {p8_give_focus(); p8_create_audio_context(); Module.pico8ToggleSound();};
$_("p8b_full").onclick = () => {p8_give_focus(); p8_request_fullscreen();};

$_("canvas").oncontextmenu=(event) => {event.preventDefault()};
