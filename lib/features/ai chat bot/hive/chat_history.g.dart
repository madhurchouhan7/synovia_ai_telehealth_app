// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatHistoryAdapter extends TypeAdapter<ChatHistory> {
  @override
  final int typeId = 0;

  @override
  ChatHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatHistory(
      chatId: fields[0] as String,
      prompts: fields[1] as String,
      response: fields[2] as String,
      imageUrls: (fields[3] as List).cast<String>(),
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatHistory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.prompts)
      ..writeByte(2)
      ..write(obj.response)
      ..writeByte(3)
      ..write(obj.imageUrls)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
