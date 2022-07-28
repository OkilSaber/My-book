import 'package:hive/hive.dart';
part 'book_page.g.dart';

@HiveType(typeId: 0)
class BookPage {
  @HiveField(0)
  String content;
  @HiveField(1)
  bool image;

  BookPage({required this.content, required this.image});
}
