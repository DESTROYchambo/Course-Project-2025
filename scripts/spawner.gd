extends Node2D

const Item = preload("res://scenes/item.tscn")


@export var spawnable_items: Array[String] = ["apple", "sword", "key", "letter"]
@export var num_items_to_spawn: int = 12 


# межі спавну 
@export var min_x: int = 550
@export var max_x: int = 1000
@export var min_y: int = 250
@export var max_y: int = 550

func _ready() -> void:
	randomize() 
	spawn_items()

# створення предметів
func spawn_items():
	for i in range(num_items_to_spawn):
		var random_item_key = spawnable_items.pick_random() 

		# генеруємо випадкову позицію
		var random_x = randf_range(min_x, max_x)
		var random_y = randf_range(min_y, max_y)
		var spawn_position = Vector2(random_x, random_y)

		# створення предмету
		var item_instance = Item.instantiate()
		
		# встановлюємо ключ новому об'єкту та його розташування
		item_instance.item_key = random_item_key
		item_instance.position = spawn_position

		add_child.call_deferred(item_instance)
