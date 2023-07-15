import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/modal_window.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            showModalWindow(context, 'О бонусной программе', 'Оставшиеся деньги зачисляются в виде сдачи на бонусный счёт.'
                '\nТакже с каждой мойки в течение 10 дней начисляется 5% при оплате наличными или по карте.'
                '\nМожно оплачивать мойку полностью за счёт бонусов.'
                '\nДля того чтобы сдача вернулась на бонусный счёт, нажмите на кнопку паузы, а затем на кнопку "стоп". После этого подтвердите завершение мойки.',
                'OK')
          },
        }),
      ),
      elevation: 0,
      centerTitle: false,
      shadowColor: Colors.white,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }
}
