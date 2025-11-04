import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finite Todos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Finite Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _todos = [];

  void _addTodo(item) {
    setState(() {
      _todos.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: NewTodoForm(onTodoAdded: _addTodo),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_todos[index]),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('You have ${_todos.length} todos left.'),
            ),
          ],
        ),
      ),
    );
  }
}

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