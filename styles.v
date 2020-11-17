module termtable

const (
	gridline      = Sepline{
		left: '+'
		right: '+'
		cross: '+'
		sep: '-'
	}
	style_configs = {
		'grid': StyleConfig{
			topline: gridline
			headerline: gridline
			middleline: gridline
			bottomline: gridline
			col_sep: '|'
		}
		'plain': StyleConfig{}
		'simple': StyleConfig{
			headerline: Sepline{
				cross: ' '
				sep: '-'
			}
			fill_padding: false
		}
		'pretty': StyleConfig{
			topline: gridline
			headerline: gridline
			bottomline: gridline
			col_sep: '|'
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
			col_sep: '│'
		}
		'markdown': StyleConfig{
			headerline: Sepline{
				left: '|'
				right: '|'
				cross: '|'
				sep: '-'
			}
			col_sep: '|'
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
	markdown
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
	col_sep      string = ' '
	fill_padding bool = true
}

fn get_style_config(style Style) StyleConfig {
	return style_configs[style.str()]
}
