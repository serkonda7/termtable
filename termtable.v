module termtable

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
	style        Style       = .grid
	header_style HeaderStyle = .bold
	orientation  Orientation = .row
	align        Alignment   = .left
	padding      int = 1
	tabsize      int = 4
	custom_style StyleConfig = StyleConfig{}
}

// str generates the string representation of the table.
pub fn (t Table) str() string {
	validate_table_properties(t) or {
		eprintln('termtable: $err')
		exit(1)
	}
	edata := expand_tabs(t.data, t.tabsize)
	rowdata, coldata := get_row_and_col_data(edata, t.orientation)
	colmaxes := max_column_sizes(coldata)
	mut rowstrings := []string{}
	sc := if t.style == .custom { t.custom_style } else { get_style_config(t.style) }
	for i, row in rowdata {
		mut styled_row := row.clone()
		if t.orientation == .column || i == 0 {
			styled_row = apply_header_style(row, t.header_style, t.orientation)
		}
		rspace := get_row_spaces(row, colmaxes)
		rowstrings << row_to_string(styled_row, rspace, t.align, t.padding, sc)
	}
	topline := create_sepline(.top, colmaxes, t.padding, sc)
	headline := create_sepline(.header, colmaxes, t.padding, sc)
	sepline := create_sepline(.middle, colmaxes, t.padding, sc)
	bottomline := create_sepline(.bottom, colmaxes, t.padding, sc)
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

fn validate_table_properties(t Table) ? {
	if t.data == [][]string{} {
		return error('Table.data should not be empty.')
	}
	if t.tabsize < 2 {
		return error('tabsize should be at least 2 (got $t.tabsize).')
	}
	if t.padding < 0 {
		return error('cannot use a negative padding (got $t.padding).')
	}
	if t.style == .custom {
		default_sc := StyleConfig{}
		if t.custom_style.str() == default_sc.str() {
			return error('please provide a value for `custom_style` if you use `style: .custom`.')
		}
	}
}

fn expand_tabs(raw_data [][]string, tabsize int) [][]string {
	mut edata := [][]string{}
	for d in raw_data {
		mut ed := []string{}
		for c in d {
			mut ec := c.clone()
			tabs := ec.count('\t')
			for _ in 0 .. tabs {
				tpos := ec.index('\t') or { 0 }
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
		for cell in col {
			len := utf8_str_visible_length(cell)
			if len > colmaxes[i] {
				colmaxes[i] = len
			}
		}
	}
	return colmaxes
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
		rspace << col_sizes[i] - utf8_str_visible_length(cell)
	}
	return rspace
}

fn row_to_string(row []string, rspace []int, align Alignment, padding int, sc StyleConfig) string {
	mut final_row := row.clone()
	pad := ' '.repeat(padding)
	mut rstr := sc.colsep + pad
	for i, cell in final_row {
		sl, sr := cell_space(rspace[i], align)
		rstr += ' '.repeat(sl) + cell + ' '.repeat(sr)
		rstr += pad + sc.colsep + pad
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
