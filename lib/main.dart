import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/todo/page.dart' as todo;

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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ScoreManager()),
        ],
        child: const MyHomePage(),
      ),
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
        body: const Stack(
          children: [
            todo.TodoPage(),
          ],
        ));
  }
}

void hello() {
  debugPrint('Hello');
}

class MyRating extends StatefulWidget {
  const MyRating({super.key});

  @override
  State<MyRating> createState() => _MyRatingState2();
}

class _MyRatingState2 extends State<MyRating> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreManager>(
        builder: (context, scoreManager, child) => Row(
              children: [
                for (int i = 0; i < scoreManager.total; i++)
                  IconButton(
                    onPressed: () {
                      scoreManager.score = i;
                    },
                    icon: const Icon(
                      Icons.star,
                    ),
                    color: i > scoreManager.score ? Colors.grey : Colors.amber,
                  )
              ],
            ));
  }
}

class ScoreManager extends ChangeNotifier {
  final int total = 5;
  int _score = 0;

  int get score {
    return _score;
  }

  set score(int value) {
    _score = value;
    notifyListeners();
  }
}

class MyScoreText extends StatefulWidget {
  const MyScoreText({super.key});

  @override
  State<MyScoreText> createState() => _MyScoreTextState();
}

class _MyScoreTextState extends State<MyScoreText> {
  @override
  Widget build(BuildContext context) => Consumer<ScoreManager>(
      builder: (context, scoreManager, child) =>
          Text(scoreManager.score.toString()));
}
