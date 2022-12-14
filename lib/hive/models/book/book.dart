import 'package:hive/hive.dart';
import 'package:my_book/hive/models/page/book_page.dart';
part 'book.g.dart';

@HiveType(typeId: 1)
class Book {
  @HiveField(0)
  List<BookPage> pages;
  @HiveField(1)
  int latestPage;

  Book({required this.pages, required this.latestPage});
}
