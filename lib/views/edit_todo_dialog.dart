import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/models/todo_list.dart';

Future<void> showEditTodoDialog(BuildContext context, Todo todo) {
  return showDialog<void>(
    context: context,
    builder: (context) => EditTodoDialog(todo: todo),
  );
}

class EditTodoDialog extends StatefulWidget {
  const EditTodoDialog({super.key, required this.todo});

  final Todo todo;

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.todo.name);
    _descriptionController = TextEditingController(
      text: widget.todo.description,
    );
  }

  Future<void> _saveTodo() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final updatedTodo = Todo(
      id: widget.todo.id,
      name: name,
      description: _descriptionController.text.trim(),
      completed: widget.todo.completed,
    );

    final model = Provider.of<TodoList>(context, listen: false);
    await model.updateTodo(updatedTodo);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTodo,
          child: const Text('Save'),
        ),
      ],
    );
  }
}