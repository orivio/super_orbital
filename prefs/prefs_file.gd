class_name PrefsFile

const SAVE_PREFS_PATH: String = "user://preferences.cfg"

func _init() -> void:
	pass

func write_prefs() -> void:
	var file: ConfigFile = ConfigFile.new()
	
	var left = InputMap.action_get_events("left")[0]
	var right = InputMap.action_get_events("right")[0]
	var up = InputMap.action_get_events("up")[0]
	var down = InputMap.action_get_events("down")[0]
	var jump = InputMap.action_get_events("jump")[0]
	var dash = InputMap.action_get_events("dash")[0]
	var gravity_switch = InputMap.action_get_events("gravity_switch")[0]
	var throw_wrench = InputMap.action_get_events("throw_wrench")[0]
	var confirm = InputMap.action_get_events("confirm")[0]
	
	file.set_value("Controls", "left", left)
	file.set_value("Controls", "right", right)
	file.set_value("Controls", "up", up)
	file.set_value("Controls", "down", down)
	file.set_value("Controls", "jump", jump)
	file.set_value("Controls", "dash", dash)
	file.set_value("Controls", "gravity_switch", gravity_switch)
	file.set_value("Controls", "throw_wrench", throw_wrench)
	file.set_value("Controls", "confirm", confirm)
	
	var master_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Master"))
	var music_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Music"))
	var sfx_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Sound Effects"))
	
	file.set_value("Audio", "master_volume", master_volume)
	file.set_value("Audio", "music_volume", music_volume)
	file.set_value("Audio", "sfx_volume", sfx_volume)
	
	file.set_value("Graphics", "vsync_mode", DisplayServer.window_get_vsync_mode())
	file.set_value("Graphics", "fullscreen", DisplayServer.window_get_mode())
	
	file.save(SAVE_PREFS_PATH)

static func load_prefs() -> PrefsFile:
	var prefs_file: PrefsFile = PrefsFile.new()
	var file: ConfigFile = ConfigFile.new()
	if file.load(SAVE_PREFS_PATH) != OK:
		return null
	
	var action_names: Array[StringName] = ["left", "right", "up", "down", "jump", "dash", "gravity_switch", "throw_wrench", "confirm"]
	for action_name in action_names:
		if file.has_section_key("Controls", action_name):
			InputMap.action_erase_events(action_name)
			var saved_event = file.get_value("Controls", action_name)
			InputMap.action_add_event(action_name, saved_event)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Master"), file.get_value("Audio", "master_volume", 0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Music"), file.get_value("Audio", "music_volume", 0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Sound Effects"), file.get_value("Audio", "sfx_volume", 0))
	
	DisplayServer.window_set_vsync_mode(file.get_value("Graphics", "vsync_mode", DisplayServer.VSYNC_ENABLED))
	DisplayServer.window_set_mode(file.get_value("Graphics", "fullscreen", Window.Mode.MODE_WINDOWED))
	
	return prefs_file
