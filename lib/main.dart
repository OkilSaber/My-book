import 'package:flutter/material.dart';
import 'package:my_book/hive/init.dart';
import 'package:my_book/hive/models/book/book.dart';

void main() async {
  await hive.init();
  runApp(const MyBook());
}

class MyBook extends StatelessWidget {
  const MyBook({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Book',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("My Book"),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
