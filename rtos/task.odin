package rtos

Task :: struct {
	// айди
	ref:              int, /* наверое не ref, а id */
	priority:         int,
	ceiling_priority: int,
	/* TODO: добавить поле которое является ссылкой на процедуру */
	name:             string,
}

/* task_activate() */
/* task_terminate() */
/* task_schedule() */
/* task_dispatch() */
