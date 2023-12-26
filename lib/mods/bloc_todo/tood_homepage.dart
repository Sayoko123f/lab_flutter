import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'todo_state.dart';
import 'todo_bloc.dart';
import 'todo_repository.dart';
import '../todo/todo.api.dart' show Todo;

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo 首頁'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<TodoOverviewBloc, TodosOverviewState>(
                builder: (context, state) {
              return Expanded(child: TodoList(state.todos));
            })
          ],
        ),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  final List<Todo> list;

  const TodoList(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (context, index) => TodoItem(list[index]),
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo item;
  const TodoItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          item.title,
          textScaler: const TextScaler.linear(1.4),
        ),
        subtitle: Text(
            '建立於 ${DateFormat('yyyy-MM-dd HH:mm:ss').format(item.createdAt)}\n修改於 ${DateFormat('yyyy-MM-dd HH:mm:ss').format(item.updatedAt)}',
            maxLines: 2,
            style: TextStyle(color: Theme.of(context).hintColor)),
        isThreeLine: true,
        onTap: () {
          debugPrint(item.id);
        },
      ),
    );
  }
}
