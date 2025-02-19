import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:posts/bloc/connectivity/connectivity_cubit.dart';
import 'package:posts/bloc/posts_bloc/posts_bloc.dart';
import 'package:posts/model/post_model.dart';
import 'package:posts/ui/widgets/custom_card.dart';
import 'package:posts/ui/widgets/empty_list_widget.dart';
import 'package:posts/utilities/extensions.dart';
import 'package:posts/utilities/snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _fetchPosts();
    super.initState();
  }

  _fetchPosts() {
    context.read<PostsBloc>().add(FetchPostsEvent());
  }

  List<Post> _posts = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PostsBloc, PostsState>(
          listener: (context, state) {
            if (state is SuccessFetchingPostsState) {
              _posts = state.response;
              setState(() {});
            }

            if (state is ErrorFetchingPostsState) {
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
                body: SafeArea(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "Posts",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                    if (connectivityState is CurrentConnectivityStatus &&
                        connectivityState.status == InternetStatus.connected)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8.0),
                        child: Text(
                          "DISCONNECTED",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: Colors.redAccent,
                              ),
                        ),
                      ),
                    Expanded(
                      child: CustomCard(
                        color: Colors.white,
                        child: state is ErrorFetchingPostsState
                            ? EmptyWidget(
                                description: connectivityState
                                            is CurrentConnectivityStatus &&
                                        connectivityState.status ==
                                            InternetStatus.disconnected
                                    ? "No internet connection"
                                    : state.message,
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
                            : ListView.builder(
                                itemCount: _posts.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4),
                                    child: Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        onTap: () => Navigator.pushNamed(
                                            context, 'post_details',
                                            arguments: _posts[index]),
                                        title: Text(
                                          _posts[index].title != null
                                              ? _posts[index]
                                                  .title!
                                                  .capitalize()
                                              : '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        subtitle: Text(
                                          '${_posts[index].body}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      ),
                    )
                  ],
                )),
              );
            },
          );
        },
      ),
    );
  }
}
