part of 'comments_bloc.dart';

@immutable
sealed class CommentsState {}

final class CommentsInitial extends CommentsState {}

class FetchingCommentsState extends CommentsState {}

class ErrorFetchingCommentsState extends CommentsState {
  final String message;
  ErrorFetchingCommentsState(this.message);
}

class SuccessFetchingCommentsState extends CommentsState {
  final List<Comment> comments;
  SuccessFetchingCommentsState(this.comments);
}
