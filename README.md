# V Terminal Tables
![CI](https://github.com/serkonda7/termtable/workflows/CI/badge.svg?branch=master)

Simple and highly customizable library to display tables in the terminal.


## Features
- Choose from six predefined [styles](#predefined-styles)
- Or create any [custom style](#creating-custom-styles) you want 
- [Tab support](#tabsize)


## Installation
`v install serkonda7.termtable`


## Usage
```v
import serkonda7.termtable

fn main() {
	data := [
		['Name', 'Age', 'Sex'],
		['Max', '13', 'male'],
		['Moritz', '12', 'male'],
		['Lisa', '42', 'female'],
	]
	t := termtable.Table{
		data: data
		// The following settings are optional and have these defaults:
		style: .grid
		header_style: .bold
		align: .left
		orientation: .row
		padding: 1
		tabsize: 4
	}
	println(t)
}
```


### Predefined Styles
Supported values for `style: ...` are:
- .grid
- .pretty
- .plain
- .simple
- .github
- .fancy_grid

`.grid` (default):

![](img/grid_preview.png)

`.pretty`:

![](img/pretty_preview.png)

`.plain`:

![](img/plain_preview.png)

`.simple`:

![](img/simple_preview.png)

`.github`:

![](img/github_preview.png)

`.fancy_grid`:

![](img/fancy_grid_preview.png)


### Header Style
```v
// header_style: ...
```
| `.bold (default)` | `.plain` |
| --- | --- |
| ![](img/headers_bold.png) | ![](img/headers_plain.png) |


### Alignment
```v
// align: ...
| Max    | 13  | male   |  // .left (default)
|  Max   | 13  |  male  |  // .center
|    Max |  13 |   male |  // .right
```


### Orientation
```v
t := termtable.Table{
	data: [
		['Name', 'Age'],
		['Max', '13'],
		['Moritz', '12'],
	]
	// orientation: ...
}
println(t)
```
| `.row (default)` | `.column` |
| --- | --- |
| ![](img/orientation_row.png) | ![](img/orientation_column.png) |


### Padding
Control the count of spaces between the cell border and the item.
```v
// padding: ...
|   Lisa   |   42   |   female   |  // 3

| Lisa | 42 | female |  // 1 (default)

|Lisa|42|female|  // 0
```


### Tabsize
```v
t := termtable.Table{
	data: [
		['\tName', 'Sex\t\t'],
		['1.\tMax', 'male\t'],
		['2. Moritz', 'male'],
	]
	// tabsize: ...
}
println(t)

/* 4 (default)
+-----------+----------+
|     Name  | Sex      |
+-----------+----------+
| 1.  Max   | male     |
+-----------+----------+
*/

/* 2
+-----------+--------+
|   Name    | Sex    |
+-----------+--------+
| 1.  Max   | male   |
+-----------+--------+
*/
```


### Creating Custom Styles
To create a custom style set the tables style property to `style: .custom`
and specify `custom_style: termtable.StyleConfig{...}`.

#### `StyleConfig` Struct
```v
topline      termtable.Sepline{...}
headerline   termtable.Sepline{...}
middleline   termtable.Sepline{...}
bottomline   termtable.Sepline{...}
col_sep      string = ' '
fill_padding bool = true
```

#### `Sepline` Struct
```v
left  string
right string
cross string
sep   string
```


## License
Licensed under the [MIT License](LICENSE.md)
