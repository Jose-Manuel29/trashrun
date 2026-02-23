extends Node2D

@onready var texto_pregunta = $CanvasLayer/PanelPregunta/Label
@onready var contenedor_botones = $CanvasLayer/PanelPregunta/GridContainer
@onready var lista_botones = contenedor_botones.get_children()
@onready var label_turno = $CanvasLayer/PanelPregunta/LabelTurno 
#boton pause prueba
@onready var boton_salir = $pause
#timer
@onready var timer_pregunta = $TimerPregunta
@onready var label_timer = $CanvasLayer/PanelPregunta/LabelTimer
#Progreso
@onready var progreso_j1 = $CanvasLayer/PanelPregunta/ProgresoJ1
@onready var progreso_j2 = $CanvasLayer/PanelPregunta/ProgresoJ2

@onready var barra_tiempo = $CanvasLayer/PanelPregunta/BarraTiempo

#Puntaje
@onready var score_j1_label = $CanvasLayer/PanelPregunta/PuntajeJ1
@onready var score_j2_label = $CanvasLayer/PanelPregunta/PuntajeJ2

@onready var jugador1 = $Jugador1
@onready var jugador2 = $Jugador2

#Inicializar
var player1_name = ""
var player2_name = ""
var category = ""
var ultimo_ganador = ""

#Progreso
var total_preguntas = 5   # o el número real
var resultados_j1 = []
var resultados_j2 = []


var paso_j1 = 0
var paso_j2 = 0
var pregunta_actual = {}
var turno_actual = 1 
var tiempo_restante = 10

# Base de datos con las categorías "Residuos" y "Psicología"
var base_datos_preguntas = [
	{"texto": "¿Dónde va el plástico?", "respuestas": ["Orgánico", "Inorgánico", "Papel", "Vidrio"], "correcta": 1, "cat": "Residuos"},
	{"texto": "¿Qué color de bote es para papel?", "respuestas": ["Azul", "Verde", "Rojo", "Gris"], "correcta": 0, "cat": "Residuos"},
	{"texto": "¿Qué es la empatía?", "respuestas": ["Enojo", "Ignorar", "Comprender al otro", "Gritar"], "correcta": 2, "cat": "Psicología"},
	{"texto": "¿Cuál es una emoción básica?", "respuestas": ["Caminar", "Tristeza", "Pensar", "Dormir"], "correcta": 1, "cat": "Psicología"}
]

func _ready():
	var indice = 0
	for boton in lista_botones:
		if not boton.is_connected("pressed", boton_presionado):
			boton.pressed.connect(boton_presionado.bind(indice))
		indice += 1
	
	barra_tiempo.max_value = 10
	barra_tiempo.value = 10
	actualizar_interfaz_turno()
	cargar_nueva_pregunta()
	crear_barra_visual(progreso_j1)
	crear_barra_visual(progreso_j2)
	actualizar_score()

func crear_barra_visual(contenedor):
	for i in range(total_preguntas):
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(25, 25)
		rect.color = Color.GRAY  # pendiente
		contenedor.add_child(rect)
		
func actualizar_progreso(jugador, correcta):

	var contenedor
	var resultados
	
	if jugador == 1:
		contenedor = progreso_j1
		resultados = resultados_j1
	else:
		contenedor = progreso_j2
		resultados = resultados_j2

	resultados.append(correcta)

	var indice = resultados.size() - 1
	var rect = contenedor.get_child(indice)

	if correcta:
		rect.color = Color.GREEN
	else:
		rect.color = Color.RED
		
func actualizar_interfaz_turno(): 
	if turno_actual == 1: 
		label_turno.text = "TURNO: " + GameManager.player1_name.to_upper() 
		label_turno.modulate = Color(0, 1, 0) 
	else: 
		label_turno.text = "TURNO: " + GameManager.player2_name.to_upper() 
		label_turno.modulate = Color(1, 0, 0)

