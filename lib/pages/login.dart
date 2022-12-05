import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginViewState();
}

class _LoginViewState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SizedBox(
                    height: 300,
                    width: 375,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 100.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                        ),
                        onPressed: () => {},
                        child: Text("Войти", style: TextStyle(fontSize: 60),),
                      ),
                    )
                  )
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
