module termtable

import encoding.utf8

const (
	empty_line = Sepline{
		left: ''
		right: ''
		cross: ''
		sep: ''
	}
)

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
	tabsize      int = 4
}

struct Sepline {
pub mut:
	left  string = '+'
	right string = '+'
	cross string = '+'
	sep   string = '-'
}

struct StyleConfig {
pub mut:
	style        Style = .grid
	topline      Sepline = Sepline{}
	headerline   Sepline = Sepline{}
	middleline   Sepline = Sepline{}
	bottomline   Sepline = Sepline{}
	col_sep      string = '|'
	fill_padding bool = true
}

pub fn (t Table) str() string {
	edata := expand_tabs(t.data, t.tabsize)
	rowdata, coldata := get_row_and_col_data(edata, t.orientation)
	colmaxes := max_column_sizes(coldata)
	mut rowstrings := []string{}
	border := get_border(t.style)
	for i, row in rowdata {
		mut styled_row := row.clone()
		if t.orientation == .column || i == 0 {
			styled_row = apply_header_style(row, t.header_style, t.orientation)
		}
		rspace := get_row_spaces(row, colmaxes)
		rowstrings << row_to_string(styled_row, rspace, t.align, t.padding, border)
	}
	topline := create_sepline(.top, colmaxes, t.padding, border)
	headline := create_sepline(.header, colmaxes, t.padding, border)
	sepline := create_sepline(.middle, colmaxes, t.padding, border)
	bottomline := create_sepline(.bottom, colmaxes, t.padding, border)
	mut final_str := topline
	for i, row_str in rowstrings {
		final_str += '$row_str\n'
		if i == 0 && rowstrings.len >= 2 {
			final_str += headline
		} else if i < rowstrings.len - 1 {
			final_str += sepline
		}
	}
	final_str += bottomline
	return final_str.trim_space()
}

fn expand_tabs(raw_data [][]string, tabsize int) [][]string {
	mut edata := [][]string{}
	for d in raw_data {
		mut ed := []string{}
		for c in d {
			mut ec := c.clone()
			tabs := ec.count('\t')
			for _ in 0 .. tabs {
				tpos := ec.index_old('\t')
				spaces := tabsize - (tpos % tabsize)
				ec = ec.replace_once('\t', ' '.repeat(spaces))
			}
			ed << ec
		}
		edata << ed
	}
	return edata
}

fn get_row_and_col_data(data [][]string, orient Orientation) ([][]string, [][]string) {
	mut other_data := [][]string{}
	for i in 0 .. data[0].len {
		mut od := []string{}
		for d in data {
			od << d[i]
		}
		other_data << od
	}
	if orient == .row {
		return data, other_data
	} else {
		return other_data, data
	}
}

fn max_column_sizes(columns [][]string) []int {
	mut colmaxes := []int{len: columns.len, init: 0}
	for i, col in columns {
		for c in col {
			len := utf8.len(c)
			if len > colmaxes[i] {
				colmaxes[i] = len
			}
		}
	}
	return colmaxes
}

fn get_border(style Style) StyleConfig {
	mut sc := StyleConfig{
		style: style
	}
	match style {
		.grid {}
		.plain {
			sc.topline = empty_line
			sc.headerline = empty_line
			sc.middleline = empty_line
			sc.bottomline = empty_line
			sc.col_sep = ' '
		}
		.simple {
			sc.topline = empty_line
			sc.middleline = empty_line
			sc.bottomline = empty_line
			sc.headerline = Sepline{
				left: ''
				right: ''
				cross: ' '
			}
			sc.col_sep = ' '
			sc.fill_padding = false
		}
		.pretty {
			sc.middleline = empty_line
		}
		.github {
			sc.topline = empty_line
			sc.middleline = empty_line
			sc.bottomline = empty_line
			sc.headerline = Sepline{
				left: '|'
				right: '|'
				cross: '|'
				sep: '-'
			}
			sc.col_sep = '|'
		}
		.fancy_grid {
			sc.topline = Sepline{
				left: '╒'
				right: '╕'
				cross: '╤'
				sep: '═'
			}
			sc.headerline = Sepline{
				left: '╞'
				right: '╡'
				cross: '╪'
				sep: '═'
			}
			sc.middleline = Sepline{
				left: '├'
				right: '┤'
				cross: '┼'
				sep: '─'
			}
			sc.bottomline = Sepline{
				left: '╘'
				right: '╛'
				cross: '╧'
				sep: '═'
			}
			sc.col_sep = '│'
		}
	}
	return sc
}

fn apply_header_style(row []string, style HeaderStyle, orient Orientation) []string {
	if style == .plain {
		return row
	}
	if orient == .column {
		mut r := ['\e[1m${row[0]}\e[0m']
		r << row[1..]
		return r
	}
	return row.map('\e[1m$it\e[0m')
}

fn get_row_spaces(row []string, col_sizes []int) []int {
	mut rspace := []int{}
	for i, cell in row {
		rspace << col_sizes[i] - utf8.len(cell)
	}
	return rspace
}

fn row_to_string(row []string, rspace []int, align Alignment, padding int, sc StyleConfig) string {
	mut final_row := row.clone()
	pad := ' '.repeat(padding)
	mut rstr := sc.col_sep + pad
	for i, cell in final_row {
		sl, sr := cell_space(rspace[i], align)
		rstr += ' '.repeat(sl) + cell + ' '.repeat(sr)
		rstr += pad + sc.col_sep + pad
	}
	return rstr.trim_space()
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

fn create_sepline(pos SeplinePos, col_sizes []int, pad int, sc StyleConfig) string {
	padding := pad * 2
	sl_cfg := match pos {
		.top { sc.topline }
		.header { sc.headerline }
		.middle { sc.middleline }
		.bottom { sc.bottomline }
	}
	mut line := sl_cfg.left
	for i, cs in col_sizes {
		if sc.fill_padding {
			line += sl_cfg.sep.repeat(cs + padding)
		} else {
			line += sl_cfg.sep.repeat(cs)
			line += ' '.repeat(padding)
		}
		if i < col_sizes.len - 1 {
			line += sl_cfg.cross
		}
	}
	line += sl_cfg.right
	line = line.trim_space()
	if line.len == 0 {
		return ''
	}
	if pos != .bottom {
		line += '\n'
	}
	return line
}
