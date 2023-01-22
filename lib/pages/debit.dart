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
  late String wash;
  late String post;

  Debit({String? wash, String? post}){
    this.wash = wash!;
    this.post = post!;
  }

  @override
  State<Debit> createState() => _DebitState(wash: this.wash, post: this.post);
}

class _DebitState extends State<Debit> {

  late String wash;
  late String post;

  _DebitState({String? wash, String? post}){
    this.wash = wash!;
    this.post = post!;
  }

  var txt = TextEditingController();
  late Timer _everySecond;
  User? user = FirebaseAuth.instance.currentUser;
  late var balance = 100;
  late var bonus = balance;
  late var _currentSliderValue = bonus;

  final ValueNotifier<String> _washId = ValueNotifier("Loading...");
  final ValueNotifier<String> _postId = ValueNotifier("Loading...");
  final ValueNotifier<String> _washBalance = ValueNotifier("Loading...");
  late Timer _profileRefresh;

  @override
  void initState() {
    super.initState();
    txt.text = bonus.toString();
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

  // Future<void> _refreshSession() async {
  //   Session? prof = await Common.sessionApi!.session();
  //   _.value = prof?.id ?? "";
  //   _balance.value = prof?.balance ?? "";
  // }

  @override
  Widget build(BuildContext context) {
    return user != null ? Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
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
        ),
        drawer: SideMenu(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Text("Мойка: " + wash, style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        )),
                        SizedBox(height: 10),
                        Text("Пост: " + post, style: TextStyle(
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
                      Text("Баланс бонусов: " + balance.toString(), style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        color: Colors.black,)),
                      SizedBox(height: 10),
                      Text("Будет начислено бонусов: " + balance.toString(), style: TextStyle(
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
                      else if(int.parse(text) > 0 && int.parse(text) < balance){
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
                          max: balance.toDouble(),
                          divisions: balance.toInt(),
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
                              if(bonus < balance){
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
                            onPressed: () => {},
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

  Future<http.Response> getUser(userid, apiKey) {
    return http.post(
      Uri.parse(URL + '/user/get'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': apiKey,
      },
      body: jsonEncode(<String, String>{
        'id': userid,
      }),
    );
  }

  Future<String> fetchData() async {
    final resp = await http.get(Uri.http(URL + '/'));

    if (resp.statusCode == 200) {
      return resp.body;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

}
