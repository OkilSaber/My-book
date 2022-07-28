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
  TextEditingController inputController = TextEditingController();
  late PageController pageController;
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
    pageController = PageController(initialPage: book.latestPage);
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
            onPressed: () {
              setState(() {
                book = Book(pages: [], latestPage: 0);
              });
              hive.box.put("book", book);
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: book.pages.isEmpty
          ? const Center(
              child: Text("No Page created!"),
            )
          : PageView(
              controller: pageController,
              onPageChanged: (value) => setState(
                () {
                  book.latestPage = value;
                },
              ),
              children: book.pages.map((page) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: page.image
                            ? Image.network(page.content)
                            : SingleChildScrollView(
                                child: Text(page.content),
                              ),
                      ),
                      Center(
                        child: FloatingActionButton(
                          onPressed: () {},
                          child: Text(
                              "${book.latestPage + 1}/${book.pages.length}"),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
    ).then((value) async {
      Book newBook = await hive.box.get("book");
      setState(() {
        book = newBook;
      });
    });
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
