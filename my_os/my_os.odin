package my_os

import "core:fmt"

import "../global"
import "../task"

start_os :: proc(entry: proc(), priority: int, name: string) {
	fmt.println("OS: Start")

	global.running_task = -1
	global.free_task = 0 // Номер свободной задачи. (Позиция свободной задачи в массиве task_queue)
	global.free_resource = 0

	for _, index in global.task_queue {
		// поле ref в элементе массива задач означает номер след. элемента в списке
		global.task_queue[index].ref = index + 1
	}
	global.task_queue[global.MAX_TASK - 1].ref = -1

	for _, index in global.resource_queue {
		global.resource_queue[index].priority = index + 1 // почему так?
		global.resource_queue[index].task = -1 // Номер задачи, которая владеет ресурсом
	}
	global.resource_queue[global.MAX_RES - 1].priority = -1

	task.activate_task(entry, priority, name)
}

shutdown_os :: proc() {
	fmt.println("OS: Shutdown")
}
