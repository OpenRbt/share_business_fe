import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_buisness_front_end/widgetStyles/buttons/button_styles.dart';
import 'package:share_buisness_front_end/widgetStyles/text/text.dart';
import 'package:share_buisness_front_end/widgets/appBars/login_app_bar.dart';

import '../main.dart';
import '../service/authProvider.dart';
import '../service/authentication.dart' as auth;
import '../utils/common.dart';
import '../utils/modal_window.dart';
import '../widgets/progressIndicators/progress_indicators.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginViewState();
}

class _LoginViewState extends State<Login> {

  late String? sessionID;
  late User? user;
  bool _isLoginButtonPressed = false;

  _LoginViewState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> performLogin() async {
    await DefaultCacheManager().emptyCache();
    await auth.Authentication.initializeFirebase(context: context);
    if ( user != null) {
      if(sessionID != null){
          try {
            await Common.sessionApi!.assignUserToSession(sessionID!);
            routemaster.push('/debit?sessionID=${sessionID!}');
            return;
          } catch (e) {
            user = null;
            showModalWindow(context, 'Ошибка', 'Сессия недоступна', 'OK');
          }
      }
      else{
        routemaster.push('/profile');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoginButtonPressed = false;
    final authProvider = Provider.of<AuthProvider>(context);
    user = authProvider.user;
    var fullUri = Uri.parse(window.location.href);
    var fragmentUri = Uri.parse(fullUri.fragment);
    sessionID = fragmentUri.queryParameters['sessionID'];
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: LoginAppBar(),
        ),
      body: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: performLogin(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (snapshot.connectionState == ConnectionState.done) {
                            return Expanded(
                              child: Center(
                                child: user != null
                                    ? Column(
                                  children: [
                                    const SizedBox(height: 500,),
                                    ProgressIndicators.black(),
                                  ],
                                ) : SizedBox(
                                    height: 150,
                                    width: 300,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 300,
                                          child: ElevatedButton(
                                            style: _isLoginButtonPressed ? ButtonStyles.inactiveRedButton() : ButtonStyles.redButton(),
                                            onPressed: _isLoginButtonPressed ? null : () async {
                                              setState(() {
                                                _isLoginButtonPressed = true;
                                              });
                                              user = await auth.Authentication.signInWithGoogle(context: context);
                                              if(user == null ){
                                                setState(() {
                                                  _isLoginButtonPressed = false;
                                                });
                                                return;
                                              }
                                              authProvider.user = user;
                                              setState(() {
                                                _isLoginButtonPressed = false;
                                              });
                                            },
                                            child: Text("Войти",
                                              style: TextStyles.enterText(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Вход с  ',
                                              style: TextStyles.additionalText(),
                                            ),
                                            Image.asset(
                                              'google_logo.png',
                                              height: 50,
                                              width: 50,
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Как пользоваться бонусной программой?',
                                                style: TextStyles.infoText(),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    showModalWindow(context, 'Информация', '1. Нажмите "Войти" и авторизируйтсь в своём гугл-аккаунте'
                                                        '\n2. Введите количество бонусов, которое хотите списать'
                                                        '\n3. Нажмите кнопку "Списать". Зачисленные бонусы отобразятся на терминале', 'OK');
                                                  },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            );
                          }
                          return ProgressIndicators.black();
                        },
                      ),
                    ],
                  ),
                )
            )
    );
  }
}