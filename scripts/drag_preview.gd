extends Control

@onready var item_icon = $Item/ItemIcon
@onready var item_quantity = $Item/LabelQuantity

#  зберігання інформації про предмет який зараз перетягується
var dragged_item = {} : set = set_dragged_item

# переміщаємо вузел за мишею якщо предмет не пуст
func _process(delta):
	if dragged_item:
		position = get_global_mouse_position()

# оновлює іконку предмета та текст кількості
func set_dragged_item(item):
	dragged_item = item
	if dragged_item:
		item_icon.texture = load("%s" % dragged_item.icon)
		item_quantity.text = str(dragged_item.quantity) if dragged_item.stackable else ""
	else:
		item_icon.texture = null
		item_quantity.text = ""
