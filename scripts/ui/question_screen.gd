extends Node2D

# --- UI ---
@onready var texto_pregunta = $CanvasLayer/PanelPregunta/Label
@onready var contenedor_botones = $CanvasLayer/PanelPregunta/GridContainer
@onready var lista_botones = contenedor_botones.get_children()
@onready var boton_pausa = $CanvasLayer/pausa
@onready var label_timer = $CanvasLayer/PanelPregunta/LabelTimer
@onready var barra_tiempo = $CanvasLayer/PanelPregunta/BarraTiempo

# --- Progreso ---
@onready var progreso_j1 = $CanvasLayer/PanelPregunta/ProgresoJ1
@onready var progreso_j2 = $CanvasLayer/PanelPregunta/ProgresoJ2

# --- Puntaje ---
@onready var score_j1_label = $CanvasLayer/PanelPregunta/PuntajeJ1
@onready var score_j2_label = $CanvasLayer/PanelPregunta/PuntajeJ2

# --- Jugadores ---
@onready var jugador1 = $Jugador1
@onready var jugador2 = $Jugador2
@onready var timer_pregunta = $TimerPregunta

var PauseMenuScene = preload("res://scenes/ui/PAUSEMENU.tscn")
var pause_menu = null

# --- Lógica ---
var total_preguntas = 7
var resultados_j1 = []
var resultados_j2 = []
var paso_j1 = 0
var paso_j2 = 0
var pregunta_actual = {}
var tiempo_restante = 10

# --- SISTEMA SIMULTÁNEO ---
var respondio_j1 = false
var respondio_j2 = false

var tiempo_j1 = -1.0
var tiempo_j2 = -1.0

var respuesta_j1 = -1
var respuesta_j2 = -1

# ----------------------------

func _ready():
	GameManager.reset_game()

	for i in range(lista_botones.size()):
		lista_botones[i].pressed.connect(boton_presionado.bind(i))

	barra_tiempo.max_value = 10
	barra_tiempo.value = 10

	crear_barra_visual(progreso_j1)
	crear_barra_visual(progreso_j2)

	actualizar_score()
	cargar_nueva_pregunta()

	boton_pausa.pressed.connect(_on_pausa_pressed)

# ----------------------------

func _process(delta):

	# PLAYER 1
	if not respondio_j1:
		if Input.is_action_just_pressed("p1_a"):
			responder(1, 0)
		elif Input.is_action_just_pressed("p1_b"):
			responder(1, 1)
		elif Input.is_action_just_pressed("p1_c"):
			responder(1, 2)
		elif Input.is_action_just_pressed("p1_d"):
			responder(1, 3)

	# PLAYER 2
	if not respondio_j2:
		if Input.is_action_just_pressed("p2_a"):
			responder(2, 0)
		elif Input.is_action_just_pressed("p2_b"):
			responder(2, 1)
		elif Input.is_action_just_pressed("p2_c"):
			responder(2, 2)
		elif Input.is_action_just_pressed("p2_d"):
			responder(2, 3)

# ----------------------------

func crear_barra_visual(contenedor):
	for n in contenedor.get_children():
		n.queue_free()

	for i in range(total_preguntas):
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(25, 25)
		rect.color = Color.GRAY
		contenedor.add_child(rect)

# ----------------------------

func cargar_nueva_pregunta():
	if GameManager.questions.is_empty():
		game_over("¡Fin de las preguntas!", "Empate")
		return

	pregunta_actual = GameManager.questions.pop_front()

	texto_pregunta.text = pregunta_actual["question"]

	for i in range(lista_botones.size()):
		if i < pregunta_actual["options"].size():
			lista_botones[i].text = pregunta_actual["options"][i]
			lista_botones[i].visible = true
		else:
			lista_botones[i].visible = false

	# RESET
	respondio_j1 = false
	respondio_j2 = false

	tiempo_j1 = -1
	tiempo_j2 = -1

	respuesta_j1 = -1
	respuesta_j2 = -1

	tiempo_restante = 10
	barra_tiempo.value = tiempo_restante
	label_timer.text = str(tiempo_restante) + " Seg"

	timer_pregunta.start()

