# V Terminal Tables
![CI](https://github.com/serkonda7/termtable/workflows/CI/badge.svg?branch=master)

Simple but flexible module to display tables in the terminal.


## Installation
`v install serkonda7.termtable`


## Usage
```v
import termtable

fn main() {
	data := [
		['Name', 'Age', 'Sex'],
		['Max', '13', 'male'],
		['Moritz', '12', 'male'],
		['Lisa', '42', 'female'],
	]
	t := termtable.Table{ 
		data: data
		// The following settings are optional. Here I use the default values.
		orientation: .row
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
row_t := termtable.Table{
	data: [
		['Name', 'Age'],
		['Max', '13'],
		['Moritz', '12'],
	]
}
/* Output
+--------+-----+
| Name   | Age |
+--------+-----+
| Max    | 13  |
+--------+-----+
| Moritz | 12  |
+--------+-----+
*/
col_t := termtable.Table{
	data: [
		['Name', 'Age'],
		['Max', '13'],
		['Moritz', '12'],
	]
	orientation: .column
}
/* Output
+------+-----+--------+
| Name | Max | Moritz |
+------+-----+--------+
| Age  | 13  | 12     |
+------+-----+--------+
*/
```


### Alignment
```v
| Max    | 13  | male   |  // .left (default)
|  Max   | 13  |  male  |  // .center
|    Max |  13 |   male |  // .right
```


### Padding
Control the count of spaces between the cell border and the item.
```v
| Lisa | 42 | female |  // 1 (default)

|Lisa|42|female|  // 0

|   Lisa   |   42   |   female   |  // 3
```


## License
Licensed under the [MIT License](LICENSE.md)
