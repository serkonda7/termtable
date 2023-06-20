module termtable

pub enum Style {
	custom
	plain
	grid
	simple
	pretty
	fancy_grid
	md
	rst
}

pub struct Sepline {
pub mut:
	left  string
	right string
	cross string
	sep   string
}

pub struct StyleConfig {
pub mut:
	topline      Sepline
	headerline   Sepline
	middleline   Sepline
	bottomline   Sepline
	colsep       string
	fill_padding bool = true
}

fn get_style_config(style Style) StyleConfig {
	return style_configs[style.str()]
}
