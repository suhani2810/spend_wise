import 'package:flutter/material.dart';
import 'package:spend_wise/models/expense.dart';
import 'package:intl/intl.dart';

import '../widgets/expense_card.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({
    super.key,
    required this.expenses,
    required this.onAddExpense,
    required this.onDeleteExpense,
  });

  final List<Expense> expenses;
  final ValueChanged<Expense> onAddExpense;
  final ValueChanged<int> onDeleteExpense;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  DateTime _selectedDate = DateTime.now();

  DateTime? _filterDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _presentDatePicker() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitExpense() {
    final String title = _titleController.text.trim();

    final double? amount = double.tryParse(
      _amountController.text.trim(),
    );

    if (title.isEmpty || amount == null || amount <= 0) {
      return;
    }

    widget.onAddExpense(
      Expense(
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
      ),
    );

    _titleController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final double total = widget.expenses.fold<double>(
      0,
          (double sum, Expense item) => sum + item.amount,
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.65),
            BlendMode.lighten,
          ),
        ),
      ),

      child: Column(
        children: [
          Card(
            color: Colors.white.withOpacity(0.88),
            elevation: 8,
            shadowColor: Colors.pinkAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.all(12),

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  TextField(
                    controller: _titleController,

                    decoration: const InputDecoration(
                      labelText: 'Expense title',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,

                          keyboardType:
                          const TextInputType.numberWithOptions(
                            decimal: true,
                          ),

                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            prefixText: '₹ ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child:
                        DropdownButtonFormField<ExpenseCategory>(
                          value: _selectedCategory,

                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),

                          items: ExpenseCategory.values
                              .map(
                                (ExpenseCategory category) =>
                                DropdownMenuItem<
                                    ExpenseCategory>(
                                  value: category,
                                  child: Text(category.label),
                                ),
                          )
                              .toList(),

                          onChanged:
                              (ExpenseCategory? value) {
                            if (value == null) return;

                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Text(
                        DateFormat.yMMMd().format(
                          _selectedDate,
                        ),
                      ),

                      const Spacer(),

                      TextButton.icon(
                        onPressed: _presentDatePicker,
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Color(0xFFD95C8A),
                        ),
                        label: const Text(
                          'Choose Date',
                          style: TextStyle(
                            color: Color(0xFFD95C8A),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submitExpense,
                      child: const Text(
                        'Add Expense',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),

            child: Row(
              children: [
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Total Spent',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFD95C8A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      '₹${total.toStringAsFixed(2)}',

                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD95C8A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: widget.expenses.isEmpty
                ? const Center(
              child: Text(
                'No expenses yet.\nAdd your first one above.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD95C8A),
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),

              itemCount: widget.expenses.length,

              itemBuilder:
                  (BuildContext context, int index) {
                final Expense expense =
                widget.expenses[index];

                return Dismissible(
                  key: ValueKey<Expense>(expense),

                  direction:
                  DismissDirection.endToStart,

                  onDismissed: (_) {
                    widget.onDeleteExpense(index);
                  },

                  background: Container(
                    alignment:
                    Alignment.centerRight,

                    padding:
                    const EdgeInsets.only(
                      right: 20,
                    ),

                    color: Colors.red,

                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),

                  child:
                  ExpenseCard(expense: expense),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}