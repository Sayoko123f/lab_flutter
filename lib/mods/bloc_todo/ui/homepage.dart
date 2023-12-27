import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../todo_state.dart';
import '../todo_bloc.dart';
import '../todo_event.dart';
import '../todo.api.dart' show Todo;

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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [TodoFilterDropdownMenu(), TodoSortAscDropdownMenu()],
              ),
            ),
            const SelectedTodoText(),
            const SelectedTodoActions(),
            BlocSelector<TodoOverviewBloc, TodosOverviewState,
                TodosOverviewStatus>(selector: (state) {
              return state.status;
            }, builder: (context, status) {
              final isLoading = status == TodosOverviewStatus.loading;
              return Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            value: null,
                            semanticsLabel: '讀取中',
                          ),
                        )
                      : const TodoList());
            })
          ],
        ),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('TodoList build.');
    return BlocSelector<TodoOverviewBloc, TodosOverviewState, List<Todo>>(
        selector: (state) => state.shouldShowTodos,
        builder: (context, shouldShowTodos) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: shouldShowTodos.length,
            itemBuilder: (context, index) => TodoItem(shouldShowTodos[index]),
          );
        });
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
    }, builder: (context, todo) {
      return Row(
        children: [
          TextButton.icon(
              onPressed: () {
                debugPrint('新增');
                context.pushNamed('todo_new');
              },
              icon: const Icon(
                Icons.add,
              ),
              label: const Text('新增')),
          TextButton.icon(
              onPressed: todo == null
                  ? null
                  : () {
                      debugPrint('編輯 ${todo.id}');
                      context.pushNamed('todo_edit', extra: todo);
                    },
              icon: const Icon(
                Icons.edit,
              ),
              label: const Text('編輯')),
          TextButton.icon(
              onPressed: todo == null
                  ? null
                  : () {
                      debugPrint('刪除 ${todo.id}');
                      context
                          .read<TodoOverviewBloc>()
                          .add(TodoDeleted(todo.id));
                    },
              icon: const Icon(Icons.delete),
              label: const Text('刪除')),
        ],
      );
    });
  }
}

class TodoFilterDropdownMenu extends StatelessWidget {
  const TodoFilterDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TodoOverviewBloc, TodosOverviewState, String>(
        selector: (state) => state.filterOption,
        builder: (context, filterOption) {
          return DropdownMenu(
              label: const Text('狀態'),
              leadingIcon: const Icon(Icons.filter_list),
              inputDecorationTheme:
                  const InputDecorationTheme(disabledBorder: InputBorder.none),
              initialSelection: 'all',
              onSelected: (value) {
                if (value != null) {
                  context.read<TodoOverviewBloc>().add(TodoFilterChange(value));
                }
              },
              dropdownMenuEntries: filterMenu);
        });
  }
}

class TodoSortAscDropdownMenu extends StatelessWidget {
  const TodoSortAscDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TodoOverviewBloc, TodosOverviewState, bool>(
      selector: (state) => state.asc,
      builder: (context, asc) {
        return DropdownMenu(
            label: const Text('排序'),
            leadingIcon: const Icon(Icons.sort),
            initialSelection: asc,
            inputDecorationTheme:
                const InputDecorationTheme(disabledBorder: InputBorder.none),
            onSelected: (value) {
              if (value != null) {
                context.read<TodoOverviewBloc>().add(TodoSortAscChange(value));
              }
            },
            dropdownMenuEntries: const [
              DropdownMenuEntry(
                  value: true,
                  label: '升序',
                  leadingIcon: Icon(Icons.arrow_upward)),
              DropdownMenuEntry(
                  value: false,
                  label: '降序',
                  leadingIcon: Icon(Icons.arrow_downward)),
            ]);
      },
    );
  }
}
