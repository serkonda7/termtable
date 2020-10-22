module termtable

fn test_get_coldata() {
	rowdata := [
		['Name', 'Age'],
		['Max', '13'],
		['Moritz', '12'],
	]
	expected := [
		['Name', 'Max', 'Moritz'],
		['Age', '13', '12'],
	]
	assert get_coldata(rowdata) == expected
}

fn test_row_to_string() {
	row := ['a', 'bc', 'def']
	col_sizes := [3, 4, 3]
	expected := '| a   | bc   | def |'
	assert row_to_string(row, col_sizes) == expected
}

fn test_colmax() {
	column := ['Name', 'Max', 'Moritz']
	expected := 6
	assert colmax(column) == expected
}

fn test_create_sepline() {
	col_sizes := [1, 2, 3]
	expected := '+---+----+-----+'
	assert create_sepline(col_sizes) == expected
}
