# глобальний скрипт
extends Node2D
var items

func _ready():
	open_db()

# відкриття та завантаження даних з бази даних
func open_db():
	items=DatabaseHandler.get_items()
	print("loaded %s items from db" % items.size())
	
# пошук одного конкретного предмета за його унікальним "ключем"
func get_item_by_key(key):
	for item in items:
		# чи є у предмета поле "key"
		# чи збігається його "key" з тим, що ми шукаємо
		if item.has("key") && item["key"] == key:
			return item.duplicate(true)
	print("Item with key %s doenst exist" % key)
	return null
