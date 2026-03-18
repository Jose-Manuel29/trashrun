extends CanvasLayer

@onready var boton_continuar = $Panel/VBoxContainer/Button
@onready var boton_reiniciar = $Panel/VBoxContainer/Button2
@onready var boton_salir = $Panel/VBoxContainer/Button3

func _ready():
	boton_continuar.pressed.connect(_on_continuar_pressed)
	boton_reiniciar.pressed.connect(_on_reiniciar_pressed)
	boton_salir.pressed.connect(_on_salir_pressed)

func _on_continuar_pressed():
	get_tree().paused = false
	queue_free()

func _on_reiniciar_pressed():
	get_tree().paused = false
	visible = false
	get_tree().reload_current_scene()

func _on_salir_pressed():
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://scenes/ui/StartScreen.tscn")
