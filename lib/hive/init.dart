import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_book/hive/models/book/book.dart';
import 'package:my_book/hive/models/page/book_page.dart';

MyHive hive = MyHive();

class MyHive {
  late Box box;
  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BookPageAdapter());
      Hive.registerAdapter(BookAdapter());
    }
    box = await Hive.openBox('myBook');
  }
}
