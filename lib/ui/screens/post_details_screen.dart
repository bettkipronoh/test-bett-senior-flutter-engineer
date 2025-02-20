import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts/bloc/comments_bloc/comments_bloc.dart';
import 'package:posts/bloc/posts_bloc/posts_bloc.dart';
import 'package:posts/model/comment.dart';
import 'package:posts/model/post_model.dart';
import 'package:posts/ui/widgets/custom_card.dart';
import 'package:posts/ui/widgets/loading_shimmer.dart';
import 'package:posts/utilities/extensions.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  Post? argument;
  bool _isInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Post) {
        argument = args;

        _fetchComments();
      }
      _isInitialized = true;
    }
  }

  _fetchComments() {
    if (argument?.id != null) {
      context.read<CommentsBloc>().add(FetchCommentsEvent(argument!.id!));
      scrollToTop();
    }
  }

  bool _commentsExpanded = true;
  final ScrollController _scrollController = ScrollController();

  void scrollToTop() {
    try {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 500), // Adjust speed
          curve: Curves.easeInOut, // Smooth animation
        );
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: CustomCard(
        color: Colors.white,
        radius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  argument?.title != null ? argument!.title!.capitalize() : '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${argument?.body?.trim().capitalize()}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              BlocBuilder<CommentsBloc, CommentsState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                  "Comments ${state is SuccessFetchingCommentsState ? '${state.comments.length}' : ''}"),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _commentsExpanded = !_commentsExpanded;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                ),
                                child: Icon(_commentsExpanded
                                    ? Icons.keyboard_arrow_up_outlined
                                    : Icons.keyboard_arrow_down_outlined),
                              ),
                            )
                          ],
                        ),
                        if (_commentsExpanded &&
                            state is! ErrorFetchingCommentsState)
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: state is SuccessFetchingCommentsState
                                ? state.comments.length
                                : 2,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                state is SuccessFetchingCommentsState
                                    ? _commentCard(state.comments[index])
                                    : LoadingShimmer(),
                          ),
                        if (state is ErrorFetchingCommentsState)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              state.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.redAccent,
                                  ),
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16,
                  right: 16,
                ),
                child: Text(
                  'Other Posts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              BlocBuilder<PostsBloc, PostsState>(
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state is SuccessFetchingPostsState
                        ? state.response.length
                        : 10,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        thickness: 0.2,
                      ),
                    ),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        argument = state is SuccessFetchingPostsState
                            ? state.response[index]
                            : null;
                        _fetchComments();
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4.0),
                        child: Text(
                          '${state is SuccessFetchingPostsState ? state.response[index].title?.capitalize() : ''}',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget _commentCard(Comment comment) {
    Color bgColor = getRandomPrimaryColor();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomCard(
              shape: BoxShape.circle,
              color: bgColor.withValues(alpha: 0.2),
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '${comment.name?.getInitials().toUpperCase()}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: bgColor,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${comment.name?.capitalize()}',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Text(
                '${comment.body?.capitalize()}',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Color getRandomPrimaryColor() {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1, // Full opacity
    );
  }
}
