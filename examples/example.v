import serkonda7.termtable as tt

fn main() {
	t := tt.Table{
		data: [
			['Name', 'Age', 'Sex'],
			['Max', '13', 'male'],
			['Moritz', '12', 'male'],
			['Lisa', '42', 'female'],
		]
	}
	println(t)
}
