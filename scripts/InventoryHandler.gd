extends Control

@onready var drag_preview = $InventoryContainer/DragPreview
@onready var tooltip = $InventoryContainer/InventoryTooltip

# змінює видимість інвентарю
func _unhandled_input(event):
	if event.is_action_pressed("ui_inventory"):
	# Інвентар не можна закрити поки предмет узят
		if visible && drag_preview.dragged_item: return
		visible = !visible
		hide_tooltip()
		
func _ready():
	drag_preview.visible = false
	
	for item_slot in get_tree().get_nodes_in_group("items_slot"):
		var index= item_slot.get_index()
		item_slot.connect("gui_input", _on_ItemSlot_gui_input.bind(index))
		item_slot.connect("mouse_entered", show_tooltip.bind(index))
		item_slot.connect("mouse_exited", hide_tooltip)
	
func _process(delta):
	if drag_preview.visible:
		drag_preview.position = get_global_mouse_position()
# підсказка відображається тільки тоді коли 
# предмет є  у слоті та не перетягується
func show_tooltip(index):
	var inventory_item = Inventory.items[index]
	
	# Показуємо підказку якщо:
	# у слоті є предмет ("inventory_item.has("key")")
	# не тягнемо інший предмет ("!drag_preview.dragged_item")
	if inventory_item.has("key") && !drag_preview.dragged_item:
		tooltip.display_info(inventory_item)
		tooltip.visible = true
	else:
		tooltip.visible = false

func hide_tooltip():
	tooltip.visible = false

# ГОЛОВНИЙ ОБРОБНИК КЛІКІВ
func _on_ItemSlot_gui_input(event, index):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			hide_tooltip()
			drag_item(index)
		if event.button_index== MOUSE_BUTTON_RIGHT && event.pressed:
			hide_tooltip()
			split_item(index)
		if event.button_index== MOUSE_BUTTON_MIDDLE && event.pressed:
			if Inventory.items[index].has("key"):
				hide_tooltip()
				Inventory.remove_item(index) 
			
func drag_item(index):
	var inventory_item = Inventory.items[index]
	var dragged_item = drag_preview.dragged_item
	
	# Взяти предмет
	if inventory_item && !dragged_item:
		drag_preview.dragged_item = Inventory.remove_item(index)
		drag_preview.get_node("Item/ItemIcon").texture = load(drag_preview.dragged_item["icon"])
		drag_preview.visible = true
		
	# Кинути предмет
	if !inventory_item && dragged_item:
		drag_preview.dragged_item = Inventory.set_item(index, dragged_item)
		drag_preview.visible = false
		
	# Складання у стопку
	if inventory_item && dragged_item:
		if inventory_item["key"] == dragged_item["key"] && inventory_item["stackable"]:
			Inventory.set_item_quantity(index, dragged_item["quantity"])
			drag_preview.dragged_item={}
			drag_preview.visible = false
		# Свайп предмета
		else:
			drag_preview.dragged_item = Inventory.set_item(index, dragged_item)
			drag_preview.get_node("Item/ItemIcon").texture = load(drag_preview.dragged_item["icon"])

# функція розділення предметів
func split_item(index):
	# отримання індекса предмета в інветарі
	var inventory_item=Inventory.items[index]
	# отримання предмета який перетягується
	var dragged_item=drag_preview.dragged_item
	var split_amount
	var item
	
	if !inventory_item || !inventory_item["stackable"]: return
	if inventory_item["quantity"]<=1: return
		
	split_amount=ceil(inventory_item["quantity"]/2)
	
	# додаємо предмет до вже існуючого
	if dragged_item && inventory_item["key"] == dragged_item["key"]:
		drag_preview.dragged_item["quantity"] += split_amount
		Inventory.set_item_quantity(index, -split_amount)
	# якщо перетяг предмета немає, додамо предмет тогож типу
	# і замінимо його кількість
	if !dragged_item:
		item = inventory_item.duplicate()
		item["quantity"] = split_amount
		drag_preview.dragged_item = item
		Inventory.set_item_quantity(index, -split_amount)
		drag_preview.get_node("Item/ItemIcon").texture = load(drag_preview.dragged_item["icon"])
		drag_preview.visible = true
