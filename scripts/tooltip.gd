extends ColorRect

@onready var name_label= $MarginContainer/NameLabel
@onready var description_label = $MarginContainer/DescriptionLabel

# позиція підсказки оновлюється постійно
func _process(delta):
	global_position= get_global_mouse_position() + Vector2(15,15)

# передаємо предмет, де будемо відображати інформацію про предмет
func display_info(item):
	name_label.text=item["name"]
	description_label.text=item["description"]
