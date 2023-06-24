import 'dart:async';
import 'dart:html';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';
import 'package:share_buisness_front_end/utils/common.dart';

import '../service/authProvider.dart';
import '../service/authentication.dart' as auth;

class Debit extends StatefulWidget {
  late String? sessionID;

  Debit({super.key, this.sessionID});

  @override
  State<Debit> createState() => _DebitState(sessionID: sessionID);
}

class _DebitState extends State<Debit> {
  late String? sessionID;

  bool _isAcceptButtonPressed = false;

  _DebitState({this.sessionID});

  var txt = TextEditingController();
  late User? user;

  @override
  void dispose() {
    super.dispose();
  }

  Future<Session?> _refreshSession() async {
    if (sessionID != null) {
        int count = 0;
        while (count != 10){
          try {
            Future<Session?> session = Common.sessionApi!.getSession(sessionID!);
            GetBalance200Response? balanceResponse = await Common.userApi!.getBalance();
            bonusBalance = balanceResponse?.balance ?? 0;
            return session;
          } on TimeoutException catch (e) {
            count++;
            if (kDebugMode) {
              print('Request timed out');
            }
          } on HttpException catch (_) {
            count++;
            if (kDebugMode) {
              print("HttpException");
            }
          } catch (_) {
            count++;
            if (kDebugMode) {
              print("OtherException");
            }
          }
        }

    }
    return null;
  }

