extends Control

@onready var boton_jugar = $Jugar
@onready var boton_salir = $salir
@onready var boton_config = $Configuracion   # Asegúrate de crear este botón en tu escena


func _ready() -> void:
	boton_jugar.pressed.connect(_on_jugar_pressed)
	boton_salir.pressed.connect(_on_salir_pressed)
	boton_config.pressed.connect(_on_config_pressed)


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/NameScreen.tscn")


func _on_config_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/SettingsScreen.tscn")  # Nos manda a configuración


func _on_salir_pressed() -> void:
	get_tree().quit()
