# V Terminal Tables
![CI](https://github.com/serkonda7/termtable/workflows/CI/badge.svg?branch=master)

Simple but flexible module to display tables in the terminal.


## Installation
`v install serkonda7.termtable`


## Usage
```v
import termtable

fn main() {
	rowdata := [
		['Name', 'Age', 'Sex'],
		['Max', '13', 'male'],
		['Moritz', '12', 'male'],
    ['Lisa', '42', 'female'],
	]
	t := termtable.Table{ rowdata }
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


## License
Licensed under the [MIT License](LICENSE.md)
