package rtos

import "core:fmt"

main :: proc() {
	print_info()
	task1_priority := 5
	task1_name := "Task1"
	start_os(task1, task1_priority, task1_name)
	shutdown_os()
}

task1 :: proc() {
	fmt.println("Task1: Start")
	activate_task(task2, 4, "Task2")
	{
		//Task body
		fmt.println("Task1: Working")
	}
	fmt.println("Task1: Completed")
	terminate_task()
}

task2 :: proc() {
	fmt.println("Task2: Start")
	activate_task(task3, 6, "Task3")
	{
		//Task body
		fmt.println("Task2: Working")

	}
	fmt.println("Task2: Completed")
	terminate_task()
}

task3 :: proc() {
	fmt.println("Task3: Start")
	{
		//Task body
		fmt.println("Task3: Working")
	}
	fmt.println("Task3: Completed")
	terminate_task()
}

print_info :: proc() {
	fmt.println("hello world")
	fmt.println("I am an RTOS")
	maximum_tasks := MAX_TASK
	maximum_resources := MAX_RES
	fmt.printf(
		"I can have:\n  {0:i} tasks\n  {1:i} resources\n\n",
		maximum_tasks,
		maximum_resources,
	)
}
