import 'package:posts/model/post_model.dart';

import '../exceptions/api_exception.dart';
import '../services/network_service.dart';

class MainRepository {
  NetworkService baseAPI = NetworkService();
  //This and other sensitive information should be store in the .env environment in real live application.
  String baseUrl = "https://jsonplaceholder.typicode.com/";
  Future<dynamic> fetchPosts() async {
    try {
      var response = await baseAPI.getRequest("${baseUrl}posts");

      List<Post> posts =
          List<Post>.from(response.data.map((x) => Post.fromJson(x)));
      return posts;
    } catch (e) {
      throw AppException(e.toString(), "");
    }
  }
}
