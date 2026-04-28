# res://test/scenes/ui/settings_screen_test.gd
extends GdUnitTestSuite

const __source: String = 'res://scenes/ui/settings_screen.gd'
var _scene: Control

func before_test() -> void:
	var script = load(__source)
	_scene = Control.new()
	_scene.set_script(script)
	
	# Creamos los nodos necesarios para que el script no falle
	var label = Label.new()
	label.name = "LabelEstado"
	
	var vbox = VBoxContainer.new()
	vbox.name = "VBoxContainer"
	vbox.add_child(label)
	
	_scene.add_child(vbox)
	_scene.lbl_estado = label # Referencia directa al nodo
	
	add_child(_scene)

# --- CASO 1: CARGA EXITOSA (YA LO TIENES) ---
func test_carga_exitosa_json() -> void:
	var temp_path = "user://test_ok.json"
	var file = FileAccess.open(temp_path, FileAccess.WRITE)
	file.store_string('[{"question":"?","options":["A"],"correct_index":0}]')
	file.close()
	
	_scene._on_file_selected(temp_path)
	assert_str(_scene.lbl_estado.text).is_equal("¡Preguntas cargadas con éxito!")

# --- CASO 2: ESCENARIO DE FRACASO (FORMATO INCORRECTO) ---
func test_archivo_formato_incorrecto() -> void:
	# Simulamos un JSON que existe pero no tiene la estructura de TrashRun [cite: 4]
	var temp_path = "user://test_error.json"
	var file = FileAccess.open(temp_path, FileAccess.WRITE)
	file.store_string('[{"data": "incorrecta"}]') 
	file.close()
	
	_scene._on_file_selected(temp_path)
	
	# Resultado esperado según tu doc: Mensaje de error de formato [cite: 4]
	assert_str(_scene.lbl_estado.text).is_equal("Formato incorrecto: faltan campos.")

# --- CASO 3: ESCENARIO DE NO TENER NADA (VACÍO) ---
func test_json_invalido_o_vacio() -> void:
	# Simulamos un archivo que está vacío o es un JSON inválido [cite: 5, 6]
	var temp_path = "user://test_vacio.json"
	var file = FileAccess.open(temp_path, FileAccess.WRITE)
	file.store_string('[]') 
	file.close()
	
	_scene._on_file_selected(temp_path)
	
	# Resultado esperado: Mensaje de error de vacío [cite: 6]
	assert_str(_scene.lbl_estado.text).is_equal("JSON inválido o vacío.")
