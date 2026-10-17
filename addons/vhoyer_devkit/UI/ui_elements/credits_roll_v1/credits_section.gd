@tool
extends Resource
class_name CreditsSection

enum Type {
	## Display main string on the left column,
	## and N secondary strings on the right column
	l1_rN,
	## Displays only the main string one on each line
	single_main,
}

@export var type: Type = Type.l1_rN
@export var title: String
@export var blocks: Array[CreditsBlock]
