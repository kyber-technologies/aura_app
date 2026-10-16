import 'dart:typed_data';

import 'package:aura_app/ext/common.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/widgets/dialogs.dart';
import 'package:aura_dart/common.dart';
import 'package:aura_dart/resource.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as paths;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

Future<FileData?> requestFile({required String title}) async {
  final FilePickerResult? result = await FilePicker.pickFiles(
    dialogTitle: title,
  );

  final PlatformFile? file = result?.files.firstOrNull;

  if (file != null) {
    return FileData(
      name: file.name,
      format: paths.extension(file.path ?? file.name),
      data: file.bytes ?? Uint8List(0),
    );
  }

  return null;
}

Future<Iterable<FileData>?> requestFiles({required String title}) async {
  final FilePickerResult? result = await FilePicker.pickFiles(
    dialogTitle: title,
    allowMultiple: true,
  );

  return result?.files.map(
    (PlatformFile file) => FileData(
      name: file.name,
      format: paths
          .extension(file.path ?? file.name)
          .replaceAll('.', '')
          .trim(),
      data: file.bytes ?? Uint8List(0),
    ),
  );
}

Future<FileData?> requestImage() async {
  final XFile? file = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );

  if (file != null) {
    return FileData.fromXFile(file);
  }

  return null;
}

class FileData {
  String name;
  String format;
  Uint8List data;

  FileData({required this.name, required this.format, required this.data});

  static Future<FileData> fromXFile(XFile file) async => FileData(
    name: file.name,
    format: paths.extension(file.path).replaceAll('.', '').trim(),
    data: await file.readAsBytes(),
  );

  Future<void> validateFormat(
    List<String> validFormats,
    BuildContext context,
  ) async {
    if (!validFormats.contains(format)) {
      await ErrorDialog(
        ServiceException(
          ServiceError(
            message: 'File format not supported: $format',
            invalidFormat: InvalidFormatError(),
          ),
        ),
        <ServiceErrorType, String>{
          ServiceErrorType.invalidFormat: context.l10n.invalidUploadFormat(
            format,
          ),
        },
      ).show(context);
    }
  }

  Stream<UploadRequest> createUploadStream({
    required ResourceNamespace namespace,
    required int chunkSize,
    String? name,
    void Function(int sentBytes, int totalBytes)? onProgress,
  }) async* {
    yield UploadRequest(
      namespace: namespace,
      meta: ResourceMeta(
        name: name ?? this.name,
        format: format,
        size: data.length,
        timestamp: Timestamp.fromDateTime(DateTime.now()),
      ),
    );

    int sentBytes = 0;

    for (int i = 0; i < data.length; i += chunkSize) {
      final int end = (i + chunkSize < data.length)
          ? i + chunkSize
          : data.length;
      final List<int> chunk = data.sublist(i, end);

      yield UploadRequest(data: chunk);

      sentBytes += chunk.length;
      onProgress?.call(sentBytes, data.length);
    }
  }
}
