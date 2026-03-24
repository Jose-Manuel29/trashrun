extends Control

@onready var btn_cargar = $VBoxContainer/BtnCargarJSON
@onready var lbl_estado = $VBoxContainer/LabelEstado
@onready var btn_regresar = $HBoxContainer/BtnRegresar
@onready var btn_salir = $HBoxContainer/BtnSalir
@onready var file_dialog = $FileDialogJSON

func _ready() -> void:
	# Conectamos las señales de los botones
	btn_cargar.pressed.connect(_on_cargar_pressed)
	btn_regresar.pressed.connect(_on_regresar_pressed)
	btn_salir.pressed.connect(_on_salir_pressed)
	
	# Conectamos la señal del FileDialog cuando el usuario elige un archivo
	file_dialog.file_selected.connect(_on_file_selected)
	
	# Configuramos el FileDialog para que solo busque archivos .json en la PC
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.clear_filters()
	file_dialog.add_filter("*.json", "Archivos JSON")

func _on_cargar_pressed() -> void:
	# Abre la ventana del explorador de archivos en el centro
	file_dialog.popup_centered(Vector2(600, 400))

func _on_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	
	if file:
		var content = file.get_as_text()
		var json_data = JSON.parse_string(content)
		
		# 🔥 VALIDACIÓN REAL
		if typeof(json_data) == TYPE_ARRAY and json_data.size() > 0:
			
			# Validamos estructura de la primera pregunta
			if json_data[0].has("question") and json_data[0].has("options") and json_data[0].has("correct_index"):
				
				GameManager.questions = json_data
				lbl_estado.text = "¡Preguntas cargadas con éxito!"
				lbl_estado.modulate = Color(0, 1, 0)
				
			else:
				lbl_estado.text = "Formato incorrecto: faltan campos."
				lbl_estado.modulate = Color(1, 0, 0)
		else:
			lbl_estado.text = "JSON inválido o vacío."
			lbl_estado.modulate = Color(1, 0, 0)
	else:
		lbl_estado.text = "Error al abrir archivo."

func _on_regresar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/StartScreen.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
