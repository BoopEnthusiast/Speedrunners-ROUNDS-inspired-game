extends Node
## Holds references to nodes
##
## To add a new node to this, add it as a variable type-checked to itself,[br]
## then, in its _enter_tree function set this singleton's variable of that node to iself.[br]
## [br]
## Always check that the node exists before using it.

var player: Player
