import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:posts/repositories/main_repository.dart';

import '../../model/comment.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    MainRepository repository = MainRepository();
    on<FetchCommentsEvent>((event, emit) async {
      emit(FetchingCommentsState());
      try {
        List<Comment> comments = await repository.fetchComments(event.postId);
        emit(SuccessFetchingCommentsState(comments));
      } catch (e) {
        emit(ErrorFetchingCommentsState("$e"));
      }
    });
  }
}
