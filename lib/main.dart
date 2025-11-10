import 'package:finite_todos/repositories/todo_repository.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'services/database_helper.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;

  TodoRepository().deleteExpiredTodos();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finite Todos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF13EC5B),
          brightness: Brightness.light,
        ).copyWith(
          surface: const Color(0xFFF6F8F6),
        ),
        fontFamily: 'Manrope',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF13EC5B),
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF102216),
        ),
        fontFamily: 'Manrope',
      ),
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}