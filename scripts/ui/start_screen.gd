extends Control

# Como el botón está suelto en la raíz, le quitamos el "Contenedor/"
@onready var boton_jugar = $Jugar 
@onready var boton_salir = $salir
func _ready() -> void:
	# Conectamos el botón para cambiar de escena
	boton_jugar.pressed.connect(_on_jugar_pressed)

func _on_jugar_pressed() -> void:
	# Cambia a la escena intermedia de nombres
	get_tree().change_scene_to_file("res://scenes/ui/NameScreen.tscn")

func _on_salir_pressed() -> void:
	# Cierra el juego por completo
	get_tree().quit()
