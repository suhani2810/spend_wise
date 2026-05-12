import 'package:flutter/material.dart';
import 'package:spend_wise/models/todo.dart';
import 'package:intl/intl.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onChanged,
  });

  final Todo todo;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: todo.isDone,

      onChanged: onChanged,

      activeColor: const Color(0xFFD95C8A),

      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),

      title: Text(
        todo.title,

        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,

          color: const Color(0xFF5A3A4A),

          decoration:
          todo.isDone
              ? TextDecoration.lineThrough
              : null,

          decorationColor: const Color(0xFFD95C8A),
        ),
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),

        child: Text(
          'Added on ${DateFormat.yMMMd().format(todo.createdAt)}',

          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF7A5B68),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}