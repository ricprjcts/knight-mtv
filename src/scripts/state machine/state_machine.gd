extends Node
class_name StateMachine

@export var initial_state: BaseState
var active_state: BaseState

func init(body: CharacterBody2D, movement: MovementComponent) -> void:
	var states: Dictionary[String, BaseState] = {}
	
	for state: BaseState in get_children():
		state.change_state.connect(change_state)
		
		state.state_machine = self
		state.body = body
		state.movement = movement
		
		states[state.name] = state
	
	for state: BaseState in get_children():
		state.states = states
	
	if initial_state:
		active_state = initial_state

func process(delta: float) -> void:
	if active_state:
		active_state.process(delta)

func physics_process(delta: float) -> void:
	if active_state:
		active_state.physics_process(delta)

func change_state(new_state: BaseState) -> void:
	if new_state == active_state:
		return
	
	if active_state:
		active_state.exit()
	
	active_state = new_state
	
	active_state.enter()
	
	#print(active_state.name)
