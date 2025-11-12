extends Node2D

# сигнал для UI інвентаря, передає масив інлдексов 
# покахує яка комірка змінилася
signal items_changed(indexes)

# розмір інвентаря
var cols: int = 5
var rows: int = 5
var slots: int = cols * rows
var items: Array=[]

func _ready():
	# заповнює масив порожніми комірками
	for i in range(slots):
		items.append({})
	
	
# додаємо предмет в індекс комірки
# повертає предмет який лежав у цій комірці
func set_item(index,item):
	var previous_item= items[index]
	items[index]=item
	items_changed.emit([index])
	return previous_item

# додає предмет у перший вільний слот та складає його
func add_item(item_data):
	
	 # Предмет  складено
	if item_data["stackable"]:
		for i in range(items.size()):
			var slot_item=items[i]
			if slot_item.has("key") and slot_item["key"] == item_data["key"]:
				set_item_quantity(i, item_data["quantity"])
				return true
				
	# Предмет додано у новий слот
	for i in range(items.size()):
		var slot_item=items[i]
		if !slot_item.has("key"):
			set_item(i, item_data)
			return true 
	print("Inventory full")
	return false
			
# видаляє предмет з вказаної комірки
# повертає предмет який лежав у цій комірці
func remove_item(index):
	var previous_item = items[index].duplicate()
	items[index].clear()
	items_changed.emit([index])
	return previous_item

# зміни кількості предмета у слоті
func set_item_quantity(index, amount):
	items[index].quantity += amount
	if items[index].quantity <= 0:
		remove_item(index)
	else:
		items_changed.emit([index])
