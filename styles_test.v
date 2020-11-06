import os
import termtable as tt

fn test_table_styles() {
	mut table := tt.Table{
		data: [
			['Name', 'Age', 'Sex'],
			['Max', '13', 'male'],
			['Moritz', '12', 'male'],
			['Lisa', '42', 'female'],
		]
		header_style: .plain
	}
	mut styles := []tt.Style{}
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
		exp := os.read_file('style_test_out/${s.str()}.out') or {
			panic(err)
		}
		assert table.str() == exp.trim_suffix('\n')
	}
}
