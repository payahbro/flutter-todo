import 'dart:convert';
import 'package:http/http.dart' show Client;
import '../pages/todo.dart';

const url = 'http://10.0.2.2:4000';

class TodoRepository {
  Client client = Client();

  Future<List<Todo>> fetchTodoList() async {
    try {
      final response = await client.get(Uri.parse('$url/todo'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        return [Todo.fromJson(jsonResponse)];
      } else {
        throw Exception('Failed to load Todo\'s. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching todo list: $e');
      rethrow;
    }
  }

  Future<Todo> createTodo(String description) async {
    final response = await client.post(Uri.parse('$url/todo'), body: {"description": description, "status": "0", "person_id": "0"});

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create Todo.');
    }
  }

  Future<Todo> updateTodoText(String id, String description) async {
    final response = await client.put(Uri.parse('$url/todo/$id'), body: {"description": description});

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update Todo text.');
    }
  }

  Future<Todo> updateTodoStatus(String id, bool completed) async {
    final response = await client.patch(Uri.parse('$url/todo/$id'), body: {"status": completed == true ? "1" : "0"});

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update Todo text.');
    }
  }
}