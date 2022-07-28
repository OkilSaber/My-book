// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_page.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookPageAdapter extends TypeAdapter<BookPage> {
  @override
  final int typeId = 0;

  @override
  BookPage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookPage(
      content: fields[0] as String,
      image: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BookPage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookPageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
