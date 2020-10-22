module termtable

fn test_create_sepline() {
	col_sizes := [1, 2, 3]
	expected := '+---+----+-----+'
	assert create_sepline(col_sizes) == expected
}
