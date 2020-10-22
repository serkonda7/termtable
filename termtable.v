module termtable

pub enum Alignment {
	left
	center
	right
}

pub struct Table {
pub mut:
	rowdata [][]string
	align   Alignment = .left
	padding int = 1
}

pub fn (t Table) str() string {
	coldata := get_coldata(t.rowdata)
	mut col_sizes := []int{}
	for c in coldata {
		col_sizes << colmax(c)
	}
	sepline := create_sepline(col_sizes)
	mut rowstrings := []string{}
	for row in t.rowdata {
		rowstrings << row_to_string(row, col_sizes, t.align, t.padding)
	}
	mut final_str := '$sepline\n'
	for row_str in rowstrings {
		final_str += '$row_str\n'
		final_str += '$sepline\n'
	}
	return final_str.trim_space()
}

fn get_coldata(rowdata [][]string) [][]string {
	mut coldata := [][]string{}
	col_count := rowdata[0].len
	for i in 0 .. col_count {
		mut c := []string{}
		for r in rowdata {
			c << r[i]
		}
		coldata << c
	}
	return coldata
}

fn row_to_string(row []string, col_sizes []int, align Alignment, padding int) string {
	pad := ' '.repeat(padding)
	mut rstr := '|$pad'
	for i, cell in row {
		lspace, rspace := calculate_spacing(col_sizes[i] - cell.len, align)
		rstr += ' '.repeat(lspace) + cell + ' '.repeat(rspace)
		rstr += '$pad|$pad'
	}
	return rstr.trim_space()
}

fn calculate_spacing(total_space int, align Alignment) (int, int) {
	match align {
		.left {
			return 0, total_space
		}
		.center {
			half_space := total_space / 2
			right_space := half_space + total_space % 2
			return half_space, right_space
		}
		.right {
			return total_space, 0
		}
	}
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
