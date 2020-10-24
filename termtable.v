module termtable

pub enum Orientation {
	row
	column
}

pub enum Alignment {
	left
	center
	right
}

pub struct Table {
pub mut:
	data        [][]string
	orientation Orientation = .row
	align       Alignment = .left
	padding     int = 1
}

pub fn (t Table) str() string {
	rowdata, coldata := get_row_and_col_data(t.data, t.orientation)
	mut col_sizes := []int{}
	for c in coldata {
		col_sizes << colmax(c)
	}
	sepline := create_sepline(col_sizes, t.padding)
	mut rowstrings := []string{}
	for row in rowdata {
		rspace := get_row_spaces(row, col_sizes)
		rowstrings << row_to_string(row, rspace, t.align, t.padding)
	}
	mut final_str := '$sepline\n'
	for row_str in rowstrings {
		final_str += '$row_str\n'
		final_str += '$sepline\n'
	}
	return final_str.trim_space()
}

fn get_row_and_col_data(data [][]string, orient Orientation) ([][]string, [][]string) {
	mut otherdata := [][]string{}
	other_count := data[0].len
	for i in 0 .. other_count {
		mut od := []string{}
		for d in data {
			od << d[i]
		}
		otherdata << od
	}
	if orient == .row {
		return data, otherdata
	} else {
		return otherdata, data
	}
}

fn row_to_string(row []string, rspace []int, align Alignment, padding int) string {
	pad := ' '.repeat(padding)
	mut rstr := '|$pad'
	for i, cell in row {
		sl, sr := cell_space(rspace[i], align)
		rstr += ' '.repeat(sl) + cell + ' '.repeat(sr)
		rstr += '$pad|$pad'
	}
	return rstr.trim_space()
}

fn get_row_spaces(row []string, col_sizes []int) []int {
	mut rspace := []int{}
	for i, cell in row {
		rspace << col_sizes[i] - cell.len
	}
	return rspace
}

fn cell_space(total_space int, align Alignment) (int, int) {
	match align {
		.left {
			return 0, total_space
		}
		.center {
			half_space := total_space / 2
			sr := half_space + total_space % 2
			return half_space, sr
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

fn create_sepline(col_sizes []int, pad int) string {
	padding := pad * 2
	mut line := '+'
	for cs in col_sizes {
		line += '-'.repeat(cs + padding)
		line += '+'
	}
	return line
}

fn bold_cell(cell string) string {
	return '\e[1m$cell\e[0m'
}
