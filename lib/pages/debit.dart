import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';
import 'package:share_buisness_front_end/utils/common.dart';

import '../main.dart';

final URL = "";
//user/get

class Debit extends StatefulWidget {
  late String sessionID;

  Debit({String? sessionID}){
    this.sessionID = sessionID!;
  }

  @override
  State<Debit> createState() => _DebitState(sessionID: this.sessionID);
}

class _DebitState extends State<Debit> {

  late String sessionID;

  _DebitState({String? sessionID}){
    this.sessionID = sessionID!;
  }

  var txt = TextEditingController();
  late Timer _everySecond;
  User? user = FirebaseAuth.instance.currentUser;

  final ValueNotifier<String> _washId = ValueNotifier("Loading...");
  final ValueNotifier<String> _postId = ValueNotifier("Loading...");
  final ValueNotifier<int> _washBalance = ValueNotifier(0);
  late Timer _profileRefresh;

  @override
  void dispose() {
    _profileRefresh.cancel();
    super.dispose();
  }

  Future<void> _refreshSession() async {
    Session? session = await Common.sessionApi!.getSession(sessionID);
      _washId.value = session?.postID.toString() ?? "";
      _postId.value = session?.postID.toString() ?? "";
      _washBalance.value = session?.postBalance ?? 0;
   }

  late var bonus = _washBalance.value;
  late var _currentSliderValue = bonus;

  @override
  void initState() {
    super.initState();
    txt.text = bonus.toString();
    _profileRefresh = Timer(const Duration(seconds: 1), _refreshSession);
  }

  Future sendBonuses() async {
    await Common.sessionApi!.chargeBonus(sessionID, body: BonusCharge(amount: bonus));
  }

  @override
  Widget build(BuildContext context) {
    return user != null ? Scaffold(
        drawer: SideMenu(sessionID: this.sessionID),
          appBar: AppBar(
            title: Image.asset(
              "assets/wash_logo.png",
              width: 200,
              height: 200,
            ),
            elevation: 0,
            centerTitle: false,
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Text("Мойка: " + _washId.value, style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        )),
                        SizedBox(height: 10),
                        Text("Пост: " + _postId.value, style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        )),

                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
                  child: Column(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text("Баланс бонусов: " + _washBalance.value.toString(), style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        color: Colors.black,)),
                      SizedBox(height: 10),
                      Text("Будет начислено бонусов: " + _washBalance.value.toString(), style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        color: Colors.black,)),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Text("Списать бонусы", style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                )),
                SizedBox(height: 10),
                SizedBox(
                  width: 100,
                  height: 45,
                  child: TextField(

                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      color: Colors.black,
                    ),
                    controller: txt,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      if(text.isEmpty){
                      setState(() {
                        _currentSliderValue = 0;
                        bonus = 0;
                      });
                      }
                      else if(int.parse(text) > 0 && int.parse(text) < _washBalance.value){
                        setState(() {
                          _currentSliderValue = int.parse(txt.text);
                          bonus = _currentSliderValue;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black, width: 1.0),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        try {
                          final text = newValue.text;
                          if (text.isNotEmpty) double.parse(text);
                          return newValue;
                        } catch (e) {}
                        return oldValue;
                      }),
                    ],
                    //
                  ),
                ),
                SizedBox(height: 10),
                Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(227,1,15, 1)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1),
                                  )
                              )
                          ),
                          onPressed: () {
                              if(bonus > 0){
                                setState(() {
                                  bonus--;
                                  _currentSliderValue = bonus;
                                  txt.text = bonus.toString();
                                });
                              }
                          },
                          child: Text('-',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Roboto',
                            color: Colors.white,),
                          textAlign: TextAlign.center,
                          )
                      ),
                    ),
                    SliderTheme(
                        data: SliderThemeData(
                            activeTrackColor: Colors.black,
                            inactiveTrackColor: Colors.black,
                            thumbColor: Color.fromRGBO(227,1,15, 1),
                            trackHeight: 3,
                            trackShape: RectangularSliderTrackShape(),
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                            valueIndicatorShape: RectangularSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.black,

                        ),
                        child: Slider(
                          value: _currentSliderValue.toDouble(),
                          max: _washBalance.value.toDouble(),
                          divisions: _washBalance.value == 0 ? (_washBalance.value+1).toInt(): _washBalance.value.toInt(),
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value.toInt();
                              txt.text = value.toInt().toString();
                              bonus = _currentSliderValue;
                            });
                          },
                        )
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(227,1,15, 1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1),
                                )
                            )
                        ),
                          onPressed: ()  {
                              if(bonus < _washBalance.value){
                                setState(() {
                                  bonus++;
                                  _currentSliderValue = bonus;
                                  txt.text = bonus.toString();
                                });
                              }
                          },
                          child: Text('+',
                            textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Roboto',
                                color: Colors.white,),
                          ),

                      ),
                    )
                  ],
                ),
                SizedBox(height: 70),
                Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        height: 40,
                        width: 150,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 3, color: Color.fromRGBO(227,1,15, 1))),
                                backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(

                                      borderRadius: BorderRadius.circular(1),
                                    )
                                )
                            ),
                            onPressed: () => {},
                            child: Text("Отмена", style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'RobotoCondensed',
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),),
                          ),
                        )
                    ),
                    SizedBox(
                        height: 40,
                        width: 150,
                        child: Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(227,1,15, 1)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1),
                                    )
                                )
                            ),
                            onPressed: () => {sendBonuses()},
                            child: Text("Подтвердить", style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'RobotoCondensed',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),),
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          )
        )
    ) :
        Container();
  }

}