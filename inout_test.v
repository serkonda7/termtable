import os
import termtable

fn test_table_styles() {
	custom_style := termtable.StyleConfig{
		topline: termtable.empty_line
		middleline: termtable.empty_line
		bottomline: termtable.empty_line
		headerline: termtable.Sepline{
			left: ''
			right: ''
			cross: ''
			sep: '='
		}
		col_sep: ''
	}
	mut table := termtable.Table{
		data: [
			['Name', 'Age', 'Sex'],
			['Max', '13', 'male'],
			['Moritz', '12', 'male'],
			['Lisa', '42', 'female'],
		]
		header_style: .plain
	}
	for i := 0; true; i++ {
		s := termtable.Style(i)
		if s.str() == 'unknown enum value' {
			break
		}
		table.style = s
		if s == .custom {
			table.custom_style = custom_style
		}
		mut exp := os.read_file('tests/styles/${s.str()}.out') or {
			panic(err)
		}
		exp = exp.trim_suffix('\n')
		assert table.str() == exp
	}
}

fn test_single_row_tables() {
	table := termtable.Table{
		data: [
			['Foo', 'bar', 'baz'],
		]
		header_style: .plain
		style: .grid
	}
	mut exp := os.read_file('tests/grid_single_row.out') or {
		panic(err)
	}
	exp = exp.trim_suffix('\n')
	assert table.str() == exp
}

fn test_no_padding() {
	mut table := termtable.Table{
		data: [
			['Name', 'Age', 'Sex'],
			['Max', '13', 'male'],
			['Lisa', '42', 'female'],
		]
		padding: 0
		header_style: .plain
	}
	mut styles := []termtable.Style{}
	styles = [
		.plain,
		.simple,
	]
	for s in styles {
		table.style = s
		mut exp := os.read_file('tests/no_padding/${s.str()}.out') or {
			panic(err)
		}
		exp = exp.trim_suffix('\n')
		assert table.str() == exp
	}
}
