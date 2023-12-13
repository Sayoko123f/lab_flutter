import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'todo.api.dart';
import 'todo.store.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('待辦事項清單'),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Container(
        color: Colors.lime,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              DropdownMenu(
                inputDecorationTheme: const InputDecorationTheme(
                    disabledBorder: InputBorder.none),
                leadingIcon: const Icon(Icons.filter_list),
                label: const Text('篩選'),
                dropdownMenuEntries: todoFilterDropdownMenuEntries(),
                onSelected: (value) {
                  todoStore.filterState = value;
                },
              ),
              DropdownMenu(
                initialSelection: TodoSortValue.createdAt,
                inputDecorationTheme: const InputDecorationTheme(
                    disabledBorder: InputBorder.none),
                leadingIcon: const Icon(Icons.sort),
                label: const Text('排序'),
                dropdownMenuEntries: TodoSortValue.values
                    .map((e) => DropdownMenuEntry(
                          value: e,
                          label: todoSortValueZh[e]!,
                        ))
                    .toList(),
                onSelected: (value) {
                  todoStore.todoSortValue = value ?? TodoSortValue.none;
                },
              ),
            ]),
            const TodoTotalText(),
            const ToggleSortByButton(),
            const Expanded(child: TodoList())
          ],
        ),
      ),
    );
  }
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
            maxLines: 2),
        isThreeLine: true,
        onTap: () {
          context.go('/todo/${item.id}');
        },
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
            itemCount: store.todoShouldShow.length,
            itemBuilder: (context, index) =>
                TodoItem(item: store.todoShouldShow[index]),
          ));
}

class ToggleSortByButton extends StatefulWidget {
  const ToggleSortByButton({super.key});

  @override
  State<ToggleSortByButton> createState() => _ToggleSortByButtonState();
}

class _ToggleSortByButtonState extends State<ToggleSortByButton> {
  @override
  Widget build(BuildContext context) => Consumer<TodoStore>(
      builder: (context, store, child) => TextButton.icon(
            label: Text(store.sortBy == SortBy.asc ? '升序' : '降序'),
            icon: Icon(store.sortBy == SortBy.asc
                ? Icons.arrow_upward
                : Icons.arrow_downward),
            onPressed: () {
              store.sortBy =
                  store.sortBy == SortBy.asc ? SortBy.desc : SortBy.asc;
            },
          ));
}
