import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../todo_state.dart';
import '../todo_bloc.dart';
import '../todo_event.dart';
import '../todo_repository.dart';
import '../../todo/todo.api.dart' show Todo;

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
            const SelectedTodoText(),
            const SelectedTodoActions(),
            BlocBuilder<TodoOverviewBloc, TodosOverviewState>(
                buildWhen: (prev, next) {
              return next.shouldRebuildList;
            }, builder: (context, state) {
              final isLoading = state.status == TodosOverviewStatus.loading;
              return Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            value: null,
                            semanticsLabel: '讀取中',
                          ),
                        )
                      : TodoList(state.todos));
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
    debugPrint('TodoList build.');
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
    debugPrint('TodoItem build.');
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
        trailing: Text(item.state.label),
        onTap: () {
          debugPrint('正在點擊 ${item.id}');
          context.read<TodoOverviewBloc>().add(TodoSelected(item));
        },
      ),
    );
  }
}

class SelectedTodoText extends StatelessWidget {
  const SelectedTodoText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoOverviewBloc, TodosOverviewState>(
        builder: (context, state) {
      var text = state.selectedTodo == null
          ? '現在沒有選擇 Todo'
          : '現在正選擇 ${state.selectedTodo?.id}';
      return Text(text);
    });
  }
}

class SelectedTodoActions extends StatelessWidget {
  const SelectedTodoActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TodoOverviewBloc, TodosOverviewState, Todo?>(
        selector: (state) {
      return state.selectedTodo;
    }, builder: (context, state) {
      return Row(
        children: [
          TextButton.icon(
              onPressed: state == null
                  ? null
                  : () {
                      debugPrint('編輯 ${state.id}');
                    },
              icon: const Icon(
                Icons.edit,
              ),
              label: const Text('編輯')),
          TextButton.icon(
              onPressed: state == null
                  ? null
                  : () {
                      debugPrint('刪除 ${state.id}');
                      context
                          .read<TodoOverviewBloc>()
                          .add(TodoDeleted(state.id));
                    },
              icon: const Icon(Icons.delete),
              label: const Text('刪除')),
        ],
      );
    });
  }
}
