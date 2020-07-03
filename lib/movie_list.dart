import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  MovieListState createState() {
    return new MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  var movies;
  Color mainColor = const Color(0xff3C3261);

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var data = await getJson();
    setState(() {
      movies = data['results'];
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.3,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: new Text(
          'Movies',
          style: new TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            new Center(
              child:
              movies == null?
                  Center(child: Text('Please wait...'),)
                  :
              new GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: movies == null ? 0 : movies.length,
                  itemBuilder: (context, i) {
                    return GridTile(child: new GestureDetector(
                      child: new MovieCell(movies, i),
                      onTap: () {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                              return new MovieDetail(movies[i]);
                            }));
                      },
                    ),);
                  }),
            )
      ),
    );
  }
}

Future<Map> getJson() async {
  var url= 'url';
  var response = await http.get(url);
  return json.decode(response.body);
}

class MovieTitle extends StatelessWidget {
  final Color mainColor;

  MovieTitle(this.mainColor);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: new Text(
        'Top Rated',
        style: new TextStyle(
            fontSize: 40.0,
            color: mainColor,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class MovieCell extends StatelessWidget {
  final movies;
  final i;
  Color mainColor = const Color(0xff3C3261);
  var imageUrl = 'https://image.tmdb.org/t/p/w500/';
  MovieCell(this.movies, this.i);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        child:
      Center(
        child:
        new Column(
          children: <Widget>[
            new Expanded(
              flex:1,
              child: new Container(
              margin: const EdgeInsets.all(10.0),
              child: new Container(
                width: MediaQuery.of(context).size.width/2,
              ),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10.0),
                image: new DecorationImage(
                    image: new NetworkImage(
                        imageUrl + movies[i]['poster_path']),
                    fit: BoxFit.cover),
                boxShadow: [
                  new BoxShadow(
                      color: mainColor,
                      blurRadius: 5.0,
                      offset: new Offset(2.0, 5.0))
                ],
              ),
            ),),
            new Expanded(flex:0, child: new Text(
              movies[i]['title'],
              style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: mainColor),
              )
            ),
          ],
        )
    ),);
  }
}
