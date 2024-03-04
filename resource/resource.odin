package resource

import "core:fmt"

import "../global"
import "../task"

Resource :: struct {
	task:     int,
	priority: int,
	name:     string,
}

get_resource :: proc(priority: int, name: string) {
	fmt.println("Get resource", name)

	free_occupy := global.free_resource
	global.free_resource = global.resource_queue[free_occupy].priority

	global.resource_queue[free_occupy].priority = priority
	global.resource_queue[free_occupy].task = global.running_task
	global.resource_queue[free_occupy].name = name

	if global.task_queue[global.running_task].ceiling_priority < priority {
		global.task_queue[global.running_task].ceiling_priority = priority
	}
}

release_resource :: proc(priority: int, name: string) {
	fmt.println("Release resource", name)
	resource_index: int = ---

	if (global.task_queue[global.running_task].ceiling_priority == priority) {
		our_task := global.running_task
		task_priority := global.task_queue[global.running_task].priority

		for res, index in global.resource_queue {
			if res.task != global.running_task {
				continue
			}

			res_priority := res.priority
			if (res_priority == priority) && (name == res.name) {
				resource_index = index
			} else if res_priority > task_priority {
				task_priority = res_priority
			}
		}

		global.task_queue[global.running_task].ceiling_priority = task_priority
		global.running_task = global.task_queue[global.running_task].ref

		task.schedule(our_task, .INSERT_TO_HEAD)

		global.resource_queue[resource_index].priority = global.free_resource
		global.resource_queue[resource_index].task = -1
		global.free_resource = resource_index

		if our_task != global.running_task {
			task.dispatch(our_task)
		}
	} else {
		resource_index = 0

		for (global.resource_queue[resource_index].task != global.running_task ||
			    global.resource_queue[resource_index].priority != priority ||
			    global.resource_queue[resource_index].name != name) {
			resource_index += 1
		}

		global.resource_queue[resource_index].priority = global.free_resource
		global.resource_queue[resource_index].task = -1
		global.free_resource = resource_index
	}
}
