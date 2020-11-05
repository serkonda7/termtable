module termtable

pub enum Style {
	plain
	grid
	simple
	pretty
	github
	fancy_grid
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

enum SeplinePos {
	top
	header
	middle
	bottom
}

pub struct Table {
pub mut:
	data         [][]string
	style        Style = .grid
	header_style HeaderStyle = .bold
	orientation  Orientation = .row
	align        Alignment = .left
	padding      int = 1
}

struct Border {
pub mut:
	style          Style = .grid
	top_left       string = '+'
	top_right      string = '+'
	top_row_sep    string = '-'
	bottom_right   string = '+'
	bottom_left    string = '+'
	bottom_row_sep string = '-'
	cross_top      string = '+'
	cross_right    string = '+'
	cross_bottom   string = '+'
	cross_left     string = '+'
	cross_center   string = '+'
	head_left      string = '+'
	head_row_sep   string = '-'
	head_cross     string = '+'
	head_right     string = '+'
	row_sep        string = '-'
	col_sep        string = '|'
	fill_padding   bool = true
}

pub fn (t Table) str() string {
	rowdata, coldata := get_row_and_col_data(t.data, t.orientation)
	col_maxes := colmax(coldata)
	mut rowstrings := []string{}
	border := get_border(t.style)
	for i, row in rowdata {
		mut styled_row := row.clone()
		if t.orientation == .row && i == 0 {
			styled_row = apply_header_style(row, t.header_style)
		} else if t.orientation == .column {
			styled_row[0] = apply_header_style(row, t.header_style)[0]
		}
		rspace := get_row_spaces(row, col_maxes)
		rowstrings << row_to_string(styled_row, rspace, t.align, t.padding, border)
	}
	topline := create_sepline(.top, col_maxes, t.padding, border)
	headline := create_sepline(.header, col_maxes, t.padding, border)
	sepline := create_sepline(.middle, col_maxes, t.padding, border)
	bottomline := create_sepline(.bottom, col_maxes, t.padding, border)
	mut final_str := topline
	for i, row_str in rowstrings {
		final_str += '$row_str\n'
		if i == 0 {
			final_str += headline
		} else if i < rowstrings.len - 1 {
			final_str += sepline
		}
	}
	final_str += bottomline
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

fn get_border(style Style) Border {
	mut b := Border{
		style: style
	}
	match style {
		.grid {}
		.plain {
			b.col_sep = ''
		}
		.simple {
			b.col_sep = ''
			b.head_left = ''
			b.head_right = ''
			b.head_cross = ''
			b.fill_padding = false
		}
		.pretty {}
		.github {
			b.head_cross = '|'
			b.head_left = '|'
			b.head_right = '|'
			b.cross_left = '|'
			b.cross_center = '|'
			b.cross_right = '|'
		}
		.fancy_grid {
			b.top_left = '╒'
			b.top_right = '╕'
			b.top_row_sep = '═'
			b.bottom_right = '╛'
			b.bottom_left = '╘'
			b.bottom_row_sep = '═'
			b.cross_top = '╤'
			b.cross_right = '┤'
			b.cross_bottom = '╧'
			b.cross_left = '├'
			b.cross_center = '┼'
			b.head_left = '╞'
			b.head_row_sep = '═'
			b.head_cross = '╪'
			b.head_right = '╡'
			b.row_sep = '─'
			b.col_sep = '│'
		}
	}
	return b
}

fn create_sepline(pos SeplinePos, col_sizes []int, pad int, b Border) string {
	if b.style == .plain {
		return ''
	}
	if b.style == .simple && pos != .header {
		return ''
	}
	if b.style == .pretty && pos == .middle {
		return ''
	}
	if b.style == .github && pos != .header {
		return ''
	}
	padding := pad * 2
	line_start := match pos {
		.top { b.top_left }
		.header { b.head_left }
		.middle { b.cross_left }
		.bottom { b.bottom_left }
	}
	cross := match pos {
		.top { b.cross_top }
		.header { b.head_cross }
		.middle { b.cross_center }
		.bottom { b.cross_bottom }
	}
	line_end := match pos {
		.top { b.top_right }
		.header { b.head_right }
		.middle { b.cross_right }
		.bottom { b.bottom_right }
	}
	rsep := match pos {
		.top { b.top_row_sep }
		.header { b.head_row_sep }
		.middle { b.row_sep }
		.bottom { b.bottom_row_sep }
	}
	mut line := line_start
	for i, cs in col_sizes {
		if b.fill_padding {
			line += rsep.repeat(cs + padding)
		} else {
			line += rsep.repeat(cs)
			line += ' '.repeat(padding)
		}
		if i < col_sizes.len - 1 {
			line += cross
		}
	}
	line += line_end
	line = line.trim_space()
	if pos != .bottom {
		line += '\n'
	}
	return line
}

fn row_to_string(row []string, rspace []int, align Alignment, padding int, b Border) string {
	mut final_row := row.clone()
	pad := ' '.repeat(padding)
	mut rstr := b.col_sep + pad
	for i, cell in final_row {
		sl, sr := cell_space(rspace[i], align)
		rstr += ' '.repeat(sl) + cell + ' '.repeat(sr)
		rstr += pad + b.col_sep + pad
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
