class_name OrientedGraph extends Resource

var graph:Dictionary


func _init(n:Dictionary = Dictionary()) -> void:
	graph = n


# identidies nodes in cycles with DFS  and marks them
func get_nodes_in_cycles() -> Array:
	var nodes_in_any_cycle := []
	var dfs_stack := []
	var unvisited_nodes = graph.keys()
	
	while !unvisited_nodes.empty():
		var k = unvisited_nodes.pop_back()
		dfs_stack = [k]
		
		while !dfs_stack.empty():
			var must_pop_stack_element:bool = true
			
			for n in graph[dfs_stack.back()]:
				
				if unvisited_nodes.has(n):
					unvisited_nodes.erase(n)
					dfs_stack.push_back(n)
					must_pop_stack_element = false
					break
				
				elif dfs_stack.has(n):
			
					for i in range(dfs_stack.find(n), dfs_stack.size()):
						
						if !nodes_in_any_cycle.has(dfs_stack[i]):
							nodes_in_any_cycle.append(dfs_stack[i])
					
			if must_pop_stack_element:
				dfs_stack.pop_back()
	
	return nodes_in_any_cycle