func cargar_nueva_pregunta():
	var preguntas_filtradas = []
	for p in base_datos_preguntas:
		if p["cat"] == GameManager.category or GameManager.category == "":
			preguntas_filtradas.append(p)
	
	if preguntas_filtradas.size() == 0:
		preguntas_filtradas = base_datos_preguntas
	
	pregunta_actual = preguntas_filtradas.pick_random()
	texto_pregunta.text = pregunta_actual["texto"]
	
	for i in range(lista_botones.size()):
		lista_botones[i].text = pregunta_actual["respuestas"][i]
	
	# Reiniciar timer
	tiempo_restante = 10
	barra_tiempo.value = tiempo_restante
	label_timer.text = str(tiempo_restante) + " Seg"

	timer_pregunta.start()

func boton_presionado(indice_boton):

	timer_pregunta.stop()

	var correcta = (indice_boton == pregunta_actual["correcta"])

	if correcta:
		var tiempo_maximo = 10
		var puntos = int((tiempo_restante / tiempo_maximo) * 1000)

		if turno_actual == 1:
			GameManager.score_p1 += puntos
		else:
			GameManager.score_p2 += puntos

		actualizar_score()  # 🔥 actualizar INMEDIATO

	actualizar_progreso(turno_actual, correcta)

	# 👇 Pequeño delay visual para que se vea el cambio
	await get_tree().create_timer(0.5).timeout

	if correcta:
		cambiar_turno()
	else:
		bajar_jugador(turno_actual)
		cambiar_turno()

	cargar_nueva_pregunta()

func cambiar_turno():
	turno_actual = 2 if turno_actual == 1 else 1
	actualizar_interfaz_turno()


func bajar_jugador(numero_jugador):
	var tween = create_tween()
	if numero_jugador == 1:
		paso_j1 += 1
		var nombre_marcador = "PosicionJ2_" + str(paso_j1)
		if has_node(nombre_marcador):
			var destino = get_node(nombre_marcador).global_position
			tween.tween_property(jugador1, "global_position", destino, 0.5).set_trans(Tween.TRANS_BOUNCE)
		else:
			# Pasamos el nombre del ganador a la función game_over
			game_over("¡GANÓ " + GameManager.player2_name.to_upper() + "!", GameManager.player2_name)
	elif numero_jugador == 2:
		paso_j2 += 1
		var nombre_marcador = "PosicionJ1_" + str(paso_j2)
		if has_node(nombre_marcador):
			var destino = get_node(nombre_marcador).global_position
			tween.tween_property(jugador2, "global_position", destino, 0.5).set_trans(Tween.TRANS_BOUNCE)
		else:
			# Pasamos el nombre del ganador a la función game_over
			game_over("¡GANÓ " + GameManager.player1_name.to_upper() + "!", GameManager.player1_name)

# --- PREPARANDO PARA EL RANKING ---
func game_over(mensaje, ganador_nombre):
	texto_pregunta.text = mensaje
	contenedor_botones.visible = false
	
	# Guardamos al ganador en el GameManager para leerlo en la futura pantalla de Rankings
	GameManager.ultimo_ganador = ganador_nombre 
	
	await get_tree().create_timer(3.0).timeout
	
	# Por ahora regresa al StartScreen. Cuando hagas tu RankingScreen, cambiaremos esta ruta.
	get_tree().change_scene_to_file("res://scenes/ui/StartScreen.tscn")
	
	


func _on_timer_pregunta_timeout():
	tiempo_restante -= 1
	barra_tiempo.value = tiempo_restante
	label_timer.text = str(tiempo_restante) + " Seg"

	# Cambiar color cuando quede poco
	if tiempo_restante <= 3:
		barra_tiempo.modulate = Color(1, 0.3, 0.3)  # rojo
	
	if tiempo_restante <= 0:
		timer_pregunta.stop()
		actualizar_progreso(turno_actual, false)
		bajar_jugador(turno_actual)
		cambiar_turno()
		cargar_nueva_pregunta()

func actualizar_score():
	score_j1_label.text =  GameManager.player1_name + ": " + str(GameManager.score_p1) + " Puntos"
	score_j2_label.text = GameManager.player2_name + ": " + str(GameManager.score_p2) + " Puntos"
	
	
