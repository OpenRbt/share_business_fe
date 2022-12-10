import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';

import '../main.dart';

class Debit extends StatefulWidget {

  @override
  State<Debit> createState() => _DebitState();
}

class _DebitState extends State<Debit> {

  late Timer _everySecond;
  User? user = FirebaseAuth.instance.currentUser;
  late var wash = "1";
  late var post = "1";
  late var balance = 100;
  late var bonus = 100;
  late var _currentSliderValue = bonus;

  @override
  void initState() {
    super.initState();

    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        user =  FirebaseAuth.instance.currentUser;
        if(user == null){
          routemaster.push('/');
        }
      });
    });
  }

  @override
  void dispose() {
    _everySecond.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user != null ? Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.black,),
        drawer: SideMenu(),
        backgroundColor: Colors.white70,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text("Мойка: " + wash, style: TextStyle(fontSize: 30)),
                SizedBox(height: 30),
                Text("Пост: " + post, style: TextStyle(fontSize: 30)),
                SizedBox(height: 30),
                Text("Баланс: " + balance.toString(), style: TextStyle(fontSize: 30)),
                SizedBox(height: 30),
                Text("Будет начислено: " + balance.toString(), style: TextStyle(fontSize: 30)),
                SizedBox(height: 30),
                Text("Списать бонусы: " +  _currentSliderValue.toInt().toString(), style: TextStyle(fontSize: 30)),
                SizedBox(height: 30),
                SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 20,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        valueIndicatorTextStyle: TextStyle(
                          fontSize: 0,
                          color: Colors.white,
                        )
                    ),
                    child: Slider(
                      value: _currentSliderValue.toDouble(),
                      max: bonus.toDouble(),
                      divisions: bonus.toInt(),
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value.toInt();
                        });
                      },
                    )
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Align(
                      alignment: FractionalOffset.centerLeft,
                      child: SizedBox(
                          height: 100,
                          width: 150,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                              ),
                              onPressed: () => {},
                              child: Text("Отмена", style: TextStyle(fontSize: 30),),
                            ),
                          )
                      )
                    ),
                    SizedBox(width: 60),
                    Align(
                      alignment: FractionalOffset.centerRight,
                      child: SizedBox(
                          height: 100,
                          width: 150,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                              ),
                              onPressed: () => {},
                              child: Text("ОК", style: TextStyle(fontSize: 30),),
                            ),
                          )
                      ),
                    )
                  ],
                )
              ],
            )
    )
        )
    ) :
        Container();
  }
}
