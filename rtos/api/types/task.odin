package types

Task :: struct {
	name:             string,
	entry:            proc(),
	ref:              int, /* ссылка на след. таску в связном списке при планировщике плоском */
	priority:         int, /* обычный приоритет */
	ceiling_priority: int, // приоритет с учётом захваченного ресурса (без ресурса = обычному приоритету)
}
