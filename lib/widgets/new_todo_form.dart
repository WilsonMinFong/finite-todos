import 'package:flutter/material.dart';

class NewTodoForm extends StatefulWidget {
  const NewTodoForm({super.key, required this.onTodoAdded});

  final Function(String) onTodoAdded;

  @override
  State<NewTodoForm> createState() => _NewTodoFormState();
}

class _NewTodoFormState extends State<NewTodoForm> {
  final newTodoFormController = TextEditingController();

  void _handleSubmitted(String value) {
    if (value.isNotEmpty) {
      widget.onTodoAdded(value);
      newTodoFormController.clear();
    }
  }

  @override
  void dispose() {
    newTodoFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newTodoFormController,
      onSubmitted: _handleSubmitted,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a todo list item',
      ),
    );
  }
}
