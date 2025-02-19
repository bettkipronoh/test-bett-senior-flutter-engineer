import 'package:flutter/material.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme?.copyWith(
              color: Colors.white,
            ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: Column(
        children: [],
      )),
    );
  }
}
