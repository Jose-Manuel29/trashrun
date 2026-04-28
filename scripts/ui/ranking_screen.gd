extends Control

# Referencias a tus 6 textos
@onready var top1 = $TextureRect/Nombre1
@onready var top2 = $TextureRect/Nombre2
@onready var top3 = $TextureRect/Nombre3
@onready var top4 = $TextureRect/Nombre4
@onready var top5 = $TextureRect/Nombre5
@onready var top6 = $TextureRect/Nombre6

# Referencia a tu botón de salir (Según tu árbol de nodos se llama TextureButton)
@onready var boton_salir = $TextureRect/Button

func _ready():
	mostrar_ranking()

func mostrar_ranking():
	# Metemos tus nodos en una lista para recorrerlos fácil
	var lista = [top1, top2, top3, top4, top5, top6]

	# Recorremos los 6 lugares
	for i in range(lista.size()):
		if i < RankingManager.top_scores.size():
			var data = RankingManager.top_scores[i]
			# Le damos un formato bonito: "1. Juan - 1500 pts"
			lista[i].text = str(i + 1) + ". " + data["name"] + " - " + str(data["score"]) + " pts"
		else:
			lista[i].text = str(i + 1) + ". ---"

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/StartScreen.tscn")
