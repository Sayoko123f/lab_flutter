import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Uri _apiUri(String path, [Map<String, dynamic>? query]) {
  return Uri.http('192.168.12.41:3000', path, query);
}

Map<String, String> _commonHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

bool _isOk(int statusCode) => 200 <= statusCode && statusCode < 300;

class Todo {
  final String id;
  final String title;
  final String content;
  final TodoState state;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo(
      {required this.id,
      required this.title,
      required this.content,
      required this.state,
      required this.deleted,
      required this.createdAt,
      required this.updatedAt});

  factory Todo.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          '_id': String id,
          'title': String title,
          'content': String content,
          'state': String state,
          'deleted': bool deleted,
          'createdAt': String createdAt,
          'updatedAt': String updatedAt,
        } =>
          Todo(
            id: id,
            title: title,
            content: content,
            state: TodoState.fromJson(state),
            deleted: deleted,
            createdAt: DateTime.parse(createdAt),
            updatedAt: DateTime.parse(updatedAt),
          ),
        _ => throw const FormatException('Failed convert todo from JSON.')
      };
}

class FetchAllQuery {
  String? title;
  // ['Pending', 'Progress', 'Resolved']
  String? state;
  DateTime? createStart;
  DateTime? createEnd;
  DateTime? updateStart;
  DateTime? updateEnd;
  String? sortBy;
  String? orderBy;
  int? skip;
  int? limit;

  FetchAllQuery(
      {this.title,
      this.createEnd,
      this.createStart,
      this.limit,
      this.orderBy,
      this.skip,
      this.sortBy,
      this.state,
      this.updateEnd,
      this.updateStart});

  Map<String, dynamic> toQuery() {
    var query = {
      'title': title,
      'state': state,
      'createStart': createStart?.toIso8601String(),
      'createEnd': createEnd?.toIso8601String(),
      'updateStart': updateStart?.toIso8601String(),
      'updateEnd': updateEnd?.toIso8601String(),
      'sortBy': sortBy,
      'orderBy': orderBy,
      'skip': skip?.toString(),
      'limit': limit?.toString(),
    };
    query.removeWhere((key, value) => value == null);
    return query;
  }
}

Future<Iterable<Todo>> fetchAll([FetchAllQuery? query]) async {
  final res = await http
      .get(_apiUri('todos', query?.toQuery()))
      .timeout(Durations.long2);
  if (_isOk(res.statusCode)) {
    await Future.delayed(Durations.extralong2);
    var todos = jsonDecode(res.body) as List<dynamic>;
    return todos.map((e) => Todo.fromJson(e as Map<String, dynamic>));
  }
  throw HttpException('[Todo.fetchAll] ${res.statusCode} ${res.body}');
}

Future<Todo> fetchById(String id) async {
  final res = await http.get(_apiUri('todos/$id'));
  if (_isOk(res.statusCode)) {
    var todo = jsonDecode(res.body);
    return Todo.fromJson(todo as Map<String, dynamic>);
  }
  throw HttpException('[Todo.fetchById] ${res.statusCode} ${res.body}');
}

Future<Todo> create({required String title, required String content}) async {
  final res = await http.post(_apiUri('todos'),
      headers: _commonHeaders,
      body: jsonEncode({'title': title, 'content': content}));

  if (_isOk(res.statusCode)) {
    var todo = jsonDecode(res.body);
    return Todo.fromJson(todo as Map<String, dynamic>);
  }
  throw HttpException('[Todo.create] ${res.statusCode} ${res.body}');
}

Future<void> delete(String id) async {
  final res = await http.delete(_apiUri('todos/$id'), headers: _commonHeaders);
  if (_isOk(res.statusCode)) {
    return;
  }
  throw HttpException('[Todo.delete] ${res.statusCode} ${res.body}');
}

Future<Todo> update(String id,
    {String? title, String? content, String? state}) async {
  final body = {'title': title, 'content': content, 'state': state};
  body.removeWhere((key, value) => value == null);
  final res = await http.patch(_apiUri('todos/$id'),
      headers: _commonHeaders, body: jsonEncode(body));
  if (_isOk(res.statusCode)) {
    var todo = jsonDecode(res.body);
    return Todo.fromJson(todo as Map<String, dynamic>);
  }
  throw HttpException('[Todo.update] ${res.statusCode} ${res.body}');
}

enum TodoState {
  pending(value: 'Pending', label: '待處理', icon: Icons.pending),
  progress(value: 'Progress', label: '進行中', icon: Icons.directions_run),
  resolved(value: 'Resolved', label: '已完成', icon: Icons.done);

  final String value;
  final String label;
  final IconData icon;

  const TodoState(
      {required this.value, required this.label, required this.icon});

  static TodoState fromJson(String val) {
    final a = {
      TodoState.pending.value: TodoState.pending,
      TodoState.progress.value: TodoState.progress,
      TodoState.resolved.value: TodoState.resolved,
    }[val];
    if (a == null) {
      throw const FormatException('[TodoState.fromJson]: Invalid state.');
    }
    return a;
  }

  String toJson() => value;
}
