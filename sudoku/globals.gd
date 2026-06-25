extends Node

var all_boxes_complete = false
var all_rows_complete = false
var all_columns_complete = false
var puzzle_complete = false

var difficulty = "easy"

var health = 3

var debug = true

var score = 0
var time = 0

var wins = {
	"easy": 0,
	"medium": 0,
}
var easy_wins = 0
var medium_wins = 0
var hard_wins = 0
var harcore_wins = 0
