package rtos

import "core:fmt"

main :: proc() {
	print_info()
	task1_priority := 5
	task1_name := "Abobus1"
	start_os(task1, task1_priority, task1_name)
	shutdown_os()
}

task1 :: proc() {
	fmt.println("Task1: Start")
	{
		//Task body
		fmt.println("Task1: Working")
	}
	fmt.println("Task1: Completed")
	terminate_task()
}

print_info :: proc() {
	fmt.println("hello world")
	fmt.println("I am an RTOS")
	maximum_tasks := MAX_TASK
	maximum_resources := MAX_RES
	fmt.printf("I can have:\n  {0:i} tasks\n  {1:i} resources\n", maximum_tasks, maximum_resources)
}
