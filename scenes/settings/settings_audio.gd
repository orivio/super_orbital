class_name SettingsAudio
extends Control

signal audio_changed

@onready var master_volume: HSlider = $VBoxContainer/GridContainer/HSlider
@onready var music_volume: HSlider = $VBoxContainer/GridContainer/HSlider2
@onready var sound_effects_volume: HSlider = $VBoxContainer/GridContainer/HSlider3
@onready var audio_devices: OptionButton = $VBoxContainer/GridContainer/OptionButton
@onready var refresh_audio_devices: Button = $VBoxContainer/GridContainer/Button
@onready var refresh_aduio_device_list_timer: Timer = $Timer

var audio_device_list: Array[StringName] = []
var audio_device_list_refresh_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var idx: int = 0
	audio_device_list.clear()
	for device in AudioServer.get_output_device_list():
		audio_devices.add_item(device)
		audio_device_list.append(device)
		if device == AudioServer.output_device:
			audio_devices.selected = idx
		
		idx += 1
	
	refresh_aduio_device_list_timer.start()
	
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Master")))
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Music")))
	sound_effects_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Sound Effects")))
	

func _on_master_volume_value_changed(value: float) -> void:
	var master_idx: int = AudioServer.get_bus_index(&"Master")
	AudioServer.set_bus_volume_db(master_idx, linear_to_db(value))
	audio_changed.emit()


func _on_music_volume_value_changed(value: float) -> void:
	var music_idx: int = AudioServer.get_bus_index(&"Music")
	AudioServer.set_bus_volume_db(music_idx, linear_to_db(value))
	audio_changed.emit()


func _on_sound_effect_volume_slider_value_changed(value: float) -> void:
	var sfx_idx: int = AudioServer.get_bus_index(&"Sound Effects")
	AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(value))
	audio_changed.emit()


func _on_audio_device_item_selected(index: int) -> void:
	AudioServer.output_device = audio_device_list[index]
	audio_changed.emit()

func _on_refresh_audio_device_list() -> void:
	print("Refreshing audio device list")
	refresh_aduio_device_list_timer.start()
