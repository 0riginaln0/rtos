package api

import "core:fmt"

start_os :: proc(entry: proc(), priority: int, name: string) {
	fmt.println("OS: Start")

	running_task = -1
	free_task = 0 // Номер свободной задачи.
	free_resource = 0

	for _, index in task_queue {
		task_queue[index].ref = index + 1
	}
	task_queue[MAX_TASK - 1].ref = -1

	for _, index in resource_queue {
		resource_queue[index].priority = index + 1
		resource_queue[index].task = -1
	}
	resource_queue[MAX_RES - 1].priority = -1

	activate_task(entry, priority, name)
}

shutdown_os :: proc() {
	fmt.println("OS: Shutdown")
}
