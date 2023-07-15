@tool
extends EditorPlugin

var main := preload("res://addons/autopocketad/main.tscn")
var node = main.instantiate()

func _enter_tree() -> void:
    add_control_to_bottom_panel(node, "口袋工厂接入")
    add_autoload_singleton("AD", "res://addons/autopocketad/FlowerAD.gd")

func _exit_tree() -> void:
    remove_control_from_bottom_panel(node)
    node.queue_free()
    remove_autoload_singleton("AD")
