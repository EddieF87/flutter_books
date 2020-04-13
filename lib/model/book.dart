class Book {
  final String id;
  final String etag;
  final BookInfo info;

  Book({
    this.id,
    this.etag,
    this.info,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    print("uuuuu $json");
    var book = Book(
      id: json['id'],
      etag: json['etag'],
      info: BookInfo.fromJson(json['volumeInfo']),
    );
    return book;
  }
}

class BookInfo {
  final String title;
  final String subtitle;
  final String description;
  final String publishedDate;
  final String infoLink;
  final int pageCount;
  final List<dynamic> authors;
  final List<dynamic> categories;

  final String thumbnail;
  final String smallThumbnail;

  BookInfo({
    this.title,
    this.subtitle,
    this.description,
    this.publishedDate,
    this.pageCount,
    this.authors,
    this.categories,
    this.thumbnail,
    this.smallThumbnail,
    this.infoLink,
  });

  factory BookInfo.fromJson(Map<String, dynamic> json) {
    var imageLinks = json['imageLinks'] ?? json;
    return BookInfo(
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      publishedDate: json['publishedDate'],
      pageCount: json['pageCount'],
      authors: json['authors'],
      categories: json['categories'],
      thumbnail: imageLinks['thumbnail'],
      smallThumbnail: imageLinks['smallThumbnail'],
      infoLink: json['infoLink'],
    );
  }
}
