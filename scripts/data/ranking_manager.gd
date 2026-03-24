extends Node

const SAVE_PATH = "user://ranking.json"
var top_scores : Array = []

func _ready():
	load_ranking()

# Esta función la llamaremos cuando termine una partida
func add_score(player_name: String, score: int):
	# Agregamos al jugador
	top_scores.append({"name": player_name, "score": score})
	
	# Ordenamos la lista de mayor a menor puntuación
	top_scores.sort_custom(func(a, b): return a["score"] > b["score"])
	
	# Como tu diseño tiene 6 lugares, cortamos la lista a los 6 mejores
	if top_scores.size() > 6:
		top_scores.resize(6)
		
	# Guardamos en la PC
	save_ranking()

func save_ranking():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	# Guardamos los datos en formato JSON para que persistan
	file.store_string(JSON.stringify(top_scores, "\t"))
	file.close()

func load_ranking():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		if json.parse(json_string) == OK:
			top_scores = json.get_data()
