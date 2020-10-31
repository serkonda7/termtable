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
		Table{
			data: [
				['Name', 'Age'],
				['Lisa', '42'],
			]
			header_style: .plain
			align: .center
			padding: 3
		},
	]
	expected := [
		'+------+-----+
| \e[1mName\e[0m | \e[1mAge\e[0m |
+------+-----+
| Lisa | 42  |
+------+-----+',
		'+----+---+------+
|\e[1mName\e[0m|Max|Moritz|
+----+---+------+
| \e[1mAge\e[0m| 13|    12|
+----+---+------+',
		'+----------+---------+
|   Name   |   Age   |
+----------+---------+
|   Lisa   |   42    |
+----------+---------+',
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

fn test_colmax() {
	columns := [
		['Name', 'Age', 'Sex'],
		['Max', '13', 'male'],
		['Moritz', '12', 'male'],
	]
	expected := [4, 4, 6]
	assert colmax(columns) == expected
}

struct CreateSeplineInput {
	col_sizes []int
	padding   int
	style     Style
}

// this is also the test for get_border()
fn test_create_sepline() {
	inputs := [
		CreateSeplineInput{
			col_sizes: [1, 2, 3]
			padding: 1
			style: .grid
		},
		CreateSeplineInput{
			col_sizes: [1, 4]
			padding: 0
			style: .grid
		},
	]
	expected := [
		'+---+----+-----+',
		'+-+----+',
	]
	for i, inp in inputs {
		b := get_border(inp.style)
		assert create_sepline(.top, inp.col_sizes, inp.padding, b) == expected[i]
		assert create_sepline(.middle, inp.col_sizes, inp.padding, b) == expected[i]
		assert create_sepline(.bottom, inp.col_sizes, inp.padding, b) == expected[i]
	}
}

struct RowToStrInput {
	align   Alignment
	padding int
}

fn test_row_to_string() {
	row := ['a', 'bc', 'def']
	rspace := [2, 2, 0]
	inp_vals := [
		RowToStrInput{.left, 1},
		RowToStrInput{.center, 3},
	]
	expected := [
		'| a   | bc   | def |',
		'|    a    |    bc    |   def   |',
	]
	for i, val in inp_vals {
		exp := expected[i]
		assert row_to_string(row, rspace, val.align, val.padding) == exp
	}
}

fn test_get_row_spaces() {
	rows := [
		['a', 'bc', 'def'],
		['foo', 'bar', 'baz'],
	]
	col_sizes := [
		[3, 4, 5],
		[5, 3, 6],
	]
	expected := [
		[2, 2, 2],
		[2, 0, 3],
	]
	for i, r in rows {
		assert get_row_spaces(r, col_sizes[i]) == expected[i]
	}
}

fn test_cell_space() {
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
		ls, rs := cell_space(inp[0], Alignment(inp[1]))
		assert ls == expected[i][0]
		assert rs == expected[i][1]
	}
}

fn test_apply_header_style() {
	rows := [
		['a', 'bc', 'def'],
		['foo', 'bar', 'baz'],
	]
	assert apply_header_style(rows[0], .bold) == ['\e[1ma\e[0m', '\e[1mbc\e[0m', '\e[1mdef\e[0m']
	assert apply_header_style(rows[1], .plain) == ['foo', 'bar', 'baz']
}
