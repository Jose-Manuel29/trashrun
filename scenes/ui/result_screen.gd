extends Control

# Usando las rutas de tu árbol de nodos (dentro de TextureRect)
@onready var label_ganador = $TextureRect/LabelGanador 
@onready var label_puntos_j1 = $TextureRect/LabelPuntosJ1
@onready var label_puntos_j2 = $TextureRect/LabelPuntosJ2

@onready var boton_ranking = $TextureRect/Button
@onready var boton_menu = $TextureRect/Button2

func _ready():
	
	boton_ranking.pressed.connect(_on_ranking_pressed)
	boton_menu.pressed.connect(_on_menu_pressed)
	
	# 1. Obtenemos los puntajes directamente del GameManager
	var p1 = GameManager.score_p1
	var p2 = GameManager.score_p2
	
	# 2. La pantalla decide qué mostrar comparando las variables
	if p1 > p2:
		label_ganador.text = "¡GANADOR: " + GameManager.player1_name.to_upper() + "!"
	elif p2 > p1:
		label_ganador.text = "¡GANADOR: " + GameManager.player2_name.to_upper() + "!"
	else:
		label_ganador.text = "¡HA SIDO UN EMPATE!"
	
	# 3. Mostramos los puntos finales
	label_puntos_j1.text = GameManager.player1_name + ": " + str(p1)
	label_puntos_j2.text = GameManager.player2_name + ": " + str(p2)

# --- BOTONES ---

func _on_ranking_pressed():
	GameManager.reset_game()
	# Cambia "NivelPrincipal" por el nombre exacto de tu escena de juego
	get_tree().change_scene_to_file("res://scenes/ui/RankingScreen.tscn")

func _on_menu_pressed():
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/ui/StartScreen.tscn")
