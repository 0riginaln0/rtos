package globals
/*мб вынести ресурс в подмодуль*/

Resource :: struct {
	task_ref: int, /* наверое не ref, а id */
	priority: int,
	name:     string,
}


/* resource_get() */
/* resource_release() */
