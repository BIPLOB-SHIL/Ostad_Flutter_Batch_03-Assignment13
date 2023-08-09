import 'package:flutter/material.dart';

class PrimarySwatch {
  static const MaterialColor colorSwatch = MaterialColor(
    0xff00FF88F, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which does’t require a swatch.
    <int, Color>{
      50: Colors.red,//10%
      100: Colors.red,//20%
      200: Colors.red,//30%
      300: Colors.red,//40%
      400: Colors.red,//50%
      500: Colors.greenAccent,//60%
      600: Colors.greenAccent,//70%
      700: Colors.red,//80%
      800: Colors.red,//90%
      900: Colors.red//100%
    },
  );
}