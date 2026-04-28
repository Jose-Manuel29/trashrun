extends Node2D

var questions = [
	{
		"question": "¿Color del cielo?",
		"answers": ["Verde", "Azul", "Rojo", "Amarillo"],
		"correct": 1
	}
]

@onready var question_label = $UI/PreguntasPanel/PreguntaLabel
@onready var buttons = $UI/PreguntasPanel/RespuestasContainer.get_children()

func _ready():
	load_question()

func load_question():
	var q = questions[0]
	question_label.text = q["question"]

	for i in range(buttons.size()):
		buttons[i].text = q["answers"][i]
