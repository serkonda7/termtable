module termtable

fn test_table_str() {
	data := [
		['Name', 'Age'],
		['Max', '13'],
		['Moritz', '12'],
	]
	t := Table{
		rowdata: data
	}
	expected := '+--------+-----+
| Name   | Age |
+--------+-----+
| Max    | 13  |
+--------+-----+
| Moritz | 12  |
+--------+-----+'
	assert t.str() == expected
}

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
	assert row_to_string(row, col_sizes, .left) == expected
}

fn test_calculate_spacing() {
	inputs := [
		[2, 0],
		[4, 1],
		[5, 1],
		[3, 2],
	]
	expected := [
		[0, 2],
		[2, 2],
		[2, 3],
		[3, 0],
	]
	for i, inp in inputs {
		ls, rs := calculate_spacing(inp[0], Alignment(inp[1]))
		assert ls == expected[i][0]
		assert rs == expected[i][1]
	}
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
