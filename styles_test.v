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
	mut styles := []termtable.Style{}
	styles = [
		.grid,
		.plain,
		.simple,
		.pretty,
		.github,
		.fancy_grid,
	]
	for s in styles {
		table.style = s
		mut exp := os.read_file('styles_test_out/${s.str()}.out') or {
			panic(err)
		}
		exp = exp.trim_suffix('\n')
		assert table.str() == exp
	}
}
