extends GridContainer
class_name ContainerSlot

# завантаження окремої клітинки 
var ItemSlot=load("res://scenes/items_slot.tscn")
var slots

# створює та відображає сітку слотів інвентарю
func display_item_slot(cols: int, rows: int):
	var item_slot
	columns=cols
	slots=cols*rows
	
	# цикл створює задану кількість слотів і додає їх до контейнера
	# кожен слот це екземпляр сцени ItemSlot
	for index in range(slots):
		item_slot=ItemSlot.instantiate()
		add_child(item_slot)
		item_slot.display_item(Inventory.items[index])
	Inventory.items_changed.connect(_on_Inventory_items_changed)

# оновлює вміст слотів при зміні інвентарю
func _on_Inventory_items_changed(indexes):
	var item_slot
	for index in indexes:
		if index<slots:
			item_slot=get_child(index)
			item_slot.display_item(Inventory.items[index])
