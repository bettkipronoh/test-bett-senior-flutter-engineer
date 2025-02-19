part of 'posts_bloc.dart';

@immutable
sealed class PostsState {}

final class PostsInitial extends PostsState {}

final class FetchingPostsState extends PostsState {}

//State when there is an error fetching the posts
final class ErrorFetchingPostsState extends PostsState {
  final String message;
  ErrorFetchingPostsState(this.message);
}

//State when there is an error fetching the posts
final class SuccessFetchingPostsState extends PostsState {
  final List<Post> response;
  SuccessFetchingPostsState(this.response);
}
