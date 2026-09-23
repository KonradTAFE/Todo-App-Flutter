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

  DateTime? _dueDate;

Future<void> _pickDueDate() async {
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: _dueDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (!mounted || selectedDate == null) return;

  setState(() {
    _dueDate = selectedDate;
  });
}

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.todo.name);
    _descriptionController = TextEditingController(
      text: widget.todo.description,
    );
    _dueDate = widget.todo.dueDate;
  }

  Future<void> _saveTodo() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final updatedTodo = Todo(
      id: widget.todo.id,
      name: name,
      description: _descriptionController.text.trim(),
      completed: widget.todo.completed,
      createdAt: widget.todo.createdAt,
      updatedAt: DateTime.now(),
      dueDate: _dueDate,
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
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: _pickDueDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _dueDate == null
                        ? 'Set due date'
                        : MaterialLocalizations.of(context)
                            .formatMediumDate(_dueDate!),
                  ),
                ),
              ),
              if (_dueDate != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _dueDate = null;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: 'Remove due date',
                ),
            ],
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