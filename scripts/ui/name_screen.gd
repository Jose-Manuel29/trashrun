extends Control

@onready var boton_play = $jugar
@onready var boton_regresar = $return
@onready var boton_salir = $salir

@onready var boton_residuos = $BtnResiduos
@onready var boton_psicologia = $BtnPsicologia
@onready var boton_cargar = $BtnCargar

@onready var edit_p1 = $LineEdit
@onready var edit_p2 = $LineEdit2

var categoria_seleccionada = ""

func _ready() -> void:
	boton_residuos.pressed.connect(func(): _seleccionar_modo("Residuos"))
	boton_psicologia.pressed.connect(func(): _seleccionar_modo("Psicología"))
	boton_cargar.pressed.connect(func(): _on_config_pressed())

	boton_residuos.modulate.a = 0.5
	boton_psicologia.modulate.a = 0.5
	boton_cargar.modulate.a = 1.0


func _seleccionar_modo(modo: String) -> void:
	categoria_seleccionada = modo

	if modo == "Residuos":
		boton_residuos.modulate.a = 1.0
		boton_psicologia.modulate.a = 0.5
	elif modo == "Psicología":
		boton_psicologia.modulate.a = 1.0
		boton_residuos.modulate.a = 0.5


func _on_play_pressed() -> void:
	# 1. Validar nombres
	if edit_p1.text.strip_edges() == "" or edit_p2.text.strip_edges() == "":
		print("Por favor, ingresen sus nombres.")
		return

	GameManager.player1_name = edit_p1.text
	GameManager.player2_name = edit_p2.text

	# 2. Si NO hay preguntas cargadas (JSON), usamos las default
	if GameManager.questions.size() == 0:
		print("No hay JSON, cargando preguntas por defecto...")
		
		if categoria_seleccionada == "":
			print("Selecciona una categoría primero.")
			return
			
		QuestionLoader.load_questions(categoria_seleccionada)
	else:
		print("Usando preguntas del JSON")

	# 3. Mezclar preguntas
	GameManager.questions.shuffle()

	print("Total preguntas:", GameManager.questions.size())

	# 4. Ir al juego
	get_tree().change_scene_to_file("res://scenes/ui/QuestionScreen.tscn")


func _on_config_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/SettingsScreen.tscn")

func _on_regresar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/StartScreen.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
