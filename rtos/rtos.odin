package rtos

import globals "../globals"
import "core:fmt"

main :: proc() {
	fmt.println("hello world")
	fmt.println("I am an RTOS")

	maximum_tasks := globals.MAX_TASK
	maximum_resources := globals.MAX_RES
	fmt.printf("I can have:\n  {0:i} tasks\n  {1:i} resources", maximum_tasks, maximum_resources)

	first_task := globals.Task {
		name = "Abobus",
	}
	start_os(first_task)
}

/*и мб другие параметры*/
start_os :: proc(task: globals.Task) {
	fmt.println("vrum vrum")
	fmt.println(task)
}