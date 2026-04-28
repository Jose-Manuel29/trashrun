# res://test/scripts/ui/question_screen_test.gd
extends GdUnitTestSuite

var runner: GdUnitSceneRunner

func before_test() -> void:
	runner = scene_runner("res://scenes/ui/QuestionScreen.tscn")
	
	await runner.simulate_frames(2)
	
	if GameManager:
		GameManager.score_p1 = 0
		GameManager.score_p2 = 0

func test_finalizar_pregunta_puntos_logica() -> void:
	var screen = runner.scene()
	assert_object(screen).is_not_null()

	screen.pregunta_actual = {
		"correct_index": 0
	}
	screen.respuesta_j1 = 0 
	screen.respuesta_j2 = 1 
	screen.tiempo_j1 = 1.0
	screen.tiempo_j2 = 1.0
	
	await screen.finalizar_pregunta()
	
	assert_int(GameManager.score_p1).is_greater(0)
