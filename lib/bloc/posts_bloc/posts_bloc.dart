import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:posts/model/post_model.dart';
import 'package:posts/repositories/main_repository.dart';

import '../../services/post_db.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    MainRepository repository = MainRepository();
    on<FetchPostsEvent>((event, emit) async {
      emit(FetchingPostsState());
      try {
        List<Post> posts = await repository.fetchPosts(event.start);
        emit(SuccessFetchingPostsState(posts));
      } catch (e) {
        List<Post> posts = PostDB.getAllPosts();
        emit(ErrorFetchingPostsState(
          message: "$e",
          posts: posts,
        ));
      }
    });
  }
}
