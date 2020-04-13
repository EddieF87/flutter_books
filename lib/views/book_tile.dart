import 'package:book_club/model/book.dart';
import 'package:book_club/screens/book_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookTile extends StatefulWidget {
  final Book book;

  const BookTile({Key key, this.book}) : super(key: key);

  @override
  _BookTileState createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: GridTile(
        footer: Container(
          padding: EdgeInsets.all(2.0),
          color: Colors.white.withOpacity(.8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.book.info.title,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
//              IconButton(
//                color: Colors.red,
//                padding: EdgeInsets.all(0.0),
//                iconSize: 6.0,
//                icon: Icon(
//                  Icons.thumb_up,
//                  color: Colors.green.withOpacity(_liked ? 1 : .2),
//                ),
//                onPressed: () {
//                  setState(() => _liked = !_liked);
//                },
//              )
            ],
          ),
        ),
        child: InkWell(
          splashColor: Colors.green,
          onTap: () => _navigateToBookDetails(widget.book.info),
          child: CachedNetworkImage(
            imageUrl: widget.book.info.thumbnail ?? "",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            placeholder: (context, url) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _navigateToBookDetails(BookInfo bookInfo) {
    Navigator.of(context).push(
      MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: BookDetailsScreen(
              bookInfo: bookInfo,
            ),
          );
        },
      ),
    );
  }
}
