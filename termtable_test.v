module termtable

fn test_table_str() {
	tables := [
		Table{
			data: [
				['Name', 'Age'],
				['Lisa', '42'],
			]
		},
		Table{
			data: [
				['Name', 'Age'],
				['Max', '13'],
				['Moritz', '12'],
			]
			orientation: .column
			align: .right
			padding: 0
		},
	]
	expected := [
		'+------+-----+
| Name | Age |
+------+-----+
| Lisa | 42  |
+------+-----+',
		'+----+---+------+
|Name|Max|Moritz|
+----+---+------+
| Age| 13|    12|
+----+---+------+',
	]
	for i, t in tables {
		assert t.str() == expected[i]
	}
}

fn test_get_row_and_col_data() {
	rowdata := [
		['Name', 'Age'],
		['Max', '13'],
		['Moritz', '12'],
	]
	coldata := [
		['Name', 'Max', 'Moritz'],
		['Age', '13', '12'],
	]
	mut r1, mut r2 := get_row_and_col_data(rowdata, .row)
	assert r1 == rowdata
	assert r2 == coldata
	r1, r2 = get_row_and_col_data(coldata, .column)
	assert r1 == rowdata
	assert r2 == coldata
}

fn test_row_to_string() {
	row := ['a', 'bc', 'def']
	col_sizes := [3, 4, 3]
	inputs := [
		[0, 1],
		[2, 3],
	]
	expected := [
		'| a   | bc   | def |',
		'|     a   |     bc   |   def   |',
	]
	for i, inp in inputs {
		res := row_to_string(row, col_sizes, Alignment(inp[0]), inp[1])
		assert res == expected[i]
	}
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
	col_sizes := [
		[1, 2, 3],
		[1, 4],
	]
	paddings := [1, 0]
	expected := [
		'+---+----+-----+',
		'+-+----+',
	]
	for i, sizes in col_sizes {
		assert create_sepline(sizes, paddings[i]) == expected[i]
	}
}
