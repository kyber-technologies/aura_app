import 'package:aura_app/ext/common.dart';
import 'package:aura_app/ext/grpc.dart';
import 'package:aura_app/ext/widgets.dart';
import 'package:aura_app/files.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/grpc/resources.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_app/utils.dart';
import 'package:aura_app/widgets/avatar.dart';
import 'package:aura_app/widgets/dialogs.dart';
import 'package:aura_app/widgets/loader.dart';
import 'package:aura_app/widgets/navbar.dart';
import 'package:aura_app/widgets/overlay.dart';
import 'package:aura_app/widgets/tag_list.dart';
import 'package:aura_app/widgets/tile.dart';
import 'package:aura_dart/resource.dart';
import 'package:aura_dart/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<Settings> localSettings = ref.watch(
      storageProvider.selectAsync((Storage storage) => storage.settings),
    );
    final Future<AuthService> authFut = ref.watch(authProvider.future);

    final ValueNotifier<String?> newProfileUsername = useState(null);
    final ValueNotifier<String?> newProfileAbout = useState(null);
    final ValueNotifier<String?> newProfileEmail = useState(null);
    final ValueNotifier<String?> newProfileEmailToken = useState(null);
    final ValueNotifier<Image?> newProfileAvatar = useState(null);

    final ValueNotifier<bool?> allowInvites = useState<bool?>(null);

    final ValueNotifier<bool?> darkMode = useState<bool?>(null);
    final ValueNotifier<bool?> animations = useState<bool?>(null);

    final ValueNotifier<bool?> notifyInvite = useState<bool?>(null);
    final ValueNotifier<bool?> notifyMessage = useState<bool?>(null);
    final ValueNotifier<bool?> notifyComment = useState<bool?>(null);

    final ValueNotifier<double?> algoLikeWeight = useState<double?>(null);
    final ValueNotifier<double?> algoDislikeWeight = useState<double?>(null);
    final ValueNotifier<double?> algoCommentWeight = useState<double?>(null);
    final ValueNotifier<double?> algoTimeDecay = useState<double?>(null);

    final ValueNotifier<Set<String>> resetAlgoTags = useState(<String>{});

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => _saveSettings(
          context,
          ref,
          username: newProfileUsername.value,
          about: newProfileAbout.value,
          email: newProfileEmail.value,
          token: newProfileEmailToken.value,
          darkMode: darkMode.value,
          animations: animations.value,
          allowInvites: allowInvites.value,
          algoLikeWeight: algoLikeWeight.value,
          algoDislikeWeight: algoDislikeWeight.value,
          algoCommentWeight: algoCommentWeight.value,
          algoTimeDecay: algoTimeDecay.value,
          notifyInvite: notifyInvite.value,
          notifyMessage: notifyMessage.value,
          notifyComment: notifyComment.value,
        ),
        label: Text(context.l10n.save),
        icon: const Icon(Icons.save),
      ),
      bottomNavigationBar: const Navbar(),
      body: Loader<(Settings, AuthService)>((localSettings, authFut).wait, (
        BuildContext context,
        WidgetRef ref,
        (Settings, AuthService) result,
      ) {
        final Settings settings = result.$1;
        final AuthService auth = result.$2;

        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: <Widget>[
                  // PROFILE
                  Card(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Text(context.l10n.profile).headlineSmall(context),
                        const SizedBox(height: 10),
                        Tile(
                          title: Text(context.l10n.allowInvites).title(context),
                          tooltip: context.l10n.allowInvitesDesc,
                          content: Checkbox(
                            value:
                                allowInvites.value ??
                                auth.user.settings.allowInvites,
                            onChanged: (bool? value) {
                              allowInvites.value = value;
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        Tile(
                          spacing: 10,
                          title: Text(
                            context.l10n.profileUsername,
                          ).title(context),
                          tooltip: context.l10n.profileUsernameDesc,
                          content: OverlayButton(
                            onTap: () async {
                              await EditDialog(
                                label: context.l10n.newProfileUsername,
                                validator: (String? text) =>
                                    (text?.isEmpty ?? true)
                                    ? context.l10n.usernameInvalid
                                    : null,
                                onSubmit: (String changed) {
                                  newProfileUsername.value = changed;
                                },
                              ).show(context);
                            },
                            overlayChild: const Icon(Icons.edit),
                            child: Text(
                              newProfileUsername.value ?? auth.user.username,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Tile(
                          spacing: 10,
                          title: Text(context.l10n.profileAbout).title(context),
                          tooltip: context.l10n.profileAboutDesc,
                          content: OverlayButton(
                            onTap: () async {
                              await EditDialog(
                                label: context.l10n.newProfileAbout,
                                onSubmit: (String changed) {
                                  newProfileAbout.value = changed;
                                },
                                multiline: true,
                              ).show(context);
                            },
                            overlayChild: const Icon(Icons.edit),
                            child: Text(
                              (newProfileAbout.value ?? auth.user.about).isEmpty
                                  ? context.l10n.noAbout
                                  : newProfileAbout.value ?? auth.user.about,
                            ).contentBox(context),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Tile(
                          spacing: 10,
                          title: Text(context.l10n.profileEmail).title(context),
                          tooltip: context.l10n.profileEmailDesc,
                          content: OverlayButton(
                            onTap: () async {
                              await EditDialog(
                                barrierDismissable: false,
                                label: context.l10n.newProfileEmail,
                                validator: (String? text) =>
                                    ((text?.isNotEmpty ?? true) &&
                                        isValidEmail(text ?? ''))
                                    ? null
                                    : context.l10n.emailInvalid,
                                onSubmit: (String changed) {
                                  newProfileEmail.value = changed;
                                },
                              ).show(context);

                              if (newProfileEmail.value != null) {
                                final AuraClient client = await ref.read(
                                  auraClientProvider.future,
                                );

                                logger.i(
                                  'Sending email verification request...',
                                );
                                final VerifyEmailResponse verifyResp =
                                    await client.userService.verifyEmail(
                                      VerifyEmailRequest(
                                        email: newProfileEmail.value,
                                      ),
                                    );

                                if (verifyResp.hasError() && context.mounted) {
                                  await ErrorDialog(
                                    ServiceException(verifyResp.error),
                                    const <ServiceErrorType, String>{},
                                  ).show(context);
                                }

                                if (context.mounted) {
                                  await EditDialog(
                                    barrierDismissable: false,
                                    label: context.l10n.verifyEmailBody(
                                      newProfileEmail.value ?? '',
                                    ),
                                    onSubmit: (String text) {
                                      newProfileEmailToken.value = text;
                                    },
                                    validator: (String? text) =>
                                        (text ?? '').isEmpty
                                        ? context.l10n.noEmailTokenInvalid
                                        : null,
                                    onCancel: () {
                                      newProfileEmail.value = null;
                                      newProfileEmailToken.value = null;
                                    },
                                  ).show(context);
                                }
                              } else {
                                newProfileEmail.value = null;
                                newProfileEmailToken.value = null;
                              }
                            },
                            overlayChild: const Icon(Icons.edit),
                            child: Text(
                              newProfileEmail.value ?? auth.user.email,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Tile(
                          spacing: 10,
                          title: Text(context.l10n.profileIcon).title(context),
                          tooltip: context.l10n.profileIconDesc,
                          content: OverlayButton(
                            overlayChild: const Icon(Icons.edit),
                            borderRadius: 25,
                            onTap: () async {
                              await _buildUploadAvatarDialog(
                                context,
                                ref,
                                auth,
                                newProfileAvatar,
                              ).show<void>(context);
                            },
                            child: newProfileAvatar.value == null
                                ? Avatar(
                                    auth.user.userId,
                                    width: 25.sp,
                                    height: 25.sp,
                                  )
                                : Avatar.image(
                                    newProfileAvatar.value,
                                    width: 25.sp,
                                    height: 25.sp,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  // APPEARANCE
                  Card(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Text(context.l10n.appearance).headlineSmall(context),
                        const SizedBox(height: 10),
                        Tile(
                          title: Text(context.l10n.darkMode).title(context),
                          tooltip: context.l10n.darkModeDesc,
                          content: Checkbox(
                            value: darkMode.value ?? settings.darkMode,
                            onChanged: (bool? value) {
                              darkMode.value = value;
                            },
                          ),
                        ),
                        Tile(
                          title: Text(context.l10n.animations).title(context),
                          tooltip: context.l10n.animationsDesc,
                          content: Checkbox(
                            value: animations.value ?? settings.animations,
                            onChanged: (bool? value) {
                              animations.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // NOTIFICATIONS
                  Card(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Text(context.l10n.notifications).headlineSmall(context),
                        const SizedBox(height: 10),
                        Tile(
                          title: Text(
                            context.l10n.notifyInvites,
                          ).title(context),
                          tooltip: context.l10n.notifyInvitesDesc,
                          content: Checkbox(
                            value:
                                notifyInvite.value ??
                                auth.user.settings.notifyInvite,
                            onChanged: (bool? value) {
                              notifyInvite.value = value;
                            },
                          ),
                        ),
                        Tile(
                          title: Text(
                            context.l10n.notifyMessages,
                          ).title(context),
                          tooltip: context.l10n.notifyMessagesDesc,
                          content: Checkbox(
                            value:
                                notifyMessage.value ??
                                auth.user.settings.notifyMessage,
                            onChanged: (bool? value) {
                              notifyMessage.value = value;
                            },
                          ),
                        ),
                        Tile(
                          title: Text(
                            context.l10n.notifyComments,
                          ).title(context),
                          tooltip: context.l10n.notifyCommentsDesc,
                          content: Checkbox(
                            value:
                                notifyComment.value ??
                                auth.user.settings.notifyComment,
                            onChanged: (bool? value) {
                              notifyComment.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ALGORITHM
                  Card(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Text(context.l10n.algorithm).headlineSmall(context),
                        const SizedBox(height: 10),
                        Tile(
                          title: Text(
                            context.l10n.algoLikeWeight,
                          ).title(context),
                          tooltip: context.l10n.algoLikeWeightDesc,
                          content: Row(
                            children: <Widget>[
                              Text(
                                (algoLikeWeight.value ??
                                        auth.user.settings.algoLikeWeight)
                                    .toStringAsFixed(2),
                              ),
                              Expanded(
                                child: Slider(
                                  divisions: 20,
                                  value:
                                      algoLikeWeight.value ??
                                      auth.user.settings.algoLikeWeight,
                                  onChanged: (double value) {
                                    algoLikeWeight.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tile(
                          title: Text(
                            context.l10n.algoDislikeWeight,
                          ).title(context),
                          tooltip: context.l10n.algoDislikeWeightDesc,
                          content: Row(
                            children: <Widget>[
                              Text(
                                (algoDislikeWeight.value ??
                                        auth.user.settings.algoDislikeWeight)
                                    .toStringAsFixed(2),
                              ),
                              Expanded(
                                child: Slider(
                                  divisions: 20,
                                  value:
                                      algoDislikeWeight.value ??
                                      auth.user.settings.algoDislikeWeight,
                                  onChanged: (double value) {
                                    algoDislikeWeight.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tile(
                          title: Text(
                            context.l10n.algoCommentWeight,
                          ).title(context),
                          tooltip: context.l10n.algoCommentWeightDesc,
                          content: Row(
                            children: <Widget>[
                              Text(
                                (algoCommentWeight.value ??
                                        auth.user.settings.algoCommentWeight)
                                    .toStringAsFixed(2),
                              ),
                              Expanded(
                                child: Slider(
                                  divisions: 20,
                                  value:
                                      algoCommentWeight.value ??
                                      auth.user.settings.algoCommentWeight,
                                  onChanged: (double value) {
                                    algoCommentWeight.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tile(
                          title: Text(
                            context.l10n.algoTimeDecay,
                          ).title(context),
                          tooltip: context.l10n.algoTimeDecayDesc,
                          content: Row(
                            children: <Widget>[
                              Text(
                                (algoTimeDecay.value ??
                                        auth.user.settings.algoTimeDecay)
                                    .toStringAsFixed(2),
                              ),
                              Expanded(
                                child: Slider(
                                  divisions: 20,
                                  value:
                                      algoTimeDecay.value ??
                                      auth.user.settings.algoTimeDecay,
                                  onChanged: (double value) {
                                    algoTimeDecay.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.icon(
                          onPressed: () async {
                            await _buildResetAlgoDialog(
                              context,
                              ref,
                              auth,
                              resetAlgoTags,
                            ).show<void>(context);
                          },
                          label: Text(context.l10n.resetAlgo),
                          icon: const Icon(Icons.restart_alt),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

Dialog _buildResetAlgoDialog(
  BuildContext context,
  WidgetRef ref,
  AuthService auth,
  ValueNotifier<Set<String>> resetAlgoTags,
) => Dialog(
  child: ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 280, maxWidth: 500),
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            context.l10n.tagsDesc,
            textAlign: TextAlign.center,
          ).titleLarge(context),
          const SizedBox(height: 12),
          TagList(
            onChanged: (Set<String> tags) {
              resetAlgoTags.value = Set<String>.from(tags);
            },
          ),
          const SizedBox(height: 8),
          if (resetAlgoTags.value.isEmpty)
            Text(
              context.l10n.noTagsSpecified,
              textAlign: TextAlign.center,
            ).title(context).error(context),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              if (resetAlgoTags.value.isNotEmpty) {
                await _buildConfirmResetAlgoDialog(
                  context,
                  ref,
                  auth,
                  resetAlgoTags,
                ).show<void>(context);
              }
            },
            child: Text(context.l10n.resetAlgo),
          ),
        ],
      ),
    ),
  ),
);

Dialog _buildUploadAvatarDialog(
  BuildContext context,
  WidgetRef ref,
  AuthService auth,
  ValueNotifier<Image?> newProfileAvatar,
) {
  final ValueNotifier<double?> uploadProgress = ValueNotifier<double?>(null);

  return Dialog(
    child: ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 300, maxWidth: 450),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: <Widget>[
            Text(context.l10n.profileIcon).titleLarge(context),

            if (newProfileAvatar.value == null)
              Avatar(auth.user.userId, width: 30.sp, height: 30.sp)
            else
              Avatar.image(
                newProfileAvatar.value!,
                width: 30.sp,
                height: 30.sp,
              ),

            Text(
              context.l10n.profileIconDesc,
              textAlign: TextAlign.center,
            ).body(context),

            ValueListenableBuilder<double?>(
              valueListenable: uploadProgress,
              builder: (BuildContext context, double? progress, Widget? child) {
                if (progress == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: <Widget>[
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                    ).body(context),
                  ],
                );
              },
            ),

            Builder(
              builder: (BuildContext dialogContext) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: uploadProgress.value != null
                        ? null
                        : () async {
                            logger.i('Selecting new avatar file...');

                            final AuraClient client = await ref.read(
                              auraClientProvider.future,
                            );

                            final FileData? image = await requestImage();

                            if (image != null) {
                              if (context.mounted) {
                                await image.validateFormat(
                                  client.config.supportedResourceFormats,
                                  context,
                                );
                              }

                              uploadProgress.value = 0.0;

                              final UploadResponse resp = await client
                                  .resourceService
                                  .upload(
                                    image.createUploadStream(
                                      namespace: ResourceNamespace(
                                        userIcon: Empty(),
                                      ),
                                      chunkSize:
                                          client.config.resourceChunkSize,
                                      name: auth.user.userId,
                                      onProgress: (int sent, int total) {
                                        uploadProgress.value = sent / total;
                                      },
                                    ),
                                    options: auth.buildOptions(),
                                  );

                              if (resp.hasError() && context.mounted) {
                                uploadProgress.value = null;
                                await ErrorDialog(
                                  ServiceException(resp.error),
                                  const <ServiceErrorType, String>{},
                                ).show(context);
                                return;
                              }

                              final ResourceManager resourceManager = await ref
                                  .read(resourceProvider.future);

                              await resourceManager.delete(
                                ResourceId(
                                  namespace: ResourceNamespace(
                                    userIcon: Empty(),
                                  ),
                                  key: auth.user.userId,
                                ),
                              );

                              newProfileAvatar.value = Image.memory(image.data);

                              if (dialogContext.mounted) {
                                Navigator.of(dialogContext).pop();
                              }
                            }
                          },
                    label: Text(context.l10n.upload),
                    icon: const Icon(Icons.upload),
                  ),
                  TextButton(
                    onPressed: uploadProgress.value != null
                        ? null
                        : () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      context.l10n.cancel,
                    ).title(context).error(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

AlertDialog _buildConfirmResetAlgoDialog(
  BuildContext context,
  WidgetRef ref,
  AuthService auth,
  ValueNotifier<Set<String>> resetAlgoTags,
) => AlertDialog(
  title: Text(context.l10n.resetAlgoConfirm).titleLarge(context),
  content: Text(context.l10n.resetAlgoConfirmBody).title(context),
  actions: <Widget>[
    FilledButton.icon(
      onPressed: () async {
        final AuraClient client = await ref.read(auraClientProvider.future);

        logger.i('Resetting user algo...');
        final UpdateResponse resp = await client.userService.update(
          UpdateRequest(
            settings: auth.user.settings.update(
              resetAlgoTags: resetAlgoTags.value.toList(),
            ),
          ),
          options: auth.buildOptions(),
        );

        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }

        if (resp.hasError() && context.mounted) {
          logger.e('Failed to reset user algo: ${resp.error}');
          await ErrorDialog(
            ServiceException(resp.error),
            const <ServiceErrorType, String>{},
          ).show(context);
        }

        resetAlgoTags.value.clear();
      },
      label: Text(context.l10n.yes),
      icon: const Icon(Icons.check),
    ),
    FilledButton.icon(
      onPressed: () {
        resetAlgoTags.value.clear();
        Navigator.pop(context);
        Navigator.pop(context);
      },
      label: Text(context.l10n.no),
      icon: const Icon(Icons.close),
    ),
  ],
);

Future<void> _saveSettings(
  BuildContext context,
  WidgetRef ref, {
  required String? username,
  required String? about,
  required String? email,
  required String? token,
  required bool? darkMode,
  required bool? animations,
  required bool? allowInvites,
  required double? algoLikeWeight,
  required double? algoDislikeWeight,
  required double? algoCommentWeight,
  required double? algoTimeDecay,
  required bool? notifyInvite,
  required bool? notifyMessage,
  required bool? notifyComment,
}) async {
  final AuraClient client = await ref.read(auraClientProvider.future);
  final AuthService auth = await ref.read(authProvider.future);
  final StorageNotifier storage = await ref.read(storageProvider.notifier);
  final Storage storageProv = await ref.read(storageProvider.future);

  if (storageProv.settings.isDirty(
    darkMode: darkMode,
    animations: animations,
  )) {
    logger.i('Updating local settings...');
    await storage.updateSettings((Settings settings) {
      settings
        ..darkMode = darkMode ?? settings.darkMode
        ..animations = animations ?? settings.animations;
    });
  }

  if (auth.user.settings.isDirty(
        allowInvites: allowInvites,
        algoLikeWeight: algoLikeWeight,
        algoDislikeWeight: algoDislikeWeight,
        algoCommentWeight: algoCommentWeight,
        algoTimeDecay: algoTimeDecay,
        notifyInvite: notifyInvite,
        notifyMessage: notifyMessage,
        notifyComment: notifyComment,
      ) ||
      auth.user.username != username ||
      auth.user.about != about ||
      auth.user.email != email) {
    final UserSettings userSettings = auth.user.settings.deepCopy();

    logger.i('Updating user settings...');
    final UpdateResponse resp = await client.userService.update(
      UpdateRequest(
        username: username,
        about: about,
        email: email,
        token: token,
        settings: userSettings.update(
          allowInvites: allowInvites,
          algoLikeWeight: algoLikeWeight,
          algoDislikeWeight: algoDislikeWeight,
          algoCommentWeight: algoCommentWeight,
          algoTimeDecay: algoTimeDecay,
          notifyInvite: notifyInvite,
          notifyMessage: notifyMessage,
          notifyComment: notifyComment,
        ),
      ),
      options: auth.buildOptions(),
    );

    if (resp.hasError() && context.mounted) {
      await ErrorDialog(
        ServiceException(resp.error),
        <ServiceErrorType, String>{
          // TODO: Better message
          ServiceErrorType.unauthorized: context.l10n.emailTokenInvalid,
        },
      ).show(context);
    }

    await auth.refresh();
  }
}
