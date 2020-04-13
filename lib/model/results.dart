import 'book.dart';

class Results {
  final List<Book> books;

  Results(this.books);

  factory Results.fromJson(Map<String, dynamic> json) {
    var items = json['items'];
    var books = List<Book>();
    for (var item in items) {
      books.add(Book.fromJson(item));
    }
    return Results(books);
  }
}
