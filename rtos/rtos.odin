package rtos

import "core:fmt"

import "api"

main :: proc() {
	task1_priority := 5
	task1_name := "Task1"
	api.start_os(task1, task1_priority, task1_name)
	api.shutdown_os()
}

task1 :: proc() {
	fmt.println("Task1: Start")
	api.activate_task(task2, 4, "Task2")
	{
		//Task body
		fmt.println("Task1: Working")
	}
	fmt.println("Task1: Completed")
	api.terminate_task()
}

task2 :: proc() {
	fmt.println("Task2: Start")
	api.activate_task(task3, 6, "Task3")
	{
		//Task body
		fmt.println("Task2: Working")

	}
	fmt.println("Task2: Completed")
	api.terminate_task()
}

task3 :: proc() {
	fmt.println("Task3: Start")
	{
		//Task body
		fmt.println("Task3: Working")
	}
	fmt.println("Task3: Completed")
	api.terminate_task()
}
