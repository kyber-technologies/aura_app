import 'package:aura_app/chat.dart';
import 'package:aura_dart/chat.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

class ChatMessageList extends StatefulWidget {
  final Chat chat;

  final Future<List<Message>> Function(Timestamp startAt) loadOlder;

  const ChatMessageList({
    required this.chat,
    required this.loadOlder,
    super.key,
  });

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  final ScrollController _scrollController = ScrollController();

  bool _loadingOlder = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent) {
      await _loadOlderMessages();
    }
  }

  Future<void> _loadOlderMessages() async {
    if (_loadingOlder || !_hasMore || widget.chat.messages.isEmpty) {
      return;
    }

    _loadingOlder = true;

    try {
      final Message oldest = widget.chat.messages.first;

      final List<Message> older = await widget.loadOlder(oldest.createdAt);

      if (!mounted) {
        return;
      }

      setState(() {
        if (older.isEmpty) {
          _hasMore = false;
          return;
        }

        widget.chat.messages.insertAll(0, older.reversed);
      });
    } finally {
      _loadingOlder = false;
    }
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
    controller: _scrollController,
    itemCount: widget.chat.messages.length + (_loadingOlder ? 1 : 0),
    itemBuilder: (BuildContext context, int index) {
      if (index == widget.chat.messages.length) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final Message message = widget.chat.messages[index];

      return ChatMessageTile(message: message);
    },
  );
}

class ChatMessageTile extends StatelessWidget {
  final Message message;

  const ChatMessageTile({required this.message, super.key});

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(message.userId),
    subtitle: Text(message.content.toString()),
  );
}
