module termtable

fn test_validate_table_properties() {
	tables := {
		'no_data':             Table{}
		'small_tab':           Table{
			data: [['Foo\t']]
			tabsize: 1
		}
		'negative_pad':        Table{
			data: [['Foo']]
			padding: -1
		}
		'no_custom_style_cfg': Table{
			data: [['Foo']]
			style: .custom
		}
	}
	error_suffixes := {
		'no_data':             'Table.data should not be empty.'
		'small_tab':           'tabsize should be at least 2 (got 1).'
		'negative_pad':        'cannot use a negative padding (got -1).'
		'no_custom_style_cfg': 'please provide a value for `custom_style` if you use `style: .custom`.'
	}
	mut errors := 0
	for k, t in tables {
		validate_table_properties(t) or {
			errors++
			assert err.msg == error_suffixes[k]
		}
	}
	assert errors == tables.len
}

fn test_expand_tabs() {
	tabs := [
		['\tName', 'Sex\t\t'],
		['1.\tMax', 'male\t'],
		['2. Moritz', 'male'],
	]
	tabsizes := [4, 2]
	expanded_tabs := [
		[
			['    Name', 'Sex     '],
			['1.  Max', 'male    '],
			['2. Moritz', 'male'],
		],
		[
			['  Name', 'Sex   '],
			['1.  Max', 'male  '],
			['2. Moritz', 'male'],
		],
	]
	for i, ts in tabsizes {
		exp := expanded_tabs[i]
		assert expand_tabs(tabs, ts) == exp
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
		['Name', 'Max', 'Moritz', 'Lisa'],
		['Age', '13', '12', '42'],
		['Sex', 'male', 'male', 'female'],
		['', ''],
	]
	colmaxes := [6, 3, 6, 0]
	assert max_column_sizes(coldata) == colmaxes
}

struct ApplyHeaderStyleInput {
	row          []string
	header_style HeaderStyle
	orient       Orientation
}

fn test_apply_header_style() {
	inputs := [
		ApplyHeaderStyleInput{['spam', 'eggs'], .bold, .row},
		ApplyHeaderStyleInput{['foo', 'bar', 'baz'], .plain, .row},
		ApplyHeaderStyleInput{['test', 'placeholder'], .bold, .column},
	]
	expected := [
		['\e[1mspam\e[0m', '\e[1meggs\e[0m'],
		['foo', 'bar', 'baz'],
		['\e[1mtest\e[0m', 'placeholder'],
	]
	for i, inp in inputs {
		exp := expected[i]
		assert apply_header_style(inp.row, inp.header_style, inp.orient) == exp
	}
}

struct RowSpacesInput {
	row       []string
	col_sizes []int
}

fn test_get_row_spaces() {
	inputs := [
		RowSpacesInput{['a', 'bc', 'def'], [3, 4, 5]},
		RowSpacesInput{['foo', 'bar', 'baz'], [5, 3, 6]},
		RowSpacesInput{[''], [0]},
		RowSpacesInput{['🤨', '💯💯', '✌👍🐞'], [4, 5, 5]},
	]
	expected := [
		[2, 2, 2],
		[2, 0, 3],
		[0],
		[2, 1, 0],
	]
	for i, inp in inputs {
		exp := expected[i]
		assert get_row_spaces(inp.row, inp.col_sizes) == exp
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
		b := get_style_config(inp.style)
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
		b := get_style_config(inp.style)
		exp := expected[i]
		assert create_sepline(.top, inp.col_sizes, inp.padding, b) == exp[0]
		assert create_sepline(.header, inp.col_sizes, inp.padding, b) == exp[0]
		assert create_sepline(.middle, inp.col_sizes, inp.padding, b) == exp[0]
		assert create_sepline(.bottom, inp.col_sizes, inp.padding, b) == exp[1]
	}
}
