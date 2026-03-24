extends Node

var player1_name := ""
var player2_name := ""
var category := ""

var tiempo_maximo = 10
var score_p1 := 0
var score_p2 := 0

var current_question_index := 0
var questions := []

# --- RESET DE LA PARTIDA ---
func reset_game():
	score_p1 = 0
	score_p2 = 0
	current_question_index = 0
