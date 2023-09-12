import 'dart:async';
import 'dart:html';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';
import 'package:share_buisness_front_end/utils/common.dart';
import 'package:share_buisness_front_end/widgetStyles/text/text.dart';

import '../service/authProvider.dart';
import '../service/authentication.dart' as auth;
import '../utils/modal_window.dart';
import '../widgetStyles/buttons/button_styles.dart';
import '../widgetStyles/sliders/slider_styles.dart';
import '../widgets/appBars/main_app_bar.dart';
import '../widgets/progressIndicators/progress_indicators.dart';

class Debit extends StatefulWidget {

  const Debit({super.key});

  @override
  State<Debit> createState() => _DebitState();
}

class _DebitState extends State<Debit> {
  late String? sessionID;

  bool _isAcceptButtonPressed = false;

  var txt = TextEditingController();
  late auth.User? user;

  @override
  void dispose() {
    super.dispose();
  }

  Future<Session?> _refreshSession() async {
    if (sessionID != null) {
        int count = 0;
        while (count != 10){
          try {
            Future<Session?> session = Common.sessionApi!.getSessionById(sessionID!);
            Session? sessionInfo = await Common.sessionApi!.getSessionById(sessionID!);
            Wallet? wallet = await Common.walletApi!.getWalletByOrganizationId((sessionInfo?.washServer?.organizationId) ?? "");
            print(wallet?.balance.toString());
            bonusBalance = wallet?.balance ?? 0;
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
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: MainAppBar(),
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
                                    style: TextStyles.postText(),
                                ),
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
                                      style: TextStyles.balanceText()
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            Text("Списать бонусы",
                                style: TextStyles.postText(),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 100,
                              height: 45,
                              child: TextField(
                                style: TextStyles.balanceText(),
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
                                      RegExp(r"[0-9]")),
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
                                      style: ButtonStyles.redButton(),
                                      onPressed: () {
                                        if (bonus > 0) {
                                          setState(() {
                                            bonus--;
                                            _currentSliderValue = bonus;
                                            txt.text = bonus.toString();
                                          });
                                        }
                                      },
                                      child: const Icon(
                                      Icons.remove
                                  )
                                  ),
                                ),
                                SliderTheme(
                                    data: SliderStyles.moneyAmountSlider(),
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
                                    )
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: ElevatedButton(
                                    style: ButtonStyles.redButton(),
                                    onPressed: () {
                                      if (bonus < bonusBalance) {
                                        setState(() {
                                          bonus++;
                                          _currentSliderValue = bonus;
                                          txt.text = bonus.toString();
                                        });
                                      }
                                    },
                                    child: const Icon(Icons.add),
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
                                        style: ButtonStyles.whiteButtonWithRedBorder(),
                                        onPressed: () async {
                                          await auth.Authentication.signOut(
                                              context: context);
                                        },
                                        child: Text(
                                          "Выход",
                                          style: TextStyles.cancelText(),
                                        ),
                                      ),
                                    )
                                ),
                                SizedBox(
                                    height: 40,
                                    width: 150,
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      child: ElevatedButton(
                                        style: _isAcceptButtonPressed ? ButtonStyles.inactiveRedButton() : ButtonStyles.redButton(),
                                        onPressed: _isAcceptButtonPressed ? null : () async {
                                          setState(() {
                                            _isAcceptButtonPressed = true;
                                          });
                                          try {
                                            print("bonus: " + bonus.toString());
                                            await Common.sessionApi!
                                                .chargeBonusesOnSession(sessionID!,
                                                body: BonusCharge(
                                                    amount: bonus)
                                            );

                                            Wallet? walletResponse = await Common.walletApi!.getWalletByOrganizationId((snapshot.data?.washServer?.organizationId) ?? "");
                                            setState(() {
                                              bonusBalance =
                                                  walletResponse?.balance ?? 0;
                                              bonus = 0;
                                              _currentSliderValue = 0;
                                              txt.text = 0.toString();
                                            });
                                          } catch (e) {
                                            showModalWindow(context, 'Ошибка', 'Сессия недоступна', 'OK');
                                          }
                                          setState(() {
                                            _isAcceptButtonPressed = false;
                                          });
                                        },
                                        child: Text(
                                          "Списать",
                                          style: TextStyles.withdrawText(),
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            )
                          ],
                        ));
                      } else if (snapshot.hasError) {
                        return Container();
                      } else {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 300.0,
                            ),
                            Center(
                              child: ProgressIndicators.black(),
                            )
                          ],
                        );
                      }
                    },
                  )
                : Container()
    )
        : Container();
  }
}
