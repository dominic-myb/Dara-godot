extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerCurrentHP": Game.playerCurrentHP,
		"playerMaxHP": Game.playerMaxHP,
		"playerExp": Game.playerExp,
		"playerMaxExp": Game.playerMaxExp,
		"playerLvl": Game.playerLvl,
		"playerGold": Game.playerGold,
		"lvlToBuff": Game.lvlToBuff
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.playerCurrentHP = current_line["playerCurrentHP"]
				Game.playerMaxHP = current_line["playerMaxHP"]
				Game.playerExp = current_line["playerExp"]
				Game.playerMaxExp = current_line["playerMaxExp"]
				Game.playerLvl = current_line["playerLvl"]
				Game.playerGold = current_line["playerGold"]
				Game.lvlToBuff = current_line["lvlToBuff"]
