# V Terminal Tables
![CI](https://github.com/serkonda7/termtable/workflows/CI/badge.svg?branch=master)

Simple and highly customizable library to display tables in the terminal.

Some of the main features are:
- Allow choosing from a total of six predefined [styles](#style)
- Tab support _(each tab will be expanded to four spaces)_

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
		// The following settings are optional. These are their default values:
		style: .grid
		header_style: .bold
		align: .left
		orientation: .row
		padding: 1
	}
	println(t)
}

/* Output
+--------+-----+--------+
| Name   | Age | Sex    |
+--------+-----+--------+
| Max    | 13  | male   |
+--------+-----+--------+
| Moritz | 12  | male   |
+--------+-----+--------+
| Lisa   | 42  | female |
+--------+-----+--------+
*/
```

## Configuration Options
### Style
Supported values for `style: ...` are:
- .grid
- .pretty
- .plain
- .simple
- .github
- .fancy_grid

`.grid` (default):
```
+--------+-----+--------+
| Name   | Age | Sex    |
+--------+-----+--------+
| Max    | 13  | male   |
+--------+-----+--------+
| Moritz | 12  | male   |
+--------+-----+--------+
| Lisa   | 42  | female |
+--------+-----+--------+
```

`.pretty`:
```
+--------+-----+--------+
| Name   | Age | Sex    |
+--------+-----+--------+
| Max    | 13  | male   |
| Moritz | 12  | male   |
| Lisa   | 42  | female |
+--------+-----+--------+
```

`.plain`:
```
Name    Age  Sex
Max     13   male
Moritz  12   male
Lisa    42   female
```

`.simple`:
```
Name    Age  Sex
------  ---  ------
Max     13   male
Moritz  12   male
Lisa    42   female
```

`.github`:
```
| Name   | Age | Sex    |
|--------|-----|--------|
| Max    | 13  | male   |
| Moritz | 12  | male   |
| Lisa   | 42  | female |
```

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

/* orientation: .row (default)
+--------+-----+
| Name   | Age |
+--------+-----+
| Max    | 13  |
+--------+-----+
| Moritz | 12  |
+--------+-----+
*/

/* orientation: .column
+------+-----+--------+
| Name | Max | Moritz |
+------+-----+--------+
| Age  | 13  | 12     |
+------+-----+--------+
*/
```


### Padding
Control the count of spaces between the cell border and the item.
```v
// padding: ...
|   Lisa   |   42   |   female   |  // 3

| Lisa | 42 | female |  // 1 (default)

|Lisa|42|female|  // 0
```


## License
Licensed under the [MIT License](LICENSE.md)
