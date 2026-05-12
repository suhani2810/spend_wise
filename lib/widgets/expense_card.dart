import 'package:flutter/material.dart';
import 'package:spend_wise/models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.92),

      elevation: 6,

      shadowColor: Colors.pinkAccent,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),

      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        leading: CircleAvatar(
          radius: 24,

          backgroundColor: const Color(0xFFF7C8D8),

          child: Text(
            expense.category.label
                .substring(0, 1)
                .toUpperCase(),

            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD95C8A),
            ),
          ),
        ),

        title: Text(
          expense.title,

          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5A3A4A),
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Text(
            '${expense.category.label} • ${DateFormat.yMMMd().format(expense.date)}',

            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF7A5B68),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        trailing: Text(
          '₹${expense.amount.toStringAsFixed(2)}',

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD95C8A),
          ),
        ),
      ),
    );
  }
}