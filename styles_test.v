module termtable

import os

const (
	dir = os.dir(@FILE)
)

fn test_table_styles() {
	custom_style := StyleConfig{
		headerline: Sepline{
			left: ''
			right: ''
			cross: ''
			sep: '='
		}
		colsep: ' '
	}
	mut table := Table{
		data: [
			['Name', 'Age', 'Sex'],
			['Max', '13', 'male'],
			['Moritz', '12', 'male'],
			['Lisa', '42', 'female'],
		]
		header_style: .plain
	}
	for i := 0; true; i++ {
		s := Style(i)
		if s.str() == 'unknown enum value' {
			break
		}
		table.style = s
		if s == .custom {
			table.custom_style = custom_style
		}
		mut exp := os.read_file('$termtable.dir/tests/styles/${s.str()}.out') or { panic(err) }
		exp = exp.trim_suffix('\n')
		assert table.str() == exp
	}
}

fn test_single_row_tables() {
	table := Table{
		data: [
			['Foo', 'bar', 'baz'],
		]
		header_style: .plain
		style: .grid
	}
	mut exp := os.read_file('$termtable.dir/tests/grid_single_row.out') or { panic(err) }
	exp = exp.trim_suffix('\n')
	assert table.str() == exp
}

fn test_no_padding() {
	mut table := Table{
		data: [
			['Name', 'Age', 'Sex'],
			['Max', '13', 'male'],
			['Lisa', '42', 'female'],
		]
		padding: 0
		header_style: .plain
	}
	mut styles := []Style{}
	styles = [
		.plain,
		.simple,
	]
	for s in styles {
		table.style = s
		mut exp := os.read_file('$termtable.dir/tests/no_padding/${s.str()}.out') or { panic(err) }
		exp = exp.trim_suffix('\n')
		assert table.str() == exp
	}
}
