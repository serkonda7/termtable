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
		rowdata: data
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

### Alignment
```v
.left // (default)
// | Max    | 13  | male   |

.center
// |  Max   | 13  |  male  |

.right
// |    Max |  13 |   male |
```


## License
Licensed under the [MIT License](LICENSE.md)
