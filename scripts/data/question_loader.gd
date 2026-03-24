extends Node

# --- PREGUNTAS POR DEFECTO (CATEGORÍAS) ---
var default_residuos : Array = [
	{
		"question": "¿En qué contenedor se deben depositar las cáscaras de fruta?",
		"options": ["Orgánico", "Inorgánico", "Papel", "Vidrio"],
		"correct_index": 0
	},
	{
		"question": "¿Cuál es el color del contenedor para envases de plástico y latas?",
		"options": ["Verde", "Azul", "Amarillo", "Gris"],
		"correct_index": 2
	},
	{
		"question": "¿Qué residuo tarda más tiempo en degradarse?",
		"options": ["Papel", "Cáscara de naranja", "Botella de vidrio", "Madera"],
		"correct_index": 2
	},
	{
		"question": "¿Qué significa la 'Regla de las 3R'?",
		"options": ["Reutilizar, Reír, Remar", "Reducir, Reutilizar, Reciclar", "Recoger, Revisar, Romper", "Ninguna"],
		"correct_index": 1
	},
	{
		"question": "¿A dónde deben llevarse las pilas y baterías usadas?",
		"options": ["Al bote de basura", "A un centro de acopio especial", "Al drenaje", "Al contenedor amarillo"],
		"correct_index": 1
	},
	{
		"question": "¿Cuál de estos materiales es 100% reciclable infinitas veces?",
		"options": ["Plástico", "Papel", "Vidrio", "Tela"],
		"correct_index": 2
	},
	{
		"question": "¿Qué gas se produce por la descomposición de basura orgánica en rellenos?",
		"options": ["Oxígeno", "Metano", "Helio", "Nitrógeno"],
		"correct_index": 1
	}
]

var default_psicologia : Array = [
	{
		"question": "Serie: 2, 4, 8, 16... ¿Cuál sigue?",
		"options": ["20", "24", "32", "64"],
		"correct_index": 2
	},
	{
		"question": "Si 'Círculo' es a 'Esfera', entonces 'Cuadrado' es a:",
		"options": ["Triángulo", "Cubo", "Línea", "Rectángulo"],
		"correct_index": 1
	},
	{
		"question": "Completa la serie: ↑, →, ↓, ...",
		"options": ["↑", "→", "←", "↙"],
		"correct_index": 2
	},
	{
		"question": "¿Qué palabra no encaja?",
		"options": ["Lápiz", "Bolígrafo", "Pincel", "Cuchara"],
		"correct_index": 3
	},
	{
		"question": "Patrón: A1, B2, C3... ¿Cuál sigue?",
		"options": ["D3", "E5", "D4", "C4"],
		"correct_index": 2
	},
	{
		"question": "Si rotas un cuadrado 90° cuatro veces, ¿en qué posición queda?",
		"options": ["Inversa", "Lateral", "Original", "Diagonal"],
		"correct_index": 2
	},
	{
		"question": "En una matriz 3x3, si la fila aumenta de 2 en 2, ¿qué sigue a 10?",
		"options": ["11", "12", "14", "20"],
		"correct_index": 1
	}
]

var current_questions : Array = []

func load_questions(modo: String) -> void:
	if modo == "Residuos":
		print("Cargando Residuos...")
		current_questions = default_residuos.duplicate()
	elif modo == "Psicología":
		print("Cargando Psicología...")
		current_questions = default_psicologia.duplicate()
	else:
		current_questions = default_residuos.duplicate()
	
	# 🔥 SOLUCIÓN CLAVE
	GameManager.questions = current_questions.duplicate()
	print("Preguntas cargadas:", GameManager.questions.size())
