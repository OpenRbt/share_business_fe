import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../service/authProvider.dart';
import '../service/authentication.dart' as auth;
import '../utils/common.dart';

class Login extends StatefulWidget {
  late String? sessionID;

  Login({super.key, this.sessionID} );

  @override
  State<Login> createState() => _LoginViewState(sessionID: sessionID);
}

class _LoginViewState extends State<Login> {

  late String? sessionID;
  bool _isSigningIn = false;

  _LoginViewState({this.sessionID});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            title: Image.asset(
              "assets/wash_logo.png",
              width: 200,
              height: 200,
            ),
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: false,
          ),
        ),
        backgroundColor: Colors.white,
      body: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: auth.Authentication.initializeFirebase(context: context),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (snapshot.connectionState == ConnectionState.done) {
                            return Expanded(
                              child: Center(
                                child: _isSigningIn
                                    ? Column(
                                  children: const [
                                    SizedBox(height: 300,),
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    ),
                                  ],
                                )
                                    : SizedBox(
                                    height: 150,
                                    width: 300,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 300,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor: const MaterialStatePropertyAll<Color>(Color.fromRGBO(227,1,15, 1)),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(1),
                                                    )
                                                )
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                _isSigningIn = true;
                                              });

                                              User? user =
                                              await auth.Authentication.signInWithGoogle(context: context);

                                              setState(() {
                                                _isSigningIn = false;
                                              });
                                              if(user == null ) return;
                                              authProvider.user = user;
                                              if(sessionID == null){
                                                routemaster.push('/profile');
                                                return;
                                              }

                                              int count = 0;
                                              while(count != 10){
                                                try{
                                                  await Common.sessionApi!.assignUserToSession(sessionID!);
                                                  routemaster.push('/debit?sessionID=${sessionID!}');
                                                  break;
                                                }
                                                catch (e) {
                                                  count++;
                                                }
                                              }
                                              showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  title: const Text('Ошибка'),
                                                  content: const Text('Сессия недоступна'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, 'OK'),
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: const Text("Войти", style:
                                            TextStyle(
                                              fontSize: 22,
                                              fontFamily: 'RobotoCondensed',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                                'Вход с  ',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: 'RobotoCondensed',
                                                  fontWeight: FontWeight.w400,
                                                )
                                            ),
                                            Image.asset(
                                              'google_logo.png',
                                              height: 50,
                                              width: 50,
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                ),
                              ),
                            );
                          }
                          return const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
            )
    );
  }
}