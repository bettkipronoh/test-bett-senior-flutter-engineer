import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:posts/bloc/connectivity/connectivity_cubit.dart';
import 'package:posts/bloc/posts_bloc/posts_bloc.dart';
import 'package:posts/model/post_model.dart';
import 'package:posts/services/post_db.dart';
import 'package:posts/ui/widgets/custom_button.dart';
import 'package:posts/ui/widgets/custom_card.dart';
import 'package:posts/ui/widgets/empty_list_widget.dart';
import 'package:posts/ui/widgets/loading_shimmer.dart';
import 'package:posts/utilities/extensions.dart';
import 'package:posts/utilities/snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController listScrollController;
  int _nextSart = 0;
  int _start = 0;
  @override
  void initState() {
    listScrollController = ScrollController()..addListener(_scrollListener);
    _fetchPosts();
    super.initState();
  }

  bool loadMore = false;
  _scrollListener() {
    if (listScrollController.position.maxScrollExtent ==
        listScrollController.offset) {
      loadMore = true;
    } else {
      loadMore = false;
    }
    setState(() {});
  }

  _fetchPosts() {
    if (_start < _nextSart || _nextSart == 0) {
      _start = _nextSart;
      context.read<PostsBloc>().add(FetchPostsEvent(_start));
    }
  }

  List<Post> _posts = [];
  List<Post> _cachedPosts = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PostsBloc, PostsState>(
          listener: (context, state) {
            if (state is SuccessFetchingPostsState) {
              _nextSart = _nextSart + state.response.length;
              _posts.addAll(state.response);
              loadMore = false;
              setState(() {});
            }

            if (state is ErrorFetchingPostsState) {
              _cachedPosts = state.posts;
              _nextSart = 10;
              _start = 0;
              setState(() {});
              showSnackBar(context, state.message, err: true);
            }
          },
        ),
        BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            if (state is CurrentConnectivityStatus &&
                state.status == InternetStatus.connected) {
              PostsState postState = context.read<PostsBloc>().state;
              if (postState is ErrorFetchingPostsState ||
                  postState is PostsInitial) {
                _fetchPosts();
              }
            } else if (state is CurrentConnectivityStatus &&
                state.status == InternetStatus.disconnected) {
              _cachedPosts = PostDB.getAllPosts();
              setState(() {});
            }
          },
        ),
      ],
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          return BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, connectivityState) {
              return Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body: CustomMaterialIndicator(
                  onRefresh: () async {
                    _start = 0;
                    _nextSart = 0;
                    _posts.clear();
                    setState(() {});
                    _fetchPosts();
                  }, // Your refresh logic
                  backgroundColor: Colors.white,
                  indicatorBuilder: (context, controller) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        value: controller.state.isLoading
                            ? null
                            : min(controller.value, 1.0),
                      ),
                    );
                  },
                  child: SafeArea(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "Posts",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: CustomCard(
                          color: Colors.white,
                          radius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: (state is ErrorFetchingPostsState &&
                                      state.posts.isEmpty) ||
                                  (_cachedPosts.isEmpty &&
                                      connectivityState
                                          is CurrentConnectivityStatus &&
                                      connectivityState.status ==
                                          InternetStatus.disconnected)
                              ? EmptyWidget(
                                  description: connectivityState
                                              is CurrentConnectivityStatus &&
                                          connectivityState.status ==
                                              InternetStatus.disconnected
                                      ? "No internet connection"
                                      : state is ErrorFetchingPostsState
                                          ? state.message
                                          : "",
                                  image:
                                      "assets/lottie/${connectivityState is CurrentConnectivityStatus && connectivityState.status == InternetStatus.disconnected ? 'connection' : 'empty'}.json",
                                  onClick: connectivityState
                                              is CurrentConnectivityStatus &&
                                          connectivityState.status ==
                                              InternetStatus.connected
                                      ? () => _fetchPosts()
                                      : null,
                                  buttonTitle: connectivityState
                                              is CurrentConnectivityStatus &&
                                          connectivityState.status ==
                                              InternetStatus.connected
                                      ? 'Retry'
                                      : null,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    if ((connectivityState
                                                is CurrentConnectivityStatus &&
                                            connectivityState.status ==
                                                InternetStatus.disconnected) ||
                                        state is ErrorFetchingPostsState)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8.0),
                                        child: Text(
                                          "${state is ErrorFetchingPostsState ? 'Error occurred' : 'No internet access'}, loaded cached post",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                color: Colors.redAccent,
                                              ),
                                        ),
                                      ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: state
                                                    is ErrorFetchingPostsState ||
                                                (connectivityState
                                                        is CurrentConnectivityStatus &&
                                                    connectivityState.status ==
                                                        InternetStatus
                                                            .disconnected)
                                            ? _cachedPosts.length
                                            : _posts.isEmpty &&
                                                    state is FetchingPostsState
                                                ? 10
                                                : _posts.length,
                                        shrinkWrap: true,
                                        controller: listScrollController,
                                        itemBuilder: (context, index) => state
                                                    is ErrorFetchingPostsState ||
                                                (connectivityState
                                                        is CurrentConnectivityStatus &&
                                                    connectivityState.status ==
                                                        InternetStatus
                                                            .disconnected)
                                            ? _postCard(_cachedPosts[index])
                                            : _posts.isEmpty &&
                                                    state is FetchingPostsState
                                                ? LoadingShimmer()
                                                : _postCard(_posts[index]),
                                      ),
                                    ),
                                    _posts.isNotEmpty &&
                                            loadMore &&
                                            state is SuccessFetchingPostsState
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomButton(
                                                  title: 'Load more',
                                                  onPressed: () {
                                                    _fetchPosts();
                                                  }),
                                            ],
                                          )
                                        : SizedBox()
                                  ],
                                ),
                        ),
                      )
                    ],
                  )),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _postCard(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Card(
        color: Colors.white,
        child: ListTile(
          onTap: () =>
              Navigator.pushNamed(context, 'post_details', arguments: post),
          title: Text(
            post.title != null ? post.title!.capitalize() : '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${post.body}',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ),
    );
  }
}
