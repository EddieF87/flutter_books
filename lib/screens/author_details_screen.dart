import 'dart:convert';
import 'package:book_club/views/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../model/book.dart';

class AuthorDetailsScreen extends StatefulWidget {
  final String author;

  const AuthorDetailsScreen({Key key, this.author}) : super(key: key);

  @override
  _AuthorDetailsState createState() => _AuthorDetailsState();
}

class _AuthorDetailsState extends State<AuthorDetailsScreen> {
  Future authorBooks;

  @override
  void initState() {
    super.initState();
    authorBooks = fetchAuthorBooks(widget.author);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: authorBooks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height),
              crossAxisCount: 4,
            ),
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final book = snapshot.data[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: BookTile(
                  book: book,
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<Book>> fetchAuthorBooks(String author) async {
    final response = await http.get(
        'https://www.googleapis.com/books/v1/volumes?q=inauthor:$author&maxResults=40');
    return json
        .decode(response.body)['items']
        .map<Book>((json) => Book.fromJson(json))
        .toList();
  }
}
