extends Node2D

# --- UI ---
@onready var texto_pregunta = $CanvasLayer/PanelPregunta/Label
@onready var contenedor_botones = $CanvasLayer/PanelPregunta/GridContainer
@onready var lista_botones = contenedor_botones.get_children()
@onready var label_turno = $CanvasLayer/PanelPregunta/LabelTurno
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
var turno_actual = 1
var tiempo_restante = 10

func _ready():
	GameManager.reset_game()

	print("Preguntas recibidas:", GameManager.questions.size())

	# Conectar botones
	for i in range(lista_botones.size()):
		lista_botones[i].pressed.connect(boton_presionado.bind(i))

	barra_tiempo.max_value = 10
	barra_tiempo.value = 10

	crear_barra_visual(progreso_j1)
	crear_barra_visual(progreso_j2)

	actualizar_interfaz_turno()
	actualizar_score()
	cargar_nueva_pregunta()

	boton_pausa.pressed.connect(_on_pausa_pressed)

func crear_barra_visual(contenedor):
	for n in contenedor.get_children():
		n.queue_free()

	for i in range(total_preguntas):
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(25, 25)
		rect.color = Color.GRAY
		contenedor.add_child(rect)

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

	tiempo_restante = 10
	barra_tiempo.value = tiempo_restante
	label_timer.text = str(tiempo_restante) + " Seg"

	timer_pregunta.start()

func boton_presionado(indice):
	timer_pregunta.stop()

	var correcta = indice == int(pregunta_actual["correct_index"])

	if correcta:
		var puntos = int((tiempo_restante / 10.0) * 1000)
		if turno_actual == 1:
			GameManager.score_p1 += puntos
		else:
			GameManager.score_p2 += puntos
		actualizar_score()

	actualizar_progreso(turno_actual, correcta)

	await get_tree().create_timer(0.5).timeout

	if not correcta:
		bajar_jugador(turno_actual)

	cambiar_turno()
	cargar_nueva_pregunta()

func cambiar_turno():
	turno_actual = 2 if turno_actual == 1 else 1
	actualizar_interfaz_turno()

func actualizar_interfaz_turno():
	if turno_actual == 1:
		label_turno.text = "TURNO: " + GameManager.player1_name.to_upper()
	else:
		label_turno.text = "TURNO: " + GameManager.player2_name.to_upper()

func actualizar_progreso(jugador, correcta):
	var contenedor = progreso_j1 if jugador == 1 else progreso_j2
	var resultados = resultados_j1 if jugador == 1 else resultados_j2

	resultados.append(correcta)
	var indice = resultados.size() - 1

	if indice < contenedor.get_child_count():
		var rect = contenedor.get_child(indice)
		rect.color = Color.GREEN if correcta else Color.RED

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

func actualizar_score():
	score_j1_label.text = GameManager.player1_name + ": " + str(GameManager.score_p1)
	score_j2_label.text = GameManager.player2_name + ": " + str(GameManager.score_p2)

func game_over(mensaje, ganador):
	texto_pregunta.text = mensaje
	contenedor_botones.visible = false
	timer_pregunta.stop()

	# 🔥 GUARDAR PUNTAJES (LOS DOS DENTRO)
	RankingManager.add_score(GameManager.player1_name, GameManager.score_p1)
	RankingManager.add_score(GameManager.player2_name, GameManager.score_p2)

	await get_tree().create_timer(3.0).timeout
	
	get_tree().change_scene_to_file("res://scenes/ui/RankingScreen.tscn")
func _on_timer_pregunta_timeout():
	tiempo_restante -= 1
	barra_tiempo.value = tiempo_restante
	label_timer.text = str(tiempo_restante) + " Seg"

	if tiempo_restante <= 0:
		timer_pregunta.stop()
		actualizar_progreso(turno_actual, false)
		bajar_jugador(turno_actual)
		cambiar_turno()
		cargar_nueva_pregunta()

func _on_pausa_pressed():
	get_tree().paused = true
	pause_menu = PauseMenuScene.instantiate()
	get_tree().root.add_child(pause_menu)
