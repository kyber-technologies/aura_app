import 'dart:convert';

import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_dart/chat.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

const int requestChatLimit = 16;
const int _maximumCachedMessages = 64;

Future<List<Chat>> requestChats(WidgetRef ref) async {
  final AuthService authService = await ref.read(authProvider.future);
  final AuraClient client = await ref.read(auraClientProvider.future);

  return await authService.user.channels.map((Channel channel) async {
    final ReadResponse response = await client.chatService.read(
      ReadRequest(
        channelId: channel.channelId,
        limit: requestChatLimit,
        startTime: Timestamp.fromDateTime(DateTime.timestamp()),
      ),
    );

    return Chat(channel: channel, messages: response.messages);
  }).wait;
}

class ChatStorage {
  Map<String, Chat> chats;

  static ChatStorage defaultValue() => ChatStorage(<String, Chat>{});

  ChatStorage(this.chats);

  static ChatStorage fromJson(Map<String, dynamic> json) {
    final Map<String, Chat> chats = json.map(
      (String key, dynamic value) => MapEntry<String, Chat>(
        key,
        Chat.fromJson(value as Map<String, dynamic>),
      ),
    );

    return ChatStorage(chats);
  }

  Map<String, dynamic> toJson() => chats.map(
    (String key, Chat chat) => MapEntry<String, dynamic>(key, chat.toJson()),
  );
}

class Chat {
  final Channel channel;
  final List<Message> _messages;

  List<Message> get messages => _messages;

  Chat({required this.channel, required this._messages});

  static Chat fromJson(Map<String, dynamic> json) => Chat(
    channel: Channel.fromBuffer(base64Decode(json['channel'] as String)),
    messages: (json['messages'] as List<dynamic>)
        .map((dynamic item) => Message.fromBuffer(base64Decode(item as String)))
        .toList(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'channel': base64Encode(channel.writeToBuffer()),
    'messages': _messages
        .map((Message x) => base64Encode(x.writeToBuffer()))
        .toList(),
  };

  void addMessage(Message message) {
    if (_messages.length >= _maximumCachedMessages) {
      _messages.removeAt(0);
    }

    _messages.add(message);
  }
}
