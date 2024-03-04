package api

import "core:fmt"

import t "types"

@(private)
MAX_TASK :: 32
@(private)
MAX_RES :: 16

@(private)
task_queue: [MAX_TASK]t.Task
/*фиксированный массив задач. У каждой задачи свой айдишник фиксированный, задаётся при старте ос*/
@(private)
resource_queue: [MAX_RES]t.Resource

@(private)
running_task: int
@(private)
free_task: int // *номер, ref, id* свободной задачи (речь про свободный слот в массиве)
@(private)
free_resource: int // *номер, ref, id* свободного ресурса (речь про свободный слот в массиве)

@(private)
InsertMode :: enum {
	INSERT_TO_HEAD,
	INSERT_TO_TAIL,
}

@(private)
schedule :: proc(task: int, insert_mode: InsertMode) {
	fmt.println("Schedule task", task_queue[task].name)
	cur := running_task
	prev := -1
	priority := task_queue[task].ceiling_priority

	for (cur != -1) && (task_queue[cur].ceiling_priority > priority) {
		prev = cur
		cur = task_queue[cur].ref
	}

	if insert_mode == .INSERT_TO_TAIL {
		for (cur != -1) && (task_queue[cur].ceiling_priority == priority) {
			prev = cur
			cur = task_queue[cur].ref
		}
	}
	task_queue[task].ref = cur

	if prev == -1 {
		running_task = task
	} else {
		task_queue[prev].ref = task
	}


	fmt.printf("End of Schedule %s\n", task_queue[task].name)
}

@(private)
dispatch :: proc(task: int) {
	fmt.println("Dispatch started")

	for running_task != task {
		task_queue[running_task].entry()
	}

	fmt.println("End of dispatch")
}

activate_task :: proc(entry: proc(), priority: int, name: string) {
	fmt.println("Activate task", name)

	task := running_task

	new_task_id := free_task
	task_queue[new_task_id].entry = entry
	task_queue[new_task_id].priority = priority
	task_queue[new_task_id].ceiling_priority = priority
	task_queue[new_task_id].name = name
	free_task = task_queue[new_task_id].ref

	schedule(new_task_id, InsertMode.INSERT_TO_TAIL)

	if (task != running_task) {
		dispatch(task)
	}
	fmt.println("End of Activate task", name)
}


terminate_task :: proc() {
	task := running_task

	fmt.println("Terminate task", task_queue[task].name)

	running_task = task_queue[task].ref
	task_queue[task].ref = free_task
	free_task = task

	fmt.println("End of terminating task", task_queue[task].name)
}

get_resource :: proc(priority: int, name: string) {
	fmt.println("Get resource", name)

	free_occupy := free_resource
	free_resource = resource_queue[free_occupy].priority

	resource_queue[free_occupy].priority = priority
	resource_queue[free_occupy].task = running_task
	resource_queue[free_occupy].name = name

	if task_queue[running_task].ceiling_priority < priority {
		task_queue[running_task].ceiling_priority = priority
	}
}

release_resource :: proc(priority: int, name: string) {
	fmt.println("Release resource", name)
	resource_index: int = ---

	if (task_queue[running_task].ceiling_priority == priority) {
		our_task := running_task
		task_priority := task_queue[running_task].priority

		for res, index in resource_queue {
			if res.task != running_task {
				continue
			}

			res_priority := res.priority
			if (res_priority == priority) && (name == res.name) {
				resource_index = index
			} else if res_priority > task_priority {
				task_priority = res_priority
			}
		}

		task_queue[running_task].ceiling_priority = task_priority
		running_task = task_queue[running_task].ref

		schedule(our_task, .INSERT_TO_HEAD)

		resource_queue[resource_index].priority = free_resource
		resource_queue[resource_index].task = -1
		free_resource = resource_index

		if our_task != running_task {
			dispatch(our_task)
		}
	} else {
		resource_index = 0

		for (resource_queue[resource_index].task != running_task ||
			    resource_queue[resource_index].priority != priority ||
			    resource_queue[resource_index].name != name) {
			resource_index += 1
		}

		resource_queue[resource_index].priority = free_resource
		resource_queue[resource_index].task = -1
		free_resource = resource_index
	}
}
