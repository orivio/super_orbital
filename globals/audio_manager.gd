extends Node

const MUSIC_DIRECTORY: SoundDirectory = preload("res://sounds/music/music_registry.tres")

@onready var music_player: AudioStreamPlayer = $MusicPlayer


func _ready() -> void:
	change_music(&"Lone Traveller")


func stop_sound() -> void:
	music_player.stop()


func change_music(song_name: StringName):
	if music_player.playing:
		music_player.stop()
	music_player.stream = MUSIC_DIRECTORY.get_sound(song_name)
	music_player.play()


func pause_sound() -> void:
	music_player.stream_paused = true


func resume_sound() -> void:
	music_player.stream_paused = false
