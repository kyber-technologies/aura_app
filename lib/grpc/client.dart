import 'package:aura_dart/chat.dart';
import 'package:aura_dart/general.dart';
import 'package:aura_dart/resource.dart';
import 'package:aura_dart/user.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:grpc/service_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String host = String.fromEnvironment(
  'AURA_HOST',
  defaultValue: '127.0.0.1',
);

const int port = int.fromEnvironment('AURA_PORT', defaultValue: 50051);

final FutureProvider<AuraClient> auraClientProvider =
    FutureProvider<AuraClient>((Ref ref) async {
      final AuraClient client = AuraClient();

      await client.init();

      return client;
    });

class AuraClient {
  final ClientChannel channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
    host: host,
    port: port,
    transportSecure: true,
  );

  late final ChatServiceClient chatService = ChatServiceClient(channel);
  late final UserServiceClient userService = UserServiceClient(channel);
  late final ResourceServiceClient resourceService = ResourceServiceClient(
    channel,
  );
  late final GeneralServiceClient generalService = GeneralServiceClient(
    channel,
  );

  late final ConfigResponse config;

  Future<void> init() async {
    config = await generalService.config(ConfigRequest());
  }

  Future<void> dispose() async {
    await channel.shutdown();
  }
}
