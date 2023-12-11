import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/todo.dart';

final TodoStore todoStore = TodoStore();

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<TodoStore>(create: (context) => todoStore),
        ],
        child: Container(
          color: Colors.lime,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [TodoTotalText(), Expanded(child: TodoList())],
          ),
        ));
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

class TodoTotalText extends StatefulWidget {
  const TodoTotalText({super.key});

  @override
  State<TodoTotalText> createState() => _TodoTotalTextState();
}

class _TodoTotalTextState extends State<TodoTotalText> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoStore>(
        builder: (context, store, child) =>
            Text('總共有幾筆 Todo: ${store.todos.length.toString()}'));
  }
}

class TodoItem extends StatelessWidget {
  final Todo item;

  const TodoItem({super.key, required this.item});

  IconData _leadingIcon(String state) => switch (state) {
        'Pending' => Icons.check_box_outline_blank,
        'Progress' => Icons.directions_run,
        'Resolved' => Icons.done,
        _ => Icons.error
      };

  Future<void> _onLeadingIconPressed() async {
    debugPrint(item.id);
    String newState = switch (item.state) {
      'Pending' => 'Progress',
      'Progress' => 'Resolved',
      'Resolved' => 'Pending',
      _ => 'Progress'
    };
    await update(item.id, state: newState);
    await todoStore.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
            onPressed: _onLeadingIconPressed,
            icon: Icon(_leadingIcon(item.state))),
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
      builder: (context, store, child) => ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: store.todos.length,
            itemBuilder: (context, index) => TodoItem(item: store.todos[index]),
          ));
}
