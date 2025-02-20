part of 'comments_bloc.dart';

@immutable
sealed class CommentsEvent {}

class FetchCommentsEvent extends CommentsEvent {
  final int postId;
  FetchCommentsEvent(this.postId);
}
