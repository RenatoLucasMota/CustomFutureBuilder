import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_hack/models/post.dart';

import '../widgets/custom_future_builder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<Post> _getPost() async {
    final dio = Dio();
    var response =
        await dio.get('https://jsonplaceholder.typicode.com/posts/1');
    return Post.fromJson(response.data);
  }

  late Future<Post> _loadPost;

  @override
  void initState() {
    _loadPost = _getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: CustomFutureBuilder<Post>(
          future: _loadPost,

          onEmpty: (context) {
            return Center(child: Text('Não há dados disponiveis'));
          },

          onComplete: (context, post) {
            return ListView(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  trailing: Icon(Icons.chevron_right),
                  title: Text(post.title),
                  subtitle: Text(post.body),
                ),
              ],
            );
          },

          onError: (context, error) {
            return Center(child: Text(error.message));
          },
          
          onLoading: (context) =>
              Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
