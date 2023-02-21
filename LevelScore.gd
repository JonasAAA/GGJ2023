extends Node

class_name LevelScore

var score: int
var max_score: int

func _init(score_: int, max_score_: int) -> void:
	self.score = score_
	self.max_score = max_score_

func _to_string() -> String:
	return "{score} / {max_score}".format(to_dict())

func to_dict() -> Dictionary:
	return {"score": score, "max_score": max_score}
