import 'package:aura_app/chat.dart';
import 'package:aura_app/ext.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_app/widgets/chat.dart';
import 'package:aura_app/widgets/loader.dart';
import 'package:aura_app/widgets/navbar.dart';
import 'package:aura_dart/chat.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<AuthService> authFut = ref.watch(authProvider.future).then((
      AuthService service,
    ) async {
      await service.refresh();
      return service;
    });

    final Future<Storage> storageFut = ref.watch(storageProvider.future);

    final Future<AuraClient> clientFut = ref.watch(auraClientProvider.future);

    return Scaffold(
      bottomNavigationBar: const Navbar(),
      body: Loader<((AuthService, Storage), AuraClient)>(
        authFut.join(storageFut).join(clientFut),
        (
          BuildContext context,
          WidgetRef ref,
          ((AuthService, Storage), AuraClient) loaderResult,
        ) {
          final ((AuthService auth, Storage storage), AuraClient client) =
              loaderResult;

          return Row(
            children: <Widget>[
              SizedBox(
                width: 300,
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    final Chat chat = storage.chatStorage.chats.values
                        .elementAt(i);
                    return ListTile(title: Text(chat.channel.name));
                  },
                  separatorBuilder: (BuildContext context, int i) =>
                      const Divider(),
                  itemCount: storage.chatStorage.chats.length,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: storage.chatStorage.chats.isEmpty
                    ? const Center(child: Text('No chats'))
                    : ChatMessageList(
                        chat: storage.chatStorage.chats.values.first,
                        loadOlder: (Timestamp startAt) async {
                          final Chat chat =
                              storage.chatStorage.chats.values.first;
                          final ReadResponse response = await client.chatService
                              .read(
                                ReadRequest(
                                  channelId: chat.channel.channelId,
                                  limit: maximumCachedMessages,
                                  startTime: startAt,
                                ),
                              );
                          return response.messages;
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
