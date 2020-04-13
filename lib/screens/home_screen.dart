import 'dart:convert';
import 'package:book_club/views/book_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/book.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Book>> futureBooks;
  List<Book> queriedBooks;
  List<Book> userBooks;
  Future<DocumentSnapshot> userName;

  Widget appBarTitle = new Text(
    "original appBarTitle",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    var userId = "zx8wVEDG0vd4Sn4dUFnT";
    futureBooks = fetchUsersBooks(userId);
    userName = fetchTest(userId);

    _searchQuery.addListener(() {
      if (_searchQuery.text.isNotEmpty) {
        search(_searchQuery.text);
      }
    });
    setAppBarTitle();
  }

  Future<List<Book>> fetchBooksByQuery(String query) async {
    final response =
        await http.get('https://www.googleapis.com/books/v1/volumes?q=$query');
    return json
        .decode(response.body)['items']
        .map<Book>((json) => Book.fromJson(json))
        .toList();
  }

  Future<List<Book>> fetchUsersBooks(String userId) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("books")
        .getDocuments();

    List<Book> books = List();

    for (var doc in querySnapshot.documents) {
      String id = doc.data["id"];
      books.add(await getBookById(id));
    }

    userBooks = books;
    return books;
  }

  Future<List<Book>> fake() async => userBooks;

  Future<Book> getBookById(String bookId) async {
    final response =
        await http.get('https://www.googleapis.com/books/v1/volumes/$bookId');
    return Book.fromJson(json.decode(response.body));
  }

  Future<DocumentSnapshot> fetchTest(String userId) async =>
      await Firestore.instance.collection("users").document(userId).get();

  void search(String query) {
    setState(() {
      futureBooks = fetchBooksByQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: appBarTitle,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder<DocumentSnapshot>(
            future: userName,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text("xx ${snapshot.data.data["name"]}");
              }
              return Text("waaaait");
            },
          ),
          FutureBuilder<List<Book>>(
            future: futureBooks,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => search("better"),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void setAppBarTitle() {
    setState(() {
      this.appBarTitle = FutureBuilder<DocumentSnapshot>(
          future: userName,
          builder: (context, snapshot) {
            return new Text(
              snapshot.hasData ? snapshot.data.data["name"] : "setAppBarTitle",
              style: new TextStyle(color: Colors.white),
            );
          });
    });
  }

  void _handleSearchEnd() {
    setState(() {
      futureBooks = fake();
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = FutureBuilder<DocumentSnapshot>(
          future: userName,
          builder: (context, snapshot) {
            return new Text(
              snapshot.hasData
                  ? snapshot.data.data["name"]
                  : "_handleSearchEnd",
              style: new TextStyle(color: Colors.white),
            );
          });
      _isSearching = false;
      _searchQuery.clear();
    });
  }
}
