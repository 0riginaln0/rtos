package rtos

import "core:fmt"

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

dispatch :: proc(task: int) {
	fmt.println("Dispatch started")

	for running_task != task {
		task_queue[running_task].entry()
	}

	fmt.println("End of dispatch")
}

terminate_task :: proc() {
	task := running_task

	fmt.println("Terminate task", task_queue[task].name)

	running_task = task_queue[task].ref
	task_queue[task].ref = free_task
	free_task = task

	fmt.println("End of terminating task", task_queue[task].name)
}
