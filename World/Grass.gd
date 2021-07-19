extends Node2D

func create_grass_effect():
		var GrassEffect = load("res://Effects/GrassEffect.tscn")
		var grasseffect = GrassEffect.instance()
		var main = get_tree().current_scene
		main.add_child(grasseffect)
		grasseffect.global_position = global_position
		queue_free()


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
