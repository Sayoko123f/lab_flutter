import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myflutterapp/todo.dart' as todo;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Provider(create: (context) => 42, child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hello Title'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              const Expanded(
                child: MyRating(),
              ),
              TextButton(onPressed: () {}, child: const Text('Button'))
            ],
          ),
        ));
  }
}

void hello() {
  debugPrint('Hello');
}

class MyRating extends StatefulWidget {
  const MyRating({super.key});

  @override
  State<MyRating> createState() => _MyRatingState();
}

class _MyRatingState extends State<MyRating> {
  final int _total = 5;
  int _score = 0;

  void _onStarClick(int index) {
    setState(() {
      _score = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _total; i++)
          IconButton(
            onPressed: () => _onStarClick(i),
            icon: const Icon(
              Icons.star,
            ),
            color: i > _score ? Colors.grey : Colors.amber,
          )
      ],
    );
  }
}
