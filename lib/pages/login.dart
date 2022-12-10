import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../service/authentication.dart';

class Login extends StatefulWidget {
  final bool signedIn = false;

  @override
  State<Login> createState() => _LoginViewState(this.signedIn);
}

class _LoginViewState extends State<Login> {

  late bool _isSigningIn;

  _LoginViewState(bool _isSigningIn){
    this._isSigningIn = _isSigningIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Expanded(
                      child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: _isSigningIn
                              ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          )
                              :SizedBox(
                              height: 150,
                              width: 300,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 100.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _isSigningIn = true;
                                    });

                                    User? user =
                                    await Authentication.signInWithGoogle(context: context);

                                    setState(() {
                                      _isSigningIn = false;
                                    });

                                    if (user != null) {
                                      routemaster.push('/profile');
                                    }
                                  },
                                  child: Text("Войти", style: TextStyle(fontSize: 25),),
                                ),
                              )
                          )
                      ),
                    );
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange,
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