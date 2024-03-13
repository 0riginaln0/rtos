package types

Task :: struct {
	name:             string,
	entry:            proc(),
	ref:              int, /* ссылка на след. задачу в связном списке плоского планировщика */
	priority:         int, /* обычный приоритет */
	ceiling_priority: int, /* приоритет с учётом захваченного ресурса (без ресурса = обычному приоритету) */
}
