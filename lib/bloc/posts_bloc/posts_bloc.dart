import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posts/model/post_model.dart';
import 'package:posts/repositories/main_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    MainRepository repository = MainRepository();
    on<FetchPostsEvent>((event, emit) async {
      emit(FetchingPostsState());
      try {
        List<Post> posts = await repository.fetchPosts();
        emit(SuccessFetchingPostsState(posts));
      } catch (e) {
        emit(ErrorFetchingPostsState("$e"));
      }
    });
  }
}
