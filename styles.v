module termtable

const (
	gridline = Sepline{
		left: '+'
		right: '+'
		cross: '+'
		sep: '-'
	}
	style_configs = {
		'grid':       StyleConfig{
			topline: gridline
			headerline: gridline
			middleline: gridline
			bottomline: gridline
			colsep: '|'
		}
		'plain':      StyleConfig{
			colsep: ' '
		}
		'simple':     StyleConfig{
			headerline: Sepline{
				cross: ' '
				sep: '-'
			}
			fill_padding: false
			colsep: ' '
		}
		'pretty':     StyleConfig{
			topline: gridline
			headerline: gridline
			bottomline: gridline
			colsep: '|'
		}
		'fancy_grid': StyleConfig{
			topline: Sepline{
				left: '╒'
				right: '╕'
				cross: '╤'
				sep: '═'
			}
			headerline: Sepline{
				left: '╞'
				right: '╡'
				cross: '╪'
				sep: '═'
			}
			middleline: Sepline{
				left: '├'
				right: '┤'
				cross: '┼'
				sep: '─'
			}
			bottomline: Sepline{
				left: '╘'
				right: '╛'
				cross: '╧'
				sep: '═'
			}
			colsep: '│'
		}
		'md':         StyleConfig{
			headerline: Sepline{
				left: '|'
				right: '|'
				cross: '|'
				sep: '-'
			}
			colsep: '|'
		}
		'rst':        StyleConfig{
			topline: Sepline{
				left: ''
				right: ''
				cross: ''
				sep: '='
			}
			headerline: Sepline{
				left: ''
				right: ''
				cross: ''
				sep: '='
			}
			bottomline: Sepline{
				left: ''
				right: ''
				cross: ''
				sep: '='
			}
			fill_padding: false
		}
	}
)

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
	return termtable.style_configs[style.str()]
}
