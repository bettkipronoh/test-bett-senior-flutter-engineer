import 'package:hive_flutter/adapters.dart';

import '../model/post_model.dart';

class PostDB {
  static final Box<Post> _postBox = Hive.box<Post>('posts');

  /// Check if a post exists by ID
  static bool postExists(int postId) {
    return _postBox.values.any((post) => post.id == postId);
  }

  /// Save a post only if it doesn't exist
  static Future<void> savePost(Post post) async {
    if (!postExists(post.id!)) {
      await _postBox.add(post);
    }
  }

  /// Get all posts
  static List<Post> getAllPosts() {
    return _postBox.values.toList();
  }
}
