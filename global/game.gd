extends Node

var playerCurrentHP = 0
var playerMaxHP = 10
var playerExp = 0.0
var playerMaxExp = 100.0
var playerLvl = 1
var playerGold = 0
var lvlToBuff = 5

func _ready():
	playerCurrentHP = playerMaxHP
func _process(_delta):
	if playerExp >= playerMaxExp:
		#leftover exps will be counted
		playerExp = playerExp - playerMaxExp
		playerLvl += 1
		playerMaxExp += 100
		print("Exp: ", Game.playerExp)
		print("Lvl: ", Game.playerLvl)
		print("MaxExp: ", Game.playerMaxExp)
	if playerLvl >= lvlToBuff:
		#every 5 levels buffs the perma health + heals
		#full health before adding max health for game difficulty
		playerCurrentHP = playerMaxHP
		playerMaxHP += 10
		lvlToBuff += 5
