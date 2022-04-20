import os
import term
import json
import prettyprint as pp

struct Book{
	mut:
		author string
		title string
		year int
		genre string
}

fn main(){

	mut library := []Book{}
	mut choice := -1
	mut temp := Book{"null", "null", 0, "null"}
	mut found := -1

	println('Hi and welcome to the library!')

	for choice != 0{

		term.clear()

		println('Please choose what you want to do: ')
		println('1. Add a book')
		println('2. Modify a book')
		println('3. Delete a book')
		println('4. Search a book')
		println('5. Check the library content')
		println('0. Exit')

		choice = os.input('Enter your choice: ').int()

		term.clear()

		if choice == 1{

			println("Ok let's start adding the book")
			temp = add(mut library)
			library << temp

		}

		if choice == 2{

			mod(mut library)

		}

		if choice == 3{

			del(mut library)

		}

		if choice == 4{

			found = src(mut library)
			if found != -1{
				term.clear()
				println('Book found!')
				println(library[found])
			}

		}

		if choice == 5{

			list(mut library)

		}

		println("")
		os.input('Press enter to continue...')

		save(mut library)

	}

}

fn list(mut library []Book){

	if library.len < 1{
		println('The library is empty!')
	}
	else{
		for mut b in library{
			book(mut b)
		}
	}

}

fn create_temp(author string, title string, year int, genre string) Book{

	temp:= Book{author, title, year, genre}

	return temp

}

fn add(mut library []Book) Book{

	author := os.input("Who is the author of the book? ")
	title := os.input("What is the title of the book? ")
	year := os.input("When was it released? ").int()
	genre := os.input("What is the genre of the book? ")

	temp := create_temp(author, title, year, genre)

	return temp

}

fn src(mut library []Book) int{

	println("Ok let's search the book")
	temp := add(mut library)
	mut found := -1
	mut i := 0

	for mut book in library{

		if book.author == temp.author{
			if book.title == temp.title{
				if book.year == temp.year{
					if book.genre == temp.genre{
						found = i
					}
				}
			}
		}

		if found == -1{
			i++
		}

	}

	return found

}

fn del(mut library []Book){

	mut found := src(mut library)

	if found != -1{

		term.clear()
		println("Book found!")
		book(mut library[found])
		library.delete(found)

	}

}

fn mod(mut library []Book){

	mut found := src(mut library)

	if found != -1{

		term.clear()
		println('Book found!')
		book(mut library[found])

		mut choice := -1

		for choice != 0{

			println('Which characteristic do you wanna change?')
			println("1. Author")
			println("2. Title")
			println("3. Year")
			println("4. Genre")
			println("0. Exit")

			choice = os.input('Enter your choice: ').int()

			if choice == 1{
				library[found].author = os.input('Enter the new author: ')
			}

			if choice == 2{
				library[found].title = os.input('Enter the new title: ')
			}

			if choice == 3{
				library[found].year = os.input('Enter the new year of release: ').int()
			}

			if choice == 4{
				library[found].genre = os.input('Enter the new genre: ')
			}
		}

	}

}

fn book(mut temp Book){

	println("Author: $temp.author")
	println("Title: $temp.title")
	println("Year: $temp.year")
	println("Genre: $temp.genre")

}

fn save(mut library []Book){

	mut file_path := './data/library.json'
	mut json_library := json.encode(library)

	println(json_library)

	if !os.exists(file_path){
		os.create(file_path) or{
			eprintln('Failed to create a file')
			return
		}
	}

	os.write_file(file_path, json_library) or {
		eprintln('Failed to write')
		return
	}

}