import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/todo.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<TodoStore>(create: (context) => TodoStore()),
    ], child: const TodoList());
  }
}

class TodoStore extends ChangeNotifier {
  List<Todo> _todos = [];

  TodoStore() {
    refresh();
  }

  Future<void> refresh() async {
    try {
      debugPrint('refresh.');
      var res = await fetchAll();
      _todos = res.toList();
    } on HttpException {
      debugPrint('[Todo.refresh]: HttpException');
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('any error.');
    } finally {
      notifyListeners();
    }
  }

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
}

class TodoText extends StatefulWidget {
  const TodoText({super.key});

  @override
  State<TodoText> createState() => _TodoTextState();
}

class _TodoTextState extends State<TodoText> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoStore>(
        builder: (context, store, child) =>
            Text('總共有幾筆 Todo: ${store.todos.length.toString()}'));
  }
}

class TodoItem extends StatefulWidget {
  const TodoItem({super.key});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) => Consumer<TodoStore>(
      builder: (context, store, child) => const Card(
            child: ListTile(
              leading: Icon(Icons.check_box),
              title: Text('123'),
            ),
          ));
}

class TodoItem2 extends StatelessWidget {
  final Todo item;

  const TodoItem2({super.key, required this.item});

  IconData _leadingIcon(String state) => switch (state) {
        'Pending' => Icons.check_box_outline_blank,
        'Progress' => Icons.directions_run,
        'Resolved' => Icons.done,
        _ => Icons.error
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(_leadingIcon(item.state)),
        title: Text(item.title),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) => Consumer<TodoStore>(
      builder: (context, store, child) => ListView(
            children: [
              for (int i = 0; i < store.todos.length; i++)
                TodoItem2(item: store.todos[i])
            ],
          ));
}
