extends Node

# змінна підключення бд
var database: SQLite

#
func _ready():
	# створюємо новий об'єкт бази даних та шлях до файлу
	database=SQLite.new()
	database.path="res://items.db"
	
	# відкриваємо бд
	database.open_db()

# отримання всіх предметів із таблиці "items"
func get_items():
	# зберігання предметів
	var items=[]
	
	#перевірка існування файла бази даних
	if(!FileAccess.file_exists("res://items.db")):
		print("DB File doenst exist")
		return items
		
	# SQL-запит щоб вибрати всі записи з таблиці "items"
	database.query("SELECT * FROM items")

	for item in database.query_result:
		items.append(item)
	
	return items
