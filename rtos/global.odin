package rtos

MAX_TASK :: 32
MAX_RES :: 16

task_queue: [MAX_TASK]Task
/*фиксированный массив задач. У каждой задачи свой айдишник фиксированный, задаётся при старте ос*/
resource_queue: [MAX_RES]Resource

running_task: int = -1 // Выполняемая задача
free_task: int = 0 // *номер, ref, id* свободной задачи (речь про свободный слот в массиве)
free_resource: int = 0 // *номер, ref, id* свободного ресурса (речь про свободный слот в массиве)

InsertMode :: enum {
	InsertToHead,
	InsertToTail,
}
