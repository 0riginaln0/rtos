package rtos

import "core:fmt"

Resource :: struct {
	task:     int,
	priority: int,
	name:     string,
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
