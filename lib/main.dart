import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

void main() async{
  await GetStorage.init();
  runApp(const TaskManagerApp());
}