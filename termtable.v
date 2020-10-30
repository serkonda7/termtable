module termtable

pub enum Style {
	plain
}

pub enum HeaderStyle {
	plain
	bold
}

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
	data         [][]string
	// style       Style = .plain
	header_style HeaderStyle = .bold
	orientation  Orientation = .row
	align        Alignment = .left
	padding      int = 1
}

pub fn (t Table) str() string {
	rowdata, coldata := get_row_and_col_data(t.data, t.orientation)
	col_maxes := colmax(coldata)
	sepline := create_sepline(col_maxes, t.padding)
	mut rowstrings := []string{}
	for i, row in rowdata {
		mut styled_row := row.clone()
		if t.orientation == .row && i == 0 {
			styled_row = apply_header_style(row, t.header_style)
		} else if t.orientation == .column {
			styled_row[0] = apply_header_style(row, t.header_style)[0]
		}
		rspace := get_row_spaces(row, col_maxes)
		rowstrings << row_to_string(styled_row, rspace, t.align, t.padding)
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

fn colmax(columns [][]string) []int {
	mut col_maxes := []int{len: columns.len, init: 0}
	for i, col in columns {
		for c in col {
			if c.len > col_maxes[i] {
				col_maxes[i] = c.len
			}
		}
	}
	return col_maxes
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

fn row_to_string(row []string, rspace []int, align Alignment, padding int) string {
	mut final_row := row.clone()
	pad := ' '.repeat(padding)
	mut rstr := '|$pad'
	for i, cell in final_row {
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

fn apply_header_style(row []string, style HeaderStyle) []string {
	match style {
		.plain { return row }
		.bold { return row.map('\e[1m$it\e[0m') }
	}
}
