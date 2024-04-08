extends Node

var playerCurrentHP = 0
var playerMaxHP = 10
var playerExp = 0
var playerMaxExp = 100
var playerLvl = 1
var playerGold = 0
var lvlToBuff = 5
var playerDamage = 2 

#for weak mobs
var enemyHP = 0
var enemyMaxHP = 10
var enemyDamage = 2
var enemyLvl = 1
var enemySpeed = 150.0

func _ready():
	playerCurrentHP = playerMaxHP
	enemyHP = enemyMaxHP
func _process(_delta):
	if playerExp >= playerMaxExp:
		#leftover exps will be counted
		playerExp = playerExp - playerMaxExp
		playerLvl += 1
		playerDamage += 1
		enemyDamage += 1
		playerMaxExp += 100
		print("Exp: ", Game.playerExp)
		print("Lvl: ", Game.playerLvl)
		print("MaxExp: ", Game.playerMaxExp)
		#Utils.saveGame()
		#get_tree().change_scene_to_file("res://src/scenes/world_earth.tscn")
	if playerLvl >= lvlToBuff:
		#every 5 levels buffs the perma health + heals
		#full health before adding max health for game difficulty
		playerCurrentHP = playerMaxHP
		playerMaxHP += 10
		lvlToBuff += 5
		enemyMaxHP += 10
		enemyHP = enemyMaxHP
