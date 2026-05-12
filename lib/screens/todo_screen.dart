import 'package:flutter/material.dart';
import 'package:spend_wise/models/todo.dart';
import 'package:spend_wise/widgets/todo_tile.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({
    super.key,
    required this.todos,
    required this.onAddTodo,
    required this.onToggleTodo,
    required this.onDeleteTodo,
  });

  final List<Todo> todos;
  final ValueChanged<String> onAddTodo;
  final ValueChanged<int> onToggleTodo;
  final ValueChanged<int> onDeleteTodo;

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController =
  TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _submitTodo() {
    final String taskTitle =
    _taskController.text.trim();

    if (taskTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task cannot be empty.'),
        ),
      );
      return;
    }

    widget.onAddTodo(taskTitle);

    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
          // ── ADD TODO CARD ─────────────────────────────

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

              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,

                      decoration: const InputDecoration(
                        labelText: 'New Task',
                        border: OutlineInputBorder(),
                      ),

                      onSubmitted: (_) => _submitTodo(),
                    ),
                  ),

                  const SizedBox(width: 12),

                  FilledButton(
                    onPressed: _submitTodo,

                    child: const Text(
                      'Add',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── TODO LIST ─────────────────────────────────

          Expanded(
            child: widget.todos.isEmpty
                ? const Center(
              child: Text(
                'No tasks yet.\nAdd one to get started.',
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

              itemCount: widget.todos.length,

              itemBuilder:
                  (BuildContext context, int index) {
                final Todo todo =
                widget.todos[index];

                return Dismissible(
                  key: ValueKey<Todo>(todo),

                  direction:
                  DismissDirection.endToStart,

                  onDismissed: (_) =>
                      widget.onDeleteTodo(index),

                  background: Container(
                    alignment:
                    Alignment.centerRight,

                    padding:
                    const EdgeInsets.only(
                      right: 20,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),

                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),

                  child: Card(
                    color:
                    Colors.white.withOpacity(0.88),

                    elevation: 4,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),

                    child: TodoTile(
                      todo: todo,
                      onChanged: (_) =>
                          widget.onToggleTodo(
                            index,
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}