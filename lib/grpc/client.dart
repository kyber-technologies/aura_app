import 'package:aura_dart/chat/v1/chat.pbgrpc.dart';
import 'package:aura_dart/resource/v1/resource.pbgrpc.dart';
import 'package:aura_dart/user/v1/user.pbgrpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:grpc/service_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String host = String.fromEnvironment(
  'AURA_HOST',
  defaultValue: '127.0.0.1',
);

const int port = int.fromEnvironment('AURA_PORT', defaultValue: 50051);

const bool transportSecure = bool.fromEnvironment(
  'AURA_SECURE',
  // defaultValue: false,
);

final Provider<AuraClient> auraClientProvider = Provider<AuraClient>(
  (Ref ref) => AuraClient(),
);

class AuraClient {
  final ClientChannel channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
    host: host,
    port: port,
    transportSecure: transportSecure,
  );

  ChatServiceClient chatService() => ChatServiceClient(channel);

  UserServiceClient userService() => UserServiceClient(channel);

  ResourceServiceClient resourceService() => ResourceServiceClient(channel);

  Future<void> dispose() async {
    await channel.shutdown();
  }
}
