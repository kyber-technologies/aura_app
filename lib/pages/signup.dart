import 'package:aura_app/ext.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/router.dart';
import 'package:aura_app/sizer.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_app/utils.dart';
import 'package:aura_app/widgets/error_dialog.dart';
import 'package:aura_app/widgets/loader.dart';
import 'package:aura_app/widgets/navbar.dart';
import 'package:aura_app/widgets/tag_list.dart';
import 'package:aura_dart/common.dart';
import 'package:aura_dart/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupPage extends HookConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Sizer sizer = useSizer(context);
    final ValueNotifier<GlobalKey<FormState>> formKey = useState(GlobalKey());
    final Future<AuthService> authFut = ref.watch(authProvider.future);
    final Future<AuraClient> clientFut = ref.watch(auraClientProvider.future);

    final TextEditingController useridController = useTextEditingController
        .fromValue(TextEditingValue.empty);
    final TextEditingController usernameController = useTextEditingController
        .fromValue(TextEditingValue.empty);
    final TextEditingController emailController = useTextEditingController
        .fromValue(TextEditingValue.empty);
    final TextEditingController passwordController = useTextEditingController
        .fromValue(TextEditingValue.empty);

    final TextEditingController emailTokenController = useTextEditingController
        .fromValue(TextEditingValue.empty);

    final ValueNotifier<Set<String>> tags = useState<Set<String>>(<String>{});

    return Scaffold(
      bottomNavigationBar: const Navbar(),
      body: Loader<(AuthService, AuraClient)>((authFut, clientFut).wait, (
        BuildContext context,
        WidgetRef ref,
        (AuthService, AuraClient) loaderResult,
      ) {
        final (AuthService auth, AuraClient client) = loaderResult;

        return Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: sizer.padding(
              horizontal: 35,
              child: Form(
                key: formKey.value,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      sizer.box(h: 20),
                      Text(context.l10n.signup).headline(context),
                      TextFormField(
                        controller: useridController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: context.l10n.userid,
                          helperText: context.l10n.useridDescription,
                        ),
                        validator: (String? input) {
                          if (input == null ||
                              input.isEmpty ||
                              input.length < 3) {
                            return context.l10n.useridInvalid;
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: context.l10n.username,
                          helperText: context.l10n.usernameDescription,
                        ),
                        validator: (String? input) {
                          if (input == null || input.isEmpty) {
                            return context.l10n.usernameInvalid;
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: context.l10n.email,
                          helperText: context.l10n.emailDescription,
                        ),
                        validator: (String? input) {
                          if (input == null ||
                              input.isEmpty ||
                              !isValidEmail(input)) {
                            return context.l10n.emailInvalid;
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.security),
                          labelText: context.l10n.password,
                          helperText: context.l10n.passwordDescription,
                        ),
                        onFieldSubmitted: (String input) async {
                          passwordController.text = input;

                          if (formKey.value.currentState!.validate()) {
                            try {
                              await auth.login(
                                userId: useridController.text,
                                password: passwordController.text,
                              );

                              if (context.mounted) {
                                context.goNamed(feedRoute.name);
                              }
                            } on Exception catch (exception) {
                              logger.e(exception);

                              if (context.mounted) {
                                await ErrorDialog(
                                  exception,
                                  <ServiceErrorType, String>{
                                    ServiceErrorType.alreadyExists:
                                        context.l10n.userNotUnique,
                                  },
                                ).show(context);
                              }
                            }
                          }
                        },
                        validator: (String? input) {
                          if (input == null ||
                              input.isEmpty ||
                              input.length < 6) {
                            return context.l10n.passwordInvalid;
                          }

                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(context.l10n.tagsDesc),
                          const SizedBox(width: 10),
                          TagList(
                            onChanged: (Set<String> newTags) {
                              tags.value = newTags;
                            },
                            initialTags: tags.value,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: () async {
                          if (formKey.value.currentState!.validate()) {
                            try {
                              if (tags.value.isEmpty) {
                                throw ServiceException(
                                  Error(
                                    invalidFormat: InvalidFormatError(),
                                    message: context.l10n.noTagsSpecified,
                                  ),
                                );
                              }

                              final ExistsResponse userExistsResponse =
                                  await client.userService.exists(
                                    ExistsRequest(
                                      userId: useridController.text,
                                    ),
                                  );

                              if (userExistsResponse.hasError()) {
                                switch (userExistsResponse.error.whichType()) {
                                  case ServiceErrorType.notFound:
                                    break;
                                  default:
                                    throw ServiceException(
                                      userExistsResponse.error,
                                    );
                                }
                              } else {
                                throw ServiceException(
                                  ServiceError(
                                    alreadyExists: AlreadyExistsError(),
                                    message: context.mounted
                                        ? context.l10n.userNotUnique
                                        : '',
                                  ),
                                );
                              }

                              final VerifyEmailResponse verifyEmailResponse =
                                  await client.userService.verifyEmail(
                                    VerifyEmailRequest(
                                      email: emailController.text,
                                    ),
                                  );

                              if (verifyEmailResponse.hasError()) {
                                throw ServiceException(
                                  verifyEmailResponse.error,
                                );
                              }

                              String? token;

                              if (context.mounted) {
                                await showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SimpleDialog(
                                        title: Text(
                                          context.l10n.verifyEmailBody(
                                            emailController.text,
                                          ),
                                        ),
                                        children: <Widget>[
                                          sizer.padding(
                                            horizontal: 10,
                                            child: TextFormField(
                                              controller: emailTokenController,
                                              decoration: InputDecoration(
                                                label: Text(
                                                  context.l10n.emailTokenLabel,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              token = emailTokenController.text;

                                              context.pop();
                                            },
                                            child: Text(context.l10n.submit),
                                          ),
                                        ],
                                      ),
                                );
                              }

                              if (token != null) {
                                final CreateResponse createUserResponse =
                                    await client.userService.create(
                                      CreateRequest(
                                        userId: useridController.text,
                                        username: useridController.text,
                                        password: passwordController.text,
                                        email: emailController.text,
                                        verificationToken: token,
                                        settings: defaultUserSettings
                                          ..resetAlgoTags.addAll(tags.value),
                                      ),
                                    );

                                if (createUserResponse.hasError()) {
                                  throw ServiceException(
                                    createUserResponse.error,
                                  );
                                }

                                await auth.login(
                                  userId: useridController.text,
                                  password: passwordController.text,
                                );

                                if (context.mounted) {
                                  context.goNamed(feedRoute.name);
                                }
                              }
                            } on Exception catch (exception) {
                              logger.e(exception);

                              if (context.mounted) {
                                await ErrorDialog(
                                  exception,
                                  <ServiceErrorType, String>{
                                    ServiceErrorType.alreadyExists:
                                        context.l10n.userNotUnique,
                                  },
                                ).show(context);
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.login),
                        label: Text(context.l10n.signup),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          context.goNamed(loginRoute.name);
                        },
                        child: Text(context.l10n.login),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
