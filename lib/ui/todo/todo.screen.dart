import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'todo.api.dart';
import 'todo.store.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<TodoStore>(create: (context) => todoStore),
        ],
        child: Scaffold(
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
                    dropdownMenuEntries: todoStateMap.values
                        .map((e) => DropdownMenuEntry(
                            value: e.value,
                            label: e.label,
                            leadingIcon: Icon(e.icon)))
                        .toList(),
                    onSelected: (value) {
                      todoStore.filterState = value;
                    },
                  )
                ]),
                const TodoTotalText(),
                const Expanded(child: TodoList())
              ],
            ),
          ),
        ));
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
            itemCount: store.filtered.length,
            itemBuilder: (context, index) =>
                TodoItem(item: store.filtered[index]),
          ));
}
