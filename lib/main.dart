import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts/ui/screens/home_screen.dart';
import 'package:posts/ui/screens/post_details_screen.dart';

import 'bloc/connectivity/connectivity_cubit.dart';
import 'bloc/posts_bloc/posts_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostsBloc(),
        ),
        BlocProvider(
          create: (context) => ConnectivityCubit()..listenToConnection(),
        ),
      ],
      child: MaterialApp(
        title: 'Posts',
        debugShowCheckedModeBanner: false,
        theme: themeData(),
        routes: {
          'post_details': (context) => PostDetailsScreen(),
        },
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData themeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
        titleSmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontWeight: FontWeight.normal,
        ),
        displayMedium: TextStyle(
          fontSize: 16,
          color: Colors.grey,
          fontWeight: FontWeight.normal,
        ),
        displayLarge: TextStyle(
          fontSize: 20,
          color: Colors.grey,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
