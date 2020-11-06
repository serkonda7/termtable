module termtable

fn test_expand_tabs() {
	raw_datasets := [[
		['Name', 'Age\t'],
		['Max\t', '13'],
	], [
		['\tName', 'Age'],
		['Max\t\t', '13'],
	]]
	expanded_datasets := [[
		['Name', 'Age    '],
		['Max    ', '13'],
	], [
		['    Name', 'Age'],
		['Max        ', '13'],
	]]
	for i, d in raw_datasets {
		assert expand_tabs(d) == expanded_datasets[i]
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
	mut rd, mut cd := get_row_and_col_data(rowdata, .row)
	assert rd == rowdata
	assert cd == coldata
	rd, cd = get_row_and_col_data(coldata, .column)
	assert rd == rowdata
	assert cd == coldata
}

fn test_max_column_sizes() {
	coldata := [
		['Name', 'Age', 'Sex'],
		['Max', '13', 'male'],
		['Moritz', '12', 'male'],
	]
	colmaxes := [4, 4, 6]
	assert max_column_sizes(coldata) == colmaxes
}

fn test_get_border() {
	mut inputs := []Style{}
	inputs = [.plain]
	for inp in inputs {
		assert get_border(inp).style == inp
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

struct RowToStrInput {
	align   Alignment
	padding int
	style   Style
}

fn test_row_to_string() {
	row := ['a', 'bc', 'def']
	rspace := [2, 2, 0]
	inp_vals := [
		RowToStrInput{.left, 1, .grid},
		RowToStrInput{.center, 3, .grid},
	]
	expected := [
		'| a   | bc   | def |',
		'|    a    |    bc    |   def   |',
	]
	for i, inp in inp_vals {
		b := get_border(inp.style)
		exp := expected[i]
		assert row_to_string(row, rspace, inp.align, inp.padding, b) == exp
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

struct CreateSeplineInput {
	col_sizes []int
	padding   int
	style     Style
}

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
		CreateSeplineInput{
			col_sizes: [2, 2]
			padding: 1
			style: .plain
		},
	]
	expected := [
		['+---+----+-----+\n', '+---+----+-----+'],
		['+-+----+\n', '+-+----+'],
		['', ''],
	]
	for i, inp in inputs {
		b := get_border(inp.style)
		exp := expected[i]
		assert create_sepline(.top, inp.col_sizes, inp.padding, b) == exp[0]
		assert create_sepline(.header, inp.col_sizes, inp.padding, b) == exp[0]
		assert create_sepline(.middle, inp.col_sizes, inp.padding, b) == exp[0]
		assert create_sepline(.bottom, inp.col_sizes, inp.padding, b) == exp[1]
	}
}
