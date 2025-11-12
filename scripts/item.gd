extends Area2D

@export var item_key: String = ""
@onready var sprite = $Sprite2D

# встановлення іконки та ключа
func set_item(item_name):
	$Sprite2D.texture=load("res://assets/items/%s.png" % item_name)
	item_key= item_name
	
func _ready() -> void:
	# перевірка, чи вказано ключ
	if item_key:
		set_item(item_key)
	else: 
		set_item("apple")
		printerr("item doesnt have item_key")

# додавання предмета до інвентарю, якщо гравець "зайшов" у предмет
func _on_body_entered(body):
	if body.is_in_group("player"):
		var item_data=Global.get_item_by_key(item_key)
		if item_data:
			var added=Inventory.add_item(item_data)
			if added: queue_free()
		
