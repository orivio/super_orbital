extends Node

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	music_player.autoplay = true
	music_player.stream = load("res://music/1_lone_traveler.ogg")
	music_player.play()

func stop_sound():
	music_player.stop()

func change_music(path: String):
	music_player.stop()
	music_player.stream = load(path)
	music_player.play()
