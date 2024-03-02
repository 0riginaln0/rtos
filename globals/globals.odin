package globals

MAX_TASK :: 16
MAX_RES :: 8

task_queue: [MAX_TASK]Task
/*фиксированный массив задач. У каждой задачи свой айдишник фиксированный, задаётся при старте ос*/
resource_queue: [MAX_RES]Resource

/* Хз что это */
running_task: int
free_task: int
free_resource: int


InsertMode :: enum {
	InsertToHead,
	InsertToTail,
}
