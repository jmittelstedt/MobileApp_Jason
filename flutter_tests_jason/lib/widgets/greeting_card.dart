import 'package:flutter/material.dart';

class GreetingCard extends StatefulWidget {
  final String userName;

  const GreetingCard({super.key, required this.userName});
  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  int _likes = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hello, ${widget.userName}!',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text('Likes: $_likes', key: const Key('likes_text_key')),
        const SizedBox(height: 10),
        ElevatedButton(
          key: const Key('like_button_key'),
          onPressed: () {
            setState(() {
              _likes++;
            });
          },
          child: const Text('Like'),
        ),
      ],
    );
  }
}
