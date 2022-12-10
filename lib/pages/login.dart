import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:float_column/float_column.dart';

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

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            surfaceTintColor: Colors.white,
            leadingWidth: 30,
            leading: Builder(
              builder: (BuildContext context) {
                return
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(0, 18, 60, 0),
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    color: Color.fromRGBO(68,68,68, 1),

                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios_sharp,
                      ),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      color: Colors.white,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    ),
                  );
              },
            ),
            title: Container(
                height: 32,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(0, 18, 190, 0),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                color: Color.fromRGBO(227,1,15, 1),
                child: Center(
                  child: Text('DIA Electronics',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Teko',
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 30
                    ),
                  ),
                )
            ),
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            iconTheme: IconThemeData(),
          ),
        ),

        backgroundColor: Colors.white,
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
                              ? Column(
                            children: [
                              SizedBox(height: 300,),
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            ],
                          )
                              : SizedBox(
                              height: 150,
                              width: 300,
                              child: Container(
                                //margin: const EdgeInsets.only(bottom: 100.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 300,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(227,1,15, 1)),
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
                                          await Authentication.signInWithGoogle(context: context);

                                          setState(() {
                                            _isSigningIn = false;
                                          });

                                          if (user != null) {
                                            routemaster.push('/debit');
                                          }
                                        },
                                        child: Text("Войти", style:
                                        TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'RobotoCondensed',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                        ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
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