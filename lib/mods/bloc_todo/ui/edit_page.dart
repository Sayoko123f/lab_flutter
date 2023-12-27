import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../todo_state.dart';
import '../todo_bloc.dart';
import '../todo_event.dart';
import '../todo_repository.dart';
import '../../todo/todo.api.dart' as api;

class EditPage extends StatelessWidget {
  final api.Todo todo;

  const EditPage(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('編輯待辦事項')),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TodoForm(todo: todo),
        ),
      ),
    );
  }
}

class FormData {
  String id;
  String title;
  String content;
  api.TodoState state;

  FormData(this.id,
      {this.content = '', this.title = '', this.state = api.TodoState.pending});

  Future<void> edit() async {
    await api.update(id, title: title, content: content, state: state.value);
  }
}

class TodoForm extends StatefulWidget {
  const TodoForm({required this.todo, super.key});

  final api.Todo todo;

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  late final FormData data;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    var todo = widget.todo;
    data = FormData(todo.id,
        title: todo.title, content: todo.content, state: todo.state);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _form,
        child: Column(
          children: [
            TextFormField(
              initialValue: data.title,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "請填寫標題";
                }
                return null;
              },
              decoration: const InputDecoration(
                  helperText: '標題', hintText: '標題', labelText: '標題'),
              onSaved: (val) {
                data.title = val ?? '';
              },
            ),
            TextFormField(
              initialValue: data.content,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "請填寫內容";
                }
                return null;
              },
              decoration: const InputDecoration(
                  helperText: '內容', hintText: '內容', labelText: '內容'),
              onSaved: (val) {
                data.content = val ?? '';
              },
            ),
            DropdownMenu(
              initialSelection: widget.todo.state,
              inputDecorationTheme:
                  const InputDecorationTheme(disabledBorder: InputBorder.none),
              leadingIcon: const Icon(Icons.task),
              label: const Text('狀態'),
              dropdownMenuEntries: api.TodoState.values
                  .map((e) => DropdownMenuEntry(
                      value: e, label: e.label, leadingIcon: Icon(e.icon)))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  data.state = value;
                }
              },
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      debugPrint('確認');
                      _form.currentState!.save();
                      if (_form.currentState!.validate()) {
                        _submit();
                      }
                    },
                    child: const Text('確認'))
              ],
            )
          ],
        ));
  }

  Future<void> _submit() async {
    debugPrint('_submit');
    try {
      await data.edit();
      if (mounted) {
        BlocProvider.of<TodoOverviewBloc>(context).add(TodoRefresh());
        context.canPop() ? context.pop() : context.goNamed('home');
      }
    } on HttpException {
      debugPrint('網路異常，請稍後重新再試');
    }
  }
}
