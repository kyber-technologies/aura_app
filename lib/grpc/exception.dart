import 'package:aura_dart/common.dart' as common;

typedef ServiceError = common.Error;
typedef ServiceErrorType = common.Error_Type;

class ServiceException implements Exception {
  final ServiceError error;

  ServiceException(this.error);

  @override
  String toString() => '${error.code()}: ${error.message}';
}

extension ErrorExt on ServiceError {
  String code() {
    switch (whichType()) {
      case common.Error_Type.internal:
        return 'INTERNAL';
      case common.Error_Type.unauthorized:
        return 'UNAUTHORIZED';
      case common.Error_Type.notFound:
        return 'NOT_FOUND';
      case common.Error_Type.alreadyExists:
        return 'ALREADY_EXISTS';
      case common.Error_Type.invalidFormat:
        return 'INVALID_FORMAT';
      case common.Error_Type.restricted:
        return 'RESTRICTED';
      case common.Error_Type.unwanted:
        return 'UNWANTED';
      case common.Error_Type.rateLimit:
        return 'RATE_LIMIT';
      case common.Error_Type.notSet:
        return 'NOT_SET';
    }
  }
}
