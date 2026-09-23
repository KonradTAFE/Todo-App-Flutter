import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.dart';

class TodoWidget extends StatefulWidget {
  const TodoWidget({Key? key, required this.todo}) : super(key: key);

final Todo todo;
  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    )
                  ),
                  padding: const EdgeInsets.all(2.5),
                  child:  Text(widget.todo.name.toString(),
                  textAlign: TextAlign.center),
                );
  }
}