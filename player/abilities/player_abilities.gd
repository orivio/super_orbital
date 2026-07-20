class_name PlayerAbilities extends Resource

@export var abilities: Dictionary = {
	"move": false,
	"jump": false,
	"dash": false,
	"gravity_switch": false,
	"throw_wrench": false
}

func unlock(ability: String) -> void:
	abilities[ability] = true

func lock(ability: String) -> void:
	abilities[ability] = false

func unlocked(ability: String) -> bool:
	return abilities[ability]

func get_json() -> Dictionary:
	return abilities

static func from_json(json: Dictionary) -> PlayerAbilities:
	var abilities_resource: PlayerAbilities = PlayerAbilities.new()
	abilities_resource.abilities = json
	return abilities_resource
