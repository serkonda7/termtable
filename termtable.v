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
		col_sizes[i] = colmax(col)
	}
	sepline := create_sepline(col_sizes)
	mut rowstrings := []string{}
	for row in t.rowdata {
		rowstrings << row_to_string(row, col_sizes)
	}
	for row_str in rowstrings {
		println(sepline)
		println(row_str)
	}
	println(sepline)
}

fn row_to_string(row []string, col_sizes []int) string {
	mut rstr := '| '
	for i, cell in row {
		rstr += cell + ' '.repeat(col_sizes[i] - cell.len)
		rstr += ' | '
	}
	return rstr.trim_space()
}

fn colmax(col []string) int {
	mut max := 0
	for c in col {
		if c.len > max {
			max = c.len
		}
	}
	return max
}

fn create_sepline(col_sizes []int) string {
	mut line := '+'
	for cs in col_sizes {
		line += '-'.repeat(cs + 2)
		line += '+'
	}
	return line
}
