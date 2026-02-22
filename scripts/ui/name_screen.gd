extends Control

# --- REFERENCIAS A LOS NODOS ---
@onready var boton_play = $jugar
@onready var boton_regresar = $return
@onready var boton_salir = $salir

# Asegúrate de crear estos dos botones en tu escena para las categorías
@onready var boton_residuos = $BtnResiduos
@onready var boton_psicologia = $BtnPsicologia

@onready var edit_p1 = $LineEdit
@onready var edit_p2 = $LineEdit2

# Variable para guardar la elección del jugador antes de darle a Play
var categoria_seleccionada = ""

func _ready() -> void:
	# Conectamos los botones de categoría
	boton_residuos.pressed.connect(func(): _seleccionar_modo("Residuos"))
	boton_psicologia.pressed.connect(func(): _seleccionar_modo("Psicología"))
	
	# Conectamos los botones principales
	boton_play.pressed.connect(_on_play_pressed)
	boton_regresar.pressed.connect(_on_regresar_pressed)
	boton_salir.pressed.connect(_on_salir_pressed)
	
	# Efecto visual: Ponemos los botones de categoría un poco oscuros/transparentes al inicio
	boton_residuos.modulate.a = 0.5
	boton_psicologia.modulate.a = 0.5

# --- LÓGICA DE SELECCIÓN ---
func _seleccionar_modo(modo: String) -> void:
	categoria_seleccionada = modo
	
	# Efecto visual: "Iluminamos" el botón seleccionado y "apagamos" el otro
	if modo == "Residuos":
		boton_residuos.modulate.a = 1.0
		boton_psicologia.modulate.a = 0.5
	elif modo == "Psicología":
		boton_psicologia.modulate.a = 1.0
		boton_residuos.modulate.a = 0.5

# --- FUNCIONES DE LOS BOTONES PRINCIPALES ---
func _on_play_pressed() -> void:
	# 1. Validamos que ambos cuadros de texto tengan algo escrito
	if edit_p1.text.strip_edges() == "" or edit_p2.text.strip_edges() == "":
		print("Por favor, ingresen sus nombres.")
		return # Detiene la función, no hace nada más
		
	# 2. Validamos que hayan tocado algún modo de juego
	if categoria_seleccionada == "":
		print("Por favor, seleccionen un modo de juego.")
		return # Detiene la función
	
	# 3. Si todo está correcto, guardamos en el GameManager
	GameManager.player1_name = edit_p1.text
	GameManager.player2_name = edit_p2.text
	GameManager.category = categoria_seleccionada
	
	# (Opcional) Si tienes una función para resetear puntajes en GameManager, ponla aquí
	# GameManager.reset_game()
	
	# 4. Cambiamos a la escena del juego
	get_tree().change_scene_to_file("res://scenes/ui/QuestionScreen.tscn")

func _on_regresar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/StartScreen.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
