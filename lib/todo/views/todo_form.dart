import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/todo/bloc/todo_bloc.dart';
import 'package:todo/todo/bloc/todo_events.dart';

class TodoForm extends StatefulWidget {
  const TodoForm({
    super.key,
    this.todo,
  });

  final Todo? todo;

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.todo == null ? "Add" : "Edit",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the title';
                }

                var maxLength = 50;
                if (value.length > maxLength) {
                  return 'Title cannot exceed $maxLength characters.';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                var maxLength = 250;
                if (value!.length > maxLength) {
                  return 'Description cannot exceed $maxLength characters.';
                }

                return null;
              },
            ),
            const SizedBox(height: 30),

            // Submit
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    String title = _titleController.text;
                    String description = _descriptionController.text;

                    if (widget.todo == null) {
                      final newTodo = Todo(
                        id: DateTime.now().toString(),
                        title: title,
                        description: description,
                      );

                      context.read<TodoBloc>().add(CreateTodoEvent(newTodo));
                    } else {
                      final updatedTodo = Todo(
                        id: widget.todo!.id,
                        title: title,
                        description: description,
                      );

                      context
                          .read<TodoBloc>()
                          .add(UpdateTodoEvent(updatedTodo));
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }
}
