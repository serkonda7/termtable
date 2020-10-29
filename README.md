# V Terminal Tables
![CI](https://github.com/serkonda7/termtable/workflows/CI/badge.svg?branch=master)

Simple but flexible module to display tables in the terminal.


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
		orientation: .row
		header_style: .bold
		align: .left
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
