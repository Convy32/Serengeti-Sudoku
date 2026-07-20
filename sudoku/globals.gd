extends Node



var all_boxes_complete = false
var all_rows_complete = false
var all_columns_complete = false
var puzzle_complete = false

var difficulty = "easy"

var debug = true

var fastest_time = 0
var time = 0

var highscore = 0
var score = 0

var wins = {
	"easy": 0,
	"medium": 0,
	"hard": 0,
	"hardcore": 0,
}
