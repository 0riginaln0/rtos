package task

import "core:fmt"

import global "../global"

Task :: struct {
	name:             string,
	entry:            proc(),
	ref:              int, /* ссылка на след. таску в связном списке при планировщике плоском */
	priority:         int, /* обычный приоритет */
	ceiling_priority: int, // приоритет с учётом захваченного ресурса (без ресурса = обычному приоритету)
}

InsertMode :: enum {
	INSERT_TO_HEAD,
	INSERT_TO_TAIL,
}

activate_task :: proc(entry: proc(), priority: int, name: string) {
	fmt.println("Activate task", name)

	task := global.running_task

	new_task_id := global.free_task
	global.task_queue[new_task_id].entry = entry
	global.task_queue[new_task_id].priority = priority
	global.task_queue[new_task_id].ceiling_priority = priority
	global.task_queue[new_task_id].name = name
	global.free_task = global.task_queue[new_task_id].ref

	schedule(task, InsertMode.INSERT_TO_TAIL)

	if (task != global.running_task) {
		dispatch(task)
	}
	fmt.println("End of Activate task", name)
}

schedule :: proc(task: int, insert_mode: global.InsertMode) {

	cur := global.running_task
	prev := -1
	priority := global.task_queue[task].ceiling_priority

	for (cur != -1) && (global.task_queue[cur].ceiling_priority > priority) {
		prev = cur
		cur = global.task_queue[cur].ref
	}

	if insert_mode == .INSERT_TO_TAIL {
		for (cur != -1) && (global.task_queue[cur].ceiling_priority == priority) {
			prev = cur
			cur = global.task_queue[cur].ref
		}
	}
	global.task_queue[task].ref = cur

	if prev == -1 {
		global.running_task = task
	} else {
		global.task_queue[prev].ref = task
	}

	printf("End of Schedule %s\n", global.task_queue[task].name)
}

dispatch :: proc(task: int) {
	fmt.println("Dispatch")

	for global.running_task != task {
		global.task_queue[global.running_task].entry()
	}

	fmt.println("End of dispatch")
}

terminate_task :: proc() {
	task := global.running_task

	fmt.println("Terminate task", global.task_queue[task].name)

	global.running_task = global.task_queue[task].ref
	global.task_queue[task].ref = global.free_task
	global.free_task = task

	fmt.println("End of terminating task", global.task_queue[task].name)
}
