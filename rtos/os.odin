package rtos

import "core:fmt"

/*и мб другие параметры*/
start_os :: proc(task: Task) {
	fmt.println("vrum vrum")
	fmt.println(task)
}

/* shutdown_os :: proc() {}*/
