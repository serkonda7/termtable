import os
import termtable

fn test_table_styles() {
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
