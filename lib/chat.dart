import 'dart:convert';

import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_dart/chat.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

const int maximumCachedMessages = 16;

Future<List<Chat>> requestChats(WidgetRef ref) async {
  final AuthService authService = await ref.read(authProvider.future);
  final AuraClient client = await ref.read(auraClientProvider.future);

  return await authService.user.channels.map((Channel channel) async {
    final ReadResponse response = await client.chatService.read(
      ReadRequest(
        channelId: channel.channelId,
        limit: maximumCachedMessages,
        startTime: Timestamp.fromDateTime(DateTime.timestamp()),
      ),
    );

    return Chat(channel: channel, messages: response.messages);
  }).wait;
}

class Chat {
  final Channel channel;
  final List<Message> _messages;

  List<Message> get messages => _messages;

  Chat({required this.channel, required this._messages});

  static Chat fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;

    return Chat(
      channel: Channel.fromJson(map['channel'] as String),
      messages: (map['messages'] as List<String>)
          .map(Message.fromJson)
          .toList(),
    );
  }

  String toJson() => jsonEncode(<String, dynamic>{
    'channel': channel.writeToJsonMap(),
    'messages': _messages.map((Message x) => x.writeToJsonMap()).toList(),
  });

  void addMessage(Message message, bool ignoreCache) {
    if (!ignoreCache && _messages.length >= maximumCachedMessages) {
      _messages.removeAt(0);
    }
    _messages.add(message);
  }
}
