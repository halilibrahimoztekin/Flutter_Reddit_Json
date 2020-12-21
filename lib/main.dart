import 'package:flutter/material.dart';
import 'models/reddit.dart';
import 'apis/reddit_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Post> _posts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReddit().then((posts) {
      setState(() {
        _posts = posts;
      });
    });
  }
List<Widget> buildListTiles(){
    return _posts.map((post) => ListTile(
      leading: CircleAvatar(
          child: Image.network(
            '${!post.thumbnail.contains(".jpg")&&!post.thumbnail.contains(".png") ? "http://via.placeholder.com/300" : post.thumbnail}',
            scale: 0.2,
          )),
      title: Text(' ${post.title} by ${post.author}'),
      subtitle: Text(
        'Subreddit: ${post.subreddit} with ${post.ups} upvotes',
      ),
    )).toList();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deneme"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getReddit().then((posts) {
            setState(() {
              _posts = posts;
            });
          });
        },
        child: AnimatedCrossFade(
          duration: Duration(milliseconds: 2000),
          firstChild: Center(
            child: CircularProgressIndicator(),
          ),
          secondChild: ListView(
            children: buildListTiles(),
          ),
          crossFadeState: _posts.isNotEmpty
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ),
    );
  }
}
