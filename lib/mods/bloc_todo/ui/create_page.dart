import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../todo_bloc.dart';
import '../todo_event.dart';
import '../../todo/todo.api.dart' as api;

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新增待辦事項')),
      body: const SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TodoForm(),
        ),
      ),
    );
  }
}

class FormData {
  String title;
  String content;

  FormData({this.content = '', this.title = ''});

  Future<void> create() async {
    await api.create(title: title, content: content);
  }
}

class TodoForm extends StatefulWidget {
  const TodoForm({super.key});

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final data = FormData();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

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
      await data.create();
      if (mounted) {
        BlocProvider.of<TodoOverviewBloc>(context).add(TodoRefresh());
        context.canPop() ? context.pop() : context.goNamed('home');
      }
    } on HttpException {
      debugPrint('網路異常，請稍後重新再試');
    }
  }
}