# ----------------------------

func responder(jugador, indice):

	if jugador == 1:
		respondio_j1 = true
		tiempo_j1 = 10 - tiempo_restante
		respuesta_j1 = indice
	else:
		respondio_j2 = true
		tiempo_j2 = 10 - tiempo_restante
		respuesta_j2 = indice

	# Si ambos responden → termina antes
	if respondio_j1 and respondio_j2:
		finalizar_pregunta()

# ----------------------------

func finalizar_pregunta():
	timer_pregunta.stop()

	var correcta_index = int(pregunta_actual["correct_index"])

	var puntos_j1 = 0
	var puntos_j2 = 0

	var correcta_j1 = respuesta_j1 == correcta_index
	var correcta_j2 = respuesta_j2 == correcta_index

	# PUNTOS
	if correcta_j1:
		puntos_j1 = calcular_puntos(tiempo_j1)

	if correcta_j2:
		puntos_j2 = calcular_puntos(tiempo_j2)

	# EMPATE
	if correcta_j1 and correcta_j2:
		if abs(tiempo_j1 - tiempo_j2) < 0.1:
			puntos_j1 = puntos_j2

	GameManager.score_p1 += puntos_j1
	GameManager.score_p2 += puntos_j2

	actualizar_score()

	# PROGRESO
	actualizar_progreso(1, correcta_j1)
	actualizar_progreso(2, correcta_j2)

	# 🔥 MOVIMIENTO
	await get_tree().create_timer(0.5).timeout

	if not correcta_j1:
		bajar_jugador(1)

	if not correcta_j2:
		bajar_jugador(2)

	await get_tree().create_timer(0.8).timeout
	cargar_nueva_pregunta()

# ----------------------------

func calcular_puntos(tiempo):
	return int((10 - tiempo) * 100)

# ----------------------------

func actualizar_progreso(jugador, correcta):
	var contenedor = progreso_j1 if jugador == 1 else progreso_j2
	var resultados = resultados_j1 if jugador == 1 else resultados_j2

	resultados.append(correcta)
	var indice = resultados.size() - 1

	if indice < contenedor.get_child_count():
		var rect = contenedor.get_child(indice)
		rect.color = Color.GREEN if correcta else Color.RED

# ----------------------------

func bajar_jugador(num):
	var tween = create_tween()

	if num == 1:
		paso_j1 += 1
		var nodo = "PosicionJ2_" + str(paso_j1)
		if has_node(nodo):
			tween.tween_property(jugador1, "global_position", get_node(nodo).global_position, 0.5)
		else:
			game_over("Eliminado " + GameManager.player1_name, GameManager.player2_name)

	else:
		paso_j2 += 1
		var nodo = "PosicionJ1_" + str(paso_j2)
		if has_node(nodo):
			tween.tween_property(jugador2, "global_position", get_node(nodo).global_position, 0.5)
		else:
			game_over("Eliminado " + GameManager.player2_name, GameManager.player1_name)

# ----------------------------

func actualizar_score():
	score_j1_label.text = GameManager.player1_name + ": " + str(GameManager.score_p1)
	score_j2_label.text = GameManager.player2_name + ": " + str(GameManager.score_p2)

# ----------------------------

func game_over(mensaje, ganador):
	texto_pregunta.text = mensaje
	contenedor_botones.visible = false
	timer_pregunta.stop()

	RankingManager.add_score(GameManager.player1_name, GameManager.score_p1)
	RankingManager.add_score(GameManager.player2_name, GameManager.score_p2)

	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/ui/RankingScreen.tscn")

# ----------------------------

func _on_timer_pregunta_timeout():
	tiempo_restante -= 1
	barra_tiempo.value = tiempo_restante
	label_timer.text = str(tiempo_restante) + " Seg"

	if tiempo_restante <= 0:
		timer_pregunta.stop()
		finalizar_pregunta()

# ----------------------------

func _on_pausa_pressed():
	get_tree().paused = true
	pause_menu = PauseMenuScene.instantiate()
	get_tree().root.add_child(pause_menu)

# ----------------------------

func boton_presionado(indice):
	pass
