package rtos

import "core:fmt"

TaskState :: enum {
	Inactive,
	Ready,
	Running,
}

Task :: struct {
	ref:              int, /* ссылка на след. таску в связном списке при планировщике плоском */
	priority:         int, /* обычный приоритет */
	ceiling_priority: int, // приоритет с учётом захваченного ресурса (без ресурса = обычному приоритету)
	entry:            proc(),
	name:             string,
	state:            TaskState,
}

activate_task :: proc(task: Task) {
	fmt.println("Activate task", task.name)

	current_task := running_task // current_task_id?
	occupy := free_task // нужно придумать название получше чем occupy
	free_task = task_queue[occupy].ref

	task = task_queue[occupy].ref
	task_queue[occupy] = task

	schedule(task, InsertMode.InsertToTail)

	if (current_task != running_task) {
		dispatch(current_task)
	}
}

terminate_task :: proc() {
	current_task := running_task
	fmt.println("Terminate task", task_queue[current_task].name)
	running_task = task_queue[current_task].ref
	task_queue[current_task].ref = free_task
	free_task = current_task
	fmt.println("End of terminating task", task_queue[current_task].name)
}

schedule :: proc(task: int, insert_mode: InsertMode) {
	fmt.println("BU")
	cur := running_task
	prev := -1
	priority := task_queue[task].ceiling_priority
	for cur != -1 && task_queue[cur].ceiling_priority > priority {
		prev = cur
		cur = task_queue[cur].ref
	}

	if insert_mode == .InsertToTail {
		for cur != -1 && task_queue[cur].ceiling_priority == priority {
			prev = cur
			cur = task_queue[cur].ref
		}
	}
	task_queue[task].ref = cur

	if prev == -1 {
		RunningTask = task
	} else {
		task_queue[prev].ref = task
	}

	printf("End of Schedule %s\n", task_queue[task].name)
}

dispatch :: proc(task_id: int) {
	fmt.println("Dispatch")

	for running_task != task_id {
		task_queue[running_task].entry()
	}

	fmt.println("End of dispatch")
}
