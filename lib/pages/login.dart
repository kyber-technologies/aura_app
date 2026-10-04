import 'package:aura_app/ext.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/router.dart';
import 'package:aura_app/sizer.dart';
import 'package:aura_app/widgets/loader.dart';
import 'package:aura_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Sizer sizer = useSizer(context);
    final ValueNotifier<GlobalKey<FormState>> formKey = useState(GlobalKey());
    final Future<AuthService> authFut = ref.watch(authProvider.future);

    final TextEditingController useridController = useTextEditingController
        .fromValue(TextEditingValue.empty);
    final TextEditingController passwordController = useTextEditingController
        .fromValue(TextEditingValue.empty);

    final ValueNotifier<Exception?> result = useState(null);

    return Scaffold(
      bottomNavigationBar: const Navbar(),
      body: Loader<AuthService>(
        authFut,
        (BuildContext context, WidgetRef ref, AuthService auth) => Center(
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
                      Text(context.l10n.login).headline(context),
                      TextFormField(
                        controller: useridController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: context.l10n.userid,
                          helperText: context.l10n.useridDescription,
                        ),
                        validator: (String? input) {
                          if (input == null || input.isEmpty) {
                            return context.l10n.useridInvalid;
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
                              result.value = null;

                              await auth.login(
                                userId: useridController.text,
                                password: passwordController.text,
                              );

                              if (context.mounted) {
                                context.goNamed(feedRoute.name);
                              }
                            } on Exception catch (exception) {
                              logger.e(exception);

                              result.value = exception;
                            }
                          }
                        },
                        validator: (String? input) {
                          if (input == null || input.isEmpty) {
                            return context.l10n.passwordInvalid;
                          }

                          return null;
                        },
                      ),
                      FilledButton.icon(
                        onPressed: () async {
                          if (formKey.value.currentState!.validate()) {
                            try {
                              result.value = null;

                              await auth.login(
                                userId: useridController.text,
                                password: passwordController.text,
                              );

                              if (context.mounted) {
                                context.goNamed(feedRoute.name);
                              }
                            } on Exception catch (exception) {
                              logger.e(exception);

                              result.value = exception;
                            }
                          }
                        },
                        icon: const Icon(Icons.login),
                        label: Text(context.l10n.login),
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          if (result.value == null) {
                            return const Text('');
                          } else {
                            final Exception serviceError = result.value!;

                            if (serviceError is ServiceException) {
                              final ServiceException exception =
                                  result.value! as ServiceException;

                              if (exception.error.hasUnauthorized()) {
                                return Text(
                                  context.l10n.unauthorizedLoginError,
                                  textAlign: TextAlign.center,
                                ).bodyLarge(context).error(context);
                              } else {
                                return Text(
                                  '${context.l10n.unexpectedError} - '
                                  '${serviceError.error.message} '
                                  '(${serviceError.error.code})',
                                  textAlign: TextAlign.center,
                                ).bodyLarge(context).error(context);
                              }
                            } else {
                              return Text(
                                '${context.l10n.unexpectedError} - '
                                '$serviceError',
                                textAlign: TextAlign.center,
                              ).bodyLarge(context).error(context);
                            }
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed(signupRoute.name);
                        },
                        child: Text(context.l10n.signup),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
