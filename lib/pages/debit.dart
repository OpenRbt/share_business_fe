import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Debit extends StatefulWidget {
  const Debit({Key? key}) : super(key: key);

  @override
  State<Debit> createState() => _DebitState();
}

class _DebitState extends State<Debit> {

  late var wash = "1";
  late var post = "1";
  late var balance = 100;
  late var bonus = 100.0;
  late var _currentSliderValue = bonus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text("Мойка: " + wash, style: TextStyle(fontSize: 60)),
                SizedBox(height: 50),
                Text("Пост: " + post, style: TextStyle(fontSize: 60)),
                SizedBox(height: 50),
                Text("Баланс: " + balance.toString(), style: TextStyle(fontSize: 60)),
                SizedBox(height: 50),
                Text("Будет начислено: " + balance.toString(), style: TextStyle(fontSize: 60)),
                SizedBox(height: 50),
                Text("Списать бонусы: " +  _currentSliderValue.toInt().toString(), style: TextStyle(fontSize: 60)),
                SizedBox(height: 30),
                SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 50,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 30),
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        valueIndicatorTextStyle: TextStyle(
                          fontSize: 1,
                          color: Colors.white,
                        )
                    ),
                    child: Slider(
                      value: _currentSliderValue,
                      max: bonus,
                      divisions: bonus.toInt(),
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    )
                ),
                SizedBox(height: 600),
                Row(
                  children: [
                    SizedBox(
                        height: 200,
                        width: 350,
                        child: Container(
                          margin: const EdgeInsets.only(left: 50.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                            ),
                            onPressed: () => {},
                            child: Text("Отмена", style: TextStyle(fontSize: 60),),
                          ),
                        )
                    ),
                    SizedBox(width: 200),
                    SizedBox(
                        height: 200,
                        width: 350,
                        child: Container(
                            margin: const EdgeInsets.only(right: 50.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                            ),
                            onPressed: () => {},
                            child: Text("ОК", style: TextStyle(fontSize: 60),),
                          ),
                        )
                    ),
                  ],
                )
              ],
            )
    )
        )
    );
  }
}
