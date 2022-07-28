import 'package:flutter/material.dart';
import 'package:my_book/hive/init.dart';
import 'package:my_book/hive/models/book/book.dart';
import 'package:my_book/hive/models/page/book_page.dart';

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
  int currentPageIndex = 0;
  TextEditingController inputController = TextEditingController();
  bool isImage = false;
  late Book book;

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Book? boxBook = hive.box.get("book");
    if (boxBook == null) {
      Book newBook = Book(pages: [], latestPage: 0);
      hive.box.put("book", newBook);
      book = newBook;
    } else {
      book = boxBook;
    }
  }

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
            onPressed: () {
              showInputDialog();
            },
            icon: const Icon(Icons.add_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) => Text(book.pages[index].content),
          itemCount: book.pages.length,
        ),
      ),
    );
  }

  void showInputDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Create a new page"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: inputController,
                  decoration: const InputDecoration(labelText: "Your text"),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              CheckboxListTile(
                title: const Text("Is it an image URL?"),
                value: isImage,
                onChanged: (bool? value) {
                  setState(() {
                    isImage = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (inputController.text.isEmpty) {
                  showCreationErrorDialog();
                } else {
                  setState(
                    () {
                      book.pages.add(
                        BookPage(
                          content: inputController.text,
                          image: isImage,
                        ),
                      );
                      isImage = false;
                      inputController.clear();
                    },
                  );
                  hive.box.put("book", book);
                  Navigator.pop(context);
                }
              },
              child: const Text("Validate"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }

  void showCreationErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text("Please enter a text or URL"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
