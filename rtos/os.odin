package rtos

import "core:fmt"

/*и мб другие параметры*/
start_os :: proc(task: Task) {
	running_task = -1
	free_task = 0
	free_resource = 0

	fmt.println("vrum vrum")

	for _, index in task_queue {
		task_queue[index].ref = index + 1
	}
	task_queue[MAX_TASK - 1].ref = -1

	for _, index in resource_queue {
		resource_queue[index].priority = i + 1 // почему так?
		resource_queue[index].task_ref = -1
	}
	resource_queue[MAX_RES - 1].priority = -1

	activate_task(task)
}

shutdown_os :: proc() {
	fmt.println("bb")
}