  late int bonusBalance;
  int bonus = 0;
  int _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    txt.text = bonus.toString();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    user = authProvider.user;
    var fullUri = Uri.parse(window.location.href);
    var fragmentUri = Uri.parse(fullUri.fragment);
    sessionID = fragmentUri.queryParameters['sessionID'];
    return user != null
        ? Scaffold(
            drawer: SideMenu(sessionID: sessionID),
            appBar: AppBar(
              title: Image.asset(
                "assets/wash_logo.png",
                width: 200,
                height: 200,
              ),
              flexibleSpace: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  iconSize: 45,
                    icon: const Icon(Icons.info_outline), onPressed: () => {
                {
                  showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('О бонусной программе'),
                    content: const Text('Оставшиеся деньги зачисляются в виде сдачи на бонусный счёт.\nТакже с каждой мойки в течении 10 дней начисляется 5% при оплате наличными или по карте.'
                        '\nМожно оплачивать мойку полностью за счёт бонусов.'
                        '\nДля того, чтобы сдача вернулась на бонусный счёт нажмите на кнопку паузы, а затем на кнопку "стоп", после этого подвердите завершение мойки.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                )
              },
                }),
              ),
              elevation: 0,
              centerTitle: false,
              shadowColor: Colors.white,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: sessionID != null
                ? FutureBuilder<Session?>(
                    future: _refreshSession(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Session?> snapshot) {
                      if (snapshot.hasData) {
                        return SafeArea(
                            bottom: true,
                            child: Column(
                          children: [
                            const SizedBox(height: 50,),
                            Center(
                                child: Column(
                              children: [
                                Text(
                                    "Пост: ${snapshot.data?.postID.toString() ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    )),
                              ],
                            )),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                              child: Column(
                                textDirection: TextDirection.ltr,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 30),
                                  Text("Баланс бонусов: $bonusBalance",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                        color: Colors.black,
                                      )),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            const Text("Списать бонусы",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                )),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 100,
                              height: 45,
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
                                controller: txt,
                                keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  if (text.isEmpty) {
                                    setState(() {
                                      _currentSliderValue = 0;
                                      bonus = 0;
                                    });
                                  } else if (int.parse(text) > 0 &&
                                      int.parse(text) <= bonusBalance) {
                                    setState(() {
                                      _currentSliderValue = int.parse(txt.text);
                                      bonus = _currentSliderValue;
                                    });
                                  } else if (int.parse(text) > bonusBalance){
                                    _currentSliderValue = bonusBalance;
                                    bonus = _currentSliderValue;
                                  }
                                },
                                decoration: const InputDecoration(
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
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    try {
                                      final text = newValue.text;
                                      if (text.isNotEmpty) double.parse(text);
                                      return newValue;
                                    } catch (e) {
                                      if (kDebugMode) {
                                        print(e);
                                      }
                                    }
                                    return oldValue;
                                  }),
                                ],
                                //
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              textDirection: TextDirection.ltr,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              const MaterialStatePropertyAll<
                                                      Color>(
                                                  Color.fromRGBO(
                                                      227, 1, 15, 1)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(1),
                                          ))),
                                      onPressed: () {
                                        if (bonus > 0) {
                                          setState(() {
                                            bonus--;
                                            _currentSliderValue = bonus;
                                            txt.text = bonus.toString();
                                          });
                                        }
                                      },
                                      child: const Text(
                                        '-',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                SliderTheme(
                                    data: const SliderThemeData(
                                      activeTrackColor: Colors.black,
                                      inactiveTrackColor: Colors.black,
                                      thumbColor: Color.fromRGBO(227, 1, 15, 1),
                                      trackHeight: 3,
                                      trackShape: RectangularSliderTrackShape(),
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 10),
                                      valueIndicatorShape:
                                          RectangularSliderValueIndicatorShape(),
                                      valueIndicatorColor: Colors.black,
                                    ),
                                    child: Slider(
                                      value: _currentSliderValue.toDouble(),
                                      max: bonusBalance.toDouble(),
                                      divisions:
                                          bonusBalance == 0 ? 1 : bonusBalance,
                                      label: _currentSliderValue
                                          .round()
                                          .toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _currentSliderValue = value.toInt();
                                          txt.text = value.toInt().toString();
                                          bonus = _currentSliderValue;
                                        });
                                      },
                                    )),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            const MaterialStatePropertyAll<
                                                    Color>(
                                                Color.fromRGBO(227, 1, 15, 1)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                        ))),
                                    onPressed: () {
                                      if (bonus < bonusBalance) {
                                        setState(() {
                                          bonus++;
                                          _currentSliderValue = bonus;
                                          txt.text = bonus.toString();
                                        });
                                      }
                                    },
                                    child: const Text(
                                      '+',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'Roboto',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 70),
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
                                            side: MaterialStateBorderSide
                                                .resolveWith((states) =>
                                                    const BorderSide(
                                                        width: 3,
                                                        color: Color.fromRGBO(
                                                            227, 1, 15, 1))),
                                            backgroundColor:
                                                const MaterialStatePropertyAll<Color>(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ))),
                                        onPressed: () async {
                                          await auth.Authentication.signOut(
                                              context: context);
                                          //routemaster.push('/');
                                        },
                                        child: const Text(
                                          "Выход",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'RobotoCondensed',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                    height: 40,
                                    width: 150,
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                const MaterialStatePropertyAll<Color>(
                                                    Color.fromRGBO(
                                                        227, 1, 15, 1)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ))),
                                        onPressed: () async {
                                          setState(() {
                                            _isAcceptButtonPressed = false;
                                          });
                                          try {
                                            await Common.sessionApi!
                                                .postSession(sessionID!,
                                                    body: BonusCharge(
                                                        amount: bonus));
                                            GetBalance200Response?
                                                balanceResponse = await Common
                                                    .userApi!
                                                    .getBalance();
                                            setState(() {
                                              bonusBalance =
                                                  balanceResponse?.balance ?? 0;
                                              bonus = 0;
                                              _currentSliderValue = 0;
                                              txt.text = 0.toString();
                                            });
                                          } catch (e) {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text('Ошибка'),
                                                content: const Text(
                                                    'Сессия недоступна'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          setState(() {
                                            _isAcceptButtonPressed = false;
                                          });
                                        },
                                        child: const Text(
                                          "Списать",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'RobotoCondensed',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ));
                      } else if (snapshot.hasError) {
                        return const Text("Wrong parametrs in Future Builder",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ));
                        //} else if (snapshot.connectionState) {
                      } else {
                        return Column(
                          children: const [
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
                      }
                    },
                  )
                : const Text("Wrong parametrs in body",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    )))
        : Container();
  }
}
