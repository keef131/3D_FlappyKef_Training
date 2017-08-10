extends Node

#Camera Variables
var camera = null
var position_camera = null
var limit_repeater_floor = 50
var limit_repeater_obstacule = 20
var start_position_obs = 0
var start_position_floor = 0
var counter = 0
var array_floors = []
var array_obstacules = []
var target_delete = null


#New Objects variables
var next_position_obstacule = Vector3(0,0,0)
var next_position_floor = Vector3(0,0,0)
var scale_floor = Vector3(80,10,300)

#Charge scenario
var scene_obstacule = preload("res://Scenario/Obstacules.tscn")
var scene_floor = preload("res://Scenario/Floor.tscn")

func _ready():
	camera = get_node("../Camera")
	#first objects to create a scenario
	var scene_obstacule_instance = scene_obstacule.instance()
	add_child(scene_obstacule_instance)
	var scene_floor_instance = scene_floor.instance()
	scene_floor_instance.set_scale(scale_floor)
	add_child(scene_floor_instance)

	start_position_obs = camera.get_transform().origin.z
	start_position_floor = camera.get_transform().origin.z
	
#	for i in range(0, get_child_count()):
#    	get_parent().get_child(i).queue_free()
#    	print( get_parent().get_parent() )
	
#The camera moves in relation at the traslation of the camera, this involves the creation of the scenario too.
func _process(delta):
	counter = counter +1
	position_camera = camera.get_transform().origin

	if ( difference(start_position_obs, round(position_camera.z)) == limit_repeater_obstacule):
		start_position_obs = round(position_camera.z)
		repeater_obstacule()
	elif (difference(start_position_floor, round(position_camera.z)) == limit_repeater_floor):
		start_position_floor = round(position_camera.z)
		repeater_floor()
	
	print(array_obstacules.size())
	
	if ( (array_obstacules.size() > 0) && (array_floors.size() > 0) ):
		target_delete = array_obstacules.front()
		target_delete.free()
		array_obstacules.pop_front()
		print("Erase front obstacule" + str(target_delete))
		
		target_delete = array_floors.front()
		target_delete.free()
		array_obstacules.pop_front()
		print("Erase front floor" + str(target_delete))
	
func repeater_obstacule():
	next_position_obstacule.z += 20
	osbtacule_flappy(next_position_obstacule)
	
func repeater_floor():
	next_position_floor.z += 50
	floor_flappy(next_position_floor)
	
func osbtacule_flappy(z_distance):
	var scene_obstacule_instance = scene_obstacule.instance()
	scene_obstacule_instance.translate(z_distance)
	array_obstacules.append(scene_obstacule_instance)
	add_child(scene_obstacule_instance)
	
func floor_flappy(z_distance):
	var scene_floor_instance = scene_floor.instance()
	scene_floor_instance.translate(z_distance)
	scene_floor_instance.set_scale(scale_floor)
	array_floors.append(scene_floor_instance)
	add_child(scene_floor_instance)
	
func difference(first_distance, second_distance):
	var dif = abs( ( first_distance - round(second_distance)) )
	return dif