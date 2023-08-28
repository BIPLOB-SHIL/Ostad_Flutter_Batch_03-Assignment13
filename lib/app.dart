import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:task_manager_getx/ui/screens/auth/splash_screen.dart';
import 'package:task_manager_getx/ui/screens/state_manager/all_task_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/email_verification_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/login_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/new_task_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/summary_count_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/otp_verification_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/reset_password_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/signup_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/update_profile_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/update_task_bottom_sheet_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/update_task_status_bottom_sheet_controller.dart';

class TaskManagerApp extends StatefulWidget {
  static GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      key: TaskManagerApp.globalKey,
      title: "Task Manager",
      theme: ThemeData(
        brightness: Brightness.light,
        inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            border: OutlineInputBorder(borderSide: BorderSide.none)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)))),
        textTheme: const TextTheme(
            titleLarge: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 0.6)),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(error: Colors.indigo),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      initialBinding: ControllerBinding(),
      home: const SplashScreen(),
    );
  }
}

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SignUpController>(SignUpController());
    Get.put<ResetPasswordController>(ResetPasswordController());
    Get.put<OtpVerificationController>(OtpVerificationController());
    Get.put<LoginController>(LoginController());
    Get.put<EmailVerificationController>(EmailVerificationController());
    Get.put<SummaryCountController>(SummaryCountController());
    Get.put<AllTaskController>(AllTaskController());
    Get.put<UpdateTaskStatusBottomSheetController>(UpdateTaskStatusBottomSheetController());
    Get.put<UpdateTaskBottomSheetController>(UpdateTaskBottomSheetController());
    Get.put<NewTaskController>(NewTaskController());
    Get.put<UpdateProfileController>(UpdateProfileController());

    //Get.lazyPut(() => ResetPasswordController());

  }
}
