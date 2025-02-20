import 'package:posts/model/comment.dart';
import 'package:posts/model/post_model.dart';

import '../exceptions/api_exception.dart';
import '../services/network_service.dart';
import '../services/post_db.dart';

class MainRepository {
  NetworkService baseAPI = NetworkService();
  //This and other sensitive information should be store in the .env environment in real live application.
  String baseUrl = "https://jsonplaceholder.typicode.com/";
  Future<dynamic> fetchPosts(int start) async {
    try {
      var response =
          await baseAPI.getRequest("${baseUrl}posts?_start=$start&_limit=10");

      List<Post> posts =
          List<Post>.from(response.data.map((x) => Post.fromJson(x)));
      for (Post newPost in posts) {
        await PostDB.savePost(newPost);
      }
      return posts;
    } catch (e) {
      throw AppException(e.toString(), "");
    }
  }

  Future<dynamic> fetchComments(int postId) async {
    try {
      var response =
          await baseAPI.getRequest("${baseUrl}posts/$postId/comments");

      List<Comment> posts =
          List<Comment>.from(response.data.map((x) => Comment.fromJson(x)));
      return posts;
    } catch (e) {
      throw AppException(e.toString(), "");
    }
  }
}
