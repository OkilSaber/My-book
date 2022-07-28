import 'package:hive/hive.dart';
part 'page.g.dart';

@HiveType(typeId: 0)
class Page {
  @HiveField(0)
  String content;
  @HiveField(1)
  bool image;

  Page({required this.content, required this.image});
}
