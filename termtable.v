module termtable

pub struct Table {
pub mut:
	rowdata [][]string
}

pub fn (t Table) show() {
	cols := t.rowdata[0].len
	mut col_sizes := []int{ len: cols, init: 0 }
	for i in 0..cols {
		mut col := []string{}
		for r in t.rowdata {
			col << r[i]
		}
		for cval in col {
			if cval.len > col_sizes[i] {
				col_sizes[i] = cval.len
			}
		}
	}
	mut sepline := '+'
	for size in col_sizes {
		sepline += '-'.repeat(size + 2)
		sepline += '+'
	}
	mut rowstrings := []string{}
	for row in t.rowdata {
		mut rstr := '| '
		for j, cell in row {
			rstr += cell + ' '.repeat(col_sizes[j] - cell.len)
			rstr += ' | '
		}
		rowstrings << rstr
	}
	for row_str in rowstrings {
		println(sepline)
		println(row_str)
	}
	println(sepline)
}
