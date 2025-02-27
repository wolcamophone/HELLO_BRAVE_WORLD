extends Node

### https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

# Called when the node enters the scene tree for the first time.
func load_game_by_docs():
	print("Loading...")
	if not FileAccess.file_exists("user://savegame_hbw.json"):
		print("No save game file was found to load.")

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("persistent")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var game_save = FileAccess.open("user://savegame_hbw.json", FileAccess.READ)
	while game_save.get_position() < game_save.get_length():
		var json_string = game_save.get_line()
		# Creates the helper class to interact with JSON
		var json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", 
			json.get_error_line())
			continue
		# Get the data from the JSON object
		var node_data = json.get_data()
		# Firstly, we need to create the object and add it to the tree and set its position.
		#var new_object = load(node_data["filename"]).instantiate()
		#get_node(node_data["parent"]).add_child(new_object)
		
		#GameMaster.active_player.position = Vector3(node_data["pos_x"],node_data["pos_y"],node_data["pos_z"])
		
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "pos_z":
				continue
			#new_object.set(i, node_data[i])
			print(node_data.keys())
			#load_level(node_data["level_name_current"])
	print("Finished Loading!")
