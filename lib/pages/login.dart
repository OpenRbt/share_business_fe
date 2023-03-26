import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api_client/api.dart';
import '../main.dart';
import '../service/authentication.dart' as Auth;
import '../utils/common.dart';

class Login extends StatefulWidget {
  late String? sessionID;

  Login({String? sessionID} ){
    this.sessionID = sessionID;
  }

  @override
  State<Login> createState() => _LoginViewState(sessionID: this.sessionID);
}

class _LoginViewState extends State<Login> {

  late String? sessionID;
  bool _isSigningIn = false;

  _LoginViewState({String? sessionID} ){
    this.sessionID = sessionID;
  }

  final ValueNotifier<String> _washId = ValueNotifier("...");
  final ValueNotifier<String> _postId = ValueNotifier("...");

  Future<Session?> _refreshSession() async {
    if(sessionID != null){
      try{
        Future<Session?> session = Common.sessionApi!.getSession(sessionID!);
        return session;
      } on HttpException catch(e){
        print("HttpException");
      } catch(e){
        print("OtherException");
      }
    }
  }

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
      body: sessionID != null ?
            SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: Auth.Authentication.initializeFirebase(context: context),
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
                                              await Auth.Authentication.signInWithGoogle(context: context);

                                              final idToken = await user!.getIdToken();

                                              setState(() {
                                                _isSigningIn = false;
                                              });

                                              if (user != null) {
                                                if(sessionID != null){
                                                  Common.sessionApi!.assignUserToSession(sessionID!);
                                                  routemaster.push('/debit?sessionID='+sessionID!);
                                                }
                                                else{
                                                  routemaster.push('/profile');
                                                }
                                              }
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
                              Colors.orange,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
            ):
      SafeArea(
          child: Center(
            child: Column(
              children: [
                FutureBuilder(
                  future: Auth.Authentication.initializeFirebase(context: context),
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
                                        await Auth.Authentication.signInWithGoogle(context: context);

                                        final idToken = await user!.getIdToken();

                                        setState(() {
                                          _isSigningIn = false;
                                        });

                                        if (user != null) {
                                          routemaster.push('/profile');
                                        }
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
                    return Column(
                      children: [
                        SizedBox(
                          height: 300.0,
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        )
                      ],
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