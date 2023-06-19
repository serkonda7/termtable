module termtable

import os

const (
	dir = os.dir(@FILE)
)

fn test_cjk_chars() {
	table := Table{
		data: [
			['键', '值值'],
			['V版本', 'V 0.2.2'],
		]
		header_style: .plain
	}
	mut exp := os.read_file('${.dir}/tests/unicode/cjk.out') or { panic(err) }
	exp = exp.trim_string_right('\n')
	assert table.str() == exp
}
