extends Node2D

@onready var texto_pregunta = $CanvasLayer/PanelPregunta/Label
@onready var contenedor_botones = $CanvasLayer/PanelPregunta/GridContainer
@onready var lista_botones = contenedor_botones.get_children()
@onready var label_turno = $CanvasLayer/PanelPregunta/LabelTurno 
#boton pause prueba
@onready var boton_salir = $pause

@onready var jugador1 = $Jugador1
@onready var jugador2 = $Jugador2

var paso_j1 = 0
var paso_j2 = 0
var pregunta_actual = {}
var turno_actual = 1 

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
	
	actualizar_interfaz_turno()
	cargar_nueva_pregunta()

func actualizar_interfaz_turno():
	if turno_actual == 1:
		label_turno.text = "TURNO: " + GameManager.player1_name.to_upper()
		label_turno.modulate = Color(0, 1, 0)
	else:
		label_turno.text = "TURNO: " + GameManager.player2_name.to_upper()
		label_turno.modulate = Color(1, 0, 0)

func cargar_nueva_pregunta():
	var preguntas_filtradas = []
	# Filtramos según lo que se eligió en la pantalla de nombres
	for p in base_datos_preguntas:
		if p["cat"] == GameManager.category or GameManager.category == "":
			preguntas_filtradas.append(p)
	
	if preguntas_filtradas.size() == 0: preguntas_filtradas = base_datos_preguntas
	
	pregunta_actual = preguntas_filtradas.pick_random()
	texto_pregunta.text = pregunta_actual["texto"]
	for i in range(lista_botones.size()):
		lista_botones[i].text = pregunta_actual["respuestas"][i]

func boton_presionado(indice_boton):
	if indice_boton == pregunta_actual["correcta"]:
		cambiar_turno()
		cargar_nueva_pregunta()
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
	
	
