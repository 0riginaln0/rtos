package rtos

import "core:fmt"

main :: proc() {
	fmt.println("hello world")
	fmt.println("I am an RTOS")

	maximum_tasks := MAX_TASK
	maximum_resources := MAX_RES
	fmt.printf("I can have:\n  {0:i} tasks\n  {1:i} resources\n", maximum_tasks, maximum_resources)

	first_task := Task {
		name = "Abobus",
	}
	start_os(first_task)

	shutdown_os()
}

//todo: подумать про то где передаём task: Task, а где task: int
//todo: правильная инициализация задачи, чтобы ceiling и другие поля были норм
//todo: названия переменных
//todo: как грамотно раскидать все файлы по разным package
