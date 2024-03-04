package rtos

import "core:fmt"

import "../global"
import o "../my_os"
import "../task"

main :: proc() {
	print_info()
	task1_priority := 5
	task1_name := "Abobus1"
	o.start_os(task1, task1_priority, task1_name)
	o.shutdown_os()
}

task1 :: proc() {
	fmt.println("Task1: Start")
	{
		//Task body
		fmt.println("Task1: Working")
	}
	fmt.println("Task1: Completed")
	task.terminate_task()
}

print_info :: proc() {
	fmt.println("hello world")
	fmt.println("I am an RTOS")
	maximum_tasks := global.MAX_TASK
	maximum_resources := global.MAX_RES
	fmt.printf("I can have:\n  {0:i} tasks\n  {1:i} resources\n", maximum_tasks, maximum_resources)
}
