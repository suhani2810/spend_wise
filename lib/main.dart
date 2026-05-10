import 'package:flutter/material.dart';
import 'package:spend_wise/screens/expense_screen.dart';
import 'package:spend_wise/screens/todo_screen.dart';

import 'models/expense.dart';
import 'models/todo.dart';

void main() {
  runApp(const SpendWiseApp());
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFC90BA),
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      home: const SpendWiseHome(),
    );
  }
}

class SpendWiseHome extends StatefulWidget {
  const SpendWiseHome({super.key});

  @override
  State<SpendWiseHome> createState() => _SpendWiseHomeState();
}

class _SpendWiseHomeState extends State<SpendWiseHome> {
  int _selectedTab = 0;

  final List<Expense> _expenses = <Expense>[];
  final List<Todo> _todos = <Todo>[];

  // ── ACTION METHODS ──────────────────────────────────────────────

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
      _expenses.sort((Expense a, Expense b) => b.date.compareTo(a.date));
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _addTodo(String title) {
    setState(() {
      _todos.add(Todo(title: title, createdAt: DateTime.now()));
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  // ── BUILD ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final List<String> titles = <String>['Expenses', 'Todo List'];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[_selectedTab]),
        ),
        body: _selectedTab == 0
            ? ExpenseScreen(
          expenses: _expenses,
          onAddExpense: _addExpense,
          onDeleteExpense: _deleteExpense,
        )
            : TodoScreen(
          todos: _todos,
          onAddTodo: _addTodo,
          onToggleTodo: _toggleTodo,
          onDeleteTodo: _deleteTodo,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_outlined),
              label: 'Todo',
            ),
          ],
        ),
      ),
    );
  }
}