extends Node


enum Crimes {
	MURDER,
	THEFT,
	TRESPASSING
}

enum Likes {
	DOGS,
	CATS,
	FOOD,
	RUNNING,
	TEA,
	READING
}

enum Dislikes {
	BEES,
	PRISON,
	COPS,
	CHILLI,
	COFFEE,
	FISH
}

func random_enum_value(e):
	randomize()
	return e.values()[randi() % e.size()]

func crime_nice_name(crime):
	match crime:
		Crimes.MURDER:
			return "Murder"
		Crimes.THEFT:
			return "Theft"
		Crimes.TRESPASSING:
			return "Trespassing"


func likes_nice_name(like):
	match like:
		Likes.CATS:
			return "Cats"
		Likes.DOGS:
			return "Dogs"
		Likes.FOOD:
			return "Food"
		Likes.TEA:
			return "Tea"
		Likes.RUNNING:
			return "Running"
		Likes.READING:
			return "Reading"


func dislikes_nice_name(dislike):
	match dislike:
		Dislikes.BEES:
			return "Bees"
		Dislikes.PRISON:
			return "Prison"
		Dislikes.COPS:
			return "Cops"
		Dislikes.CHILLI:
			return "Chilli"
		Dislikes.COFFEE:
			return "Coffee"
		Dislikes.FISH:
			return "Fish"
