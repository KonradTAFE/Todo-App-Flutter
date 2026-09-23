import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/models/todo_list.dart';

Future<void> showAddTodoDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const AddTodoDialog(),
  );
}

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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

  Future<void> _addTodo() async {
  final name = _nameController.text.trim();
  if (name.isEmpty) return;

  final now = DateTime.now();

  final todo = Todo(
    id: null,
    name: name,
    description: _descriptionController.text.trim(),
    createdAt: now,
    updatedAt: now,
    dueDate: _dueDate,
  );

  final model = Provider.of<TodoList>(context, listen: false);
  await model.add(todo);

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
      title: const Text('Add task'),
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
        ElevatedButton(onPressed: _addTodo, child: const Text('Add')),
      ],
    );
  }
}
