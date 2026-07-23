extends Control


func update_progress(value: float, text: String = "") -> void:
	$ProgressBar.value = value
	if text:
		$Label.text = text
