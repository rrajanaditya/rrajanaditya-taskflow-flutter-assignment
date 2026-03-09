import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoProvider with ChangeNotifier {
  final String _dbUrl =
      'https://todo-fc57c-default-rtdb.asia-southeast1.firebasedatabase.app/todos';

  List<Todo> _todos = [];
  bool _isLoading = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;

  Future<String?> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  Future<void> fetchTodos(String userId) async {
    _setLoading(true);
    try {
      final token = await _getToken();
      final url = Uri.parse('$_dbUrl/$userId.json?auth=$token');

      final response = await http.get(url);
      if (response.statusCode == 200 && response.body != 'null') {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _todos = data.entries
            .map((e) => Todo.fromJson(e.key, e.value))
            .toList();
      } else {
        _todos = [];
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTodo(String userId, String title) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$_dbUrl/$userId.json?auth=$token');

      final newTodoData = {'title': title, 'isCompleted': false};
      final response = await http.post(url, body: json.encode(newTodoData));

      if (response.statusCode >= 400) {
        debugPrint("Add Error - Permission denied: ${response.body}");
        return;
      }

      final responseData = json.decode(response.body);
      final newId = responseData['name'] as String?;

      if (newId != null) {
        _todos.add(Todo(id: newId, title: title));
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Add exception: $e");
    }
  }

  Future<void> editTodo(String userId, String todoId, String newTitle) async {
    final index = _todos.indexWhere((t) => t.id == todoId);
    if (index >= 0) {
      _todos[index].title = newTitle;
      notifyListeners();

      final token = await _getToken();
      final url = Uri.parse('$_dbUrl/$userId/$todoId.json?auth=$token');

      await http.patch(url, body: json.encode({'title': newTitle}));
    }
  }

  Future<void> toggleTodoStatus(String userId, Todo todo) async {
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
    try {
      final token = await _getToken();
      final url = Uri.parse('$_dbUrl/$userId/${todo.id}.json?auth=$token');

      await http.patch(
        url,
        body: json.encode({'isCompleted': todo.isCompleted}),
      );
    } catch (e) {
      todo.isCompleted = !todo.isCompleted;
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String userId, String todoId) async {
    final index = _todos.indexWhere((t) => t.id == todoId);
    final todo = _todos[index];
    _todos.removeAt(index);
    notifyListeners();

    try {
      final token = await _getToken();
      final url = Uri.parse(
        '$_dbUrl/$userId/$todoId.json?auth=$token',
      );

      await http.delete(url);
    } catch (e) {
      _todos.insert(index, todo);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
