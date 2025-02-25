import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo.dart';

class TodoApi {
  static const String _todoListKey = 'todo';

  Future<List<Todo>> fetchTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString(_todoListKey);

    if (todosJson == null || todosJson.isEmpty) {
      return [];
    } else {
      List<dynamic> data = json.decode(todosJson);
      return data.map((todo) => Todo.fromJson(todo)).toList();
    }
  }

  Future<void> createTodo(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Todo> todos = await fetchTodos();

    todos.add(todo);

    await prefs.setString(
        _todoListKey, json.encode(todos.map((todo) => todo.toJson()).toList()));
  }

  Future<void> updateTodo(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Todo> todos = await fetchTodos();

    final todoIndex =
        todos.indexWhere((existingTodo) => existingTodo.id == todo.id);
    if (todoIndex != -1) {
      todos[todoIndex] = todo;

      await prefs.setString(_todoListKey,
          json.encode(todos.map((todo) => todo.toJson()).toList()));
    }
  }

  Future<void> deleteTodo(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Todo> todos = await fetchTodos();

    todos.removeWhere((todo) => todo.id == id);

    await prefs.setString(
        _todoListKey, json.encode(todos.map((todo) => todo.toJson()).toList()));
  }
}
