import 'package:book_club/screens/author_details_screen.dart';
import 'package:book_club/model/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookInfo bookInfo;

  const BookDetailsScreen({Key key, this.bookInfo}) : super(key: key);

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: CachedNetworkImage(
                  imageUrl: widget.bookInfo.thumbnail ?? "",
                  imageBuilder: (context, imageProvider) => Container(
                    width: 140,
                    height: 210,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 140,
                    height: 0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.bookInfo.title ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24.0),
//                      textAlign: TextAlign.center,
                        ),
                      ),
                      widget.bookInfo.subtitle != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                widget.bookInfo.subtitle ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
//                    textAlign: TextAlign.center,
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: InkWell(
                          onTap: () => _navigateToAuthorDetails(
                              widget.bookInfo.authors[0]),
                          child: Text(
                            widget.bookInfo.authors?.toString() ?? "",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.blueGrey,
          ),
          Expanded(
            child: widget.bookInfo.description != null
                ? SingleChildScrollView(
                    child: Html(
                      data: widget.bookInfo.description,
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  _navigateToAuthorDetails(String author) {
    Navigator.of(context).push(
      MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: AuthorDetailsScreen(
              author: author,
            ),
          );
        },
      ),
    );
  }
}
