import 'package:aura_dart/common/v1/common.pb.dart' as common;

typedef ServiceError = common.Error;

class ServiceException implements Exception {
  final ServiceError error;

  ServiceException(this.error);

  @override
  String toString() => '${error.code}: ${error.message}';
}
