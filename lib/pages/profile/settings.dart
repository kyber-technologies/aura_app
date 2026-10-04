import 'package:aura_app/ext.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/sizer.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_app/widgets/error_dialog.dart';
import 'package:aura_app/widgets/loader.dart';
import 'package:aura_app/widgets/navbar.dart';
import 'package:aura_app/widgets/scrollview.dart';
import 'package:aura_app/widgets/tag_list.dart';
import 'package:aura_app/widgets/tile.dart';
import 'package:aura_dart/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Sizer sizer = useSizer(context);

    final Future<Settings> localSettings = ref.watch(
      storageProvider.selectAsync((Storage storage) => storage.settings),
    );
    final Future<AuthService> authFut = ref.watch(authProvider.future);

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
        onPressed: () async {
          final AuraClient client = await ref.read(auraClientProvider.future);
          final AuthService auth = await ref.read(authProvider.future);
          final StorageNotifier storage = await ref.read(
            storageProvider.notifier,
          );

          if (auth.user.settings.allowInvites != allowInvites.value ||
              auth.user.settings.notifyInvite != notifyInvite.value ||
              auth.user.settings.notifyComment != notifyComment.value ||
              auth.user.settings.notifyMessage != notifyMessage.value ||
              auth.user.settings.algoLikeWeight != algoLikeWeight.value ||
              auth.user.settings.algoDislikeWeight != algoDislikeWeight.value ||
              auth.user.settings.algoCommentWeight != algoCommentWeight.value ||
              auth.user.settings.algoTimeDecay != algoTimeDecay.value) {
            logger.i('Updating local settings...');
            await storage.updateSettings((Settings settings) {
              if (darkMode.value != null) {
                settings.darkMode = darkMode.value!;
              }

              if (animations.value != null) {
                settings.animations = animations.value!;
              }
            });

            logger.i('Updating user settings...');
            final UpdateResponse resp = await client.userService.update(
              UpdateRequest(
                settings: UserSettings(
                  allowInvites: allowInvites.value,
                  notifyInvite: notifyInvite.value,
                  notifyMessage: notifyMessage.value,
                  notifyComment: notifyComment.value,
                  algoLikeWeight: algoLikeWeight.value,
                  algoDislikeWeight: algoDislikeWeight.value,
                  algoCommentWeight: algoCommentWeight.value,
                  algoTimeDecay: algoTimeDecay.value,
                ),
              ),
              options: auth.buildOptions(),
            );

            if (resp.hasError() && context.mounted) {
              await ErrorDialog(
                ServiceException(resp.error),
                Map<ServiceErrorType, String>.identity(),
              ).show(context);
            }

            await auth.refresh();
          }
        },
        label: Text(context.l10n.save),
        icon: const Icon(Icons.save),
      ),
      bottomNavigationBar: const Navbar(),
      body: Loader<(Settings, AuthService)>(localSettings.join(authFut), (
        BuildContext context,
        WidgetRef ref,
        (Settings, AuthService) result,
      ) {
        final Settings settings = result.$1;
        final AuthService auth = result.$2;

        return Center(
          child: FullScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 25),
                // GENERAL
                Card(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(context.l10n.general).headlineSmall(context),
                      const SizedBox(height: 5),
                      Tile(
                        title: Text(context.l10n.allowInvites).title(context),
                        tooltip: context.l10n.allowInvitesDesc,
                        width: sizer.wp(0.9),
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
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // APPEARANCE
                Card(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(context.l10n.appearance).headlineSmall(context),
                      const SizedBox(height: 5),
                      Tile(
                        title: Text(context.l10n.darkMode).title(context),
                        tooltip: context.l10n.darkModeDesc,
                        width: sizer.wp(0.9),
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
                        width: sizer.wp(0.9),
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
                const SizedBox(height: 25),
                // NOTIFICATIONS
                Card(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(context.l10n.notifications).headlineSmall(context),
                      const SizedBox(height: 5),
                      Tile(
                        title: Text(context.l10n.notifyInvites).title(context),
                        tooltip: context.l10n.notifyInvitesDesc,
                        width: sizer.wp(0.9),
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
                        title: Text(context.l10n.notifyMessages).title(context),
                        tooltip: context.l10n.notifyMessagesDesc,
                        width: sizer.wp(0.9),
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
                        title: Text(context.l10n.notifyComments).title(context),
                        tooltip: context.l10n.notifyCommentsDesc,
                        width: sizer.wp(0.9),
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
                const SizedBox(height: 25),
                // ALGORITHM
                Card(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(context.l10n.algorithm).headlineSmall(context),
                      const SizedBox(height: 5),
                      Tile(
                        title: Text(context.l10n.algoLikeWeight).title(context),
                        tooltip: context.l10n.algoLikeWeightDesc,
                        width: sizer.wp(0.9),
                        content: Row(
                          children: <Widget>[
                            Text(
                              (algoLikeWeight.value ??
                                      auth.user.settings.algoLikeWeight)
                                  .toStringAsFixed(2),
                            ),
                            sizer.box(
                              w: 100,
                              h: 10,
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
                      const SizedBox(height: 5),
                      Tile(
                        title: Text(
                          context.l10n.algoDislikeWeight,
                        ).title(context),
                        tooltip: context.l10n.algoDislikeWeightDesc,
                        width: sizer.wp(0.9),
                        content: Row(
                          children: <Widget>[
                            Text(
                              (algoDislikeWeight.value ??
                                      auth.user.settings.algoDislikeWeight)
                                  .toStringAsFixed(2),
                            ),
                            sizer.box(
                              w: 100,
                              h: 10,
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
                      const SizedBox(height: 5),
                      Tile(
                        title: Text(
                          context.l10n.algoCommentWeight,
                        ).title(context),
                        tooltip: context.l10n.algoCommentWeightDesc,
                        width: sizer.wp(0.9),
                        content: Row(
                          children: <Widget>[
                            Text(
                              (algoCommentWeight.value ??
                                      auth.user.settings.algoCommentWeight)
                                  .toStringAsFixed(2),
                            ),
                            sizer.box(
                              w: 100,
                              h: 10,
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
                      const SizedBox(height: 5),
                      Tile(
                        title: Text(context.l10n.algoTimeDecay).title(context),
                        tooltip: context.l10n.algoTimeDecayDesc,
                        width: sizer.wp(0.9),
                        content: Row(
                          children: <Widget>[
                            Text(
                              (algoTimeDecay.value ??
                                      auth.user.settings.algoTimeDecay)
                                  .toStringAsFixed(2),
                            ),
                            sizer.box(
                              w: 100,
                              h: 10,
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
                      const SizedBox(height: 5),
                      FilledButton.icon(
                        onPressed: () async {
                          await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: sizer.box(
                                w: 125,
                                h: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      context.l10n.tagsDesc,
                                    ).titleLarge(context),
                                    const SizedBox(height: 15),
                                    TagList(
                                      onChanged: (Set<String> tags) {
                                        resetAlgoTags.value = tags;
                                      },
                                    ),
                                    const SizedBox(height: 7.5),
                                    if (resetAlgoTags.value.isEmpty)
                                      Text(
                                        context.l10n.noTagsSpecified,
                                        textAlign: TextAlign.center,
                                      ).title(context).error(context),
                                    const SizedBox(height: 25),
                                    FilledButton(
                                      onPressed: () async {
                                        if (resetAlgoTags.value.isNotEmpty) {
                                          await showDialog<void>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text(
                                                    context
                                                        .l10n
                                                        .resetAlgoConfirm,
                                                  ).titleLarge(context),
                                                  content: Text(
                                                    context
                                                        .l10n
                                                        .resetAlgoConfirmBody,
                                                  ).title(context),
                                                  actions: <Widget>[
                                                    FilledButton.icon(
                                                      onPressed: () async {
                                                        if (context.mounted) {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        }

                                                        final AuraClient
                                                        client = await ref.read(
                                                          auraClientProvider
                                                              .future,
                                                        );

                                                        final UpdateResponse
                                                        resp = await client
                                                            .userService
                                                            .update(
                                                              UpdateRequest(
                                                                settings: UserSettings(
                                                                  resetAlgoTags:
                                                                      resetAlgoTags
                                                                          .value,
                                                                ),
                                                              ),
                                                            );

                                                        if (resp.hasError()) {
                                                          ErrorDialog(
                                                            ServiceException(
                                                              resp.error,
                                                            ),
                                                            Map<
                                                              ServiceErrorType,
                                                              String
                                                            >.identity(),
                                                          );
                                                        }

                                                        resetAlgoTags.value
                                                            .clear();
                                                      },
                                                      label: Text(
                                                        context.l10n.yes,
                                                      ),
                                                      icon: const Icon(
                                                        Icons.check,
                                                      ),
                                                    ),
                                                    FilledButton.icon(
                                                      onPressed: () {
                                                        resetAlgoTags.value
                                                            .clear();
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      label: Text(
                                                        context.l10n.no,
                                                      ),
                                                      icon: const Icon(
                                                        Icons.close,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        }
                                      },
                                      child: Text(context.l10n.resetAlgo),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        label: Text(context.l10n.resetAlgo),
                        icon: const Icon(Icons.restart_alt),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      }),
    );
  }
}
