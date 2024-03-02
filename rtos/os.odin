package rtos

import globals "../globals"
import "core:fmt"

/*и мб другие параметры*/
start_os :: proc(task: globals.Task) {
	fmt.println("vrum vrum")
	fmt.println(task)
}
