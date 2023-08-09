class Urls{
  Urls._();
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static  String registrationUrl= '$_baseUrl/registration';
  static String loginUrl = '$_baseUrl/login';
  static String createTaskUrl = '$_baseUrl/createTask';
  static String summaryCount = '$_baseUrl/taskStatusCount';
  static String newTask = '$_baseUrl/listTaskByStatus/New';
  static String inProgressTask = '$_baseUrl/listTaskByStatus/Progress';
  static String cancelledTask = '$_baseUrl/listTaskByStatus/Cancelled';
  static String completeTask = '$_baseUrl/listTaskByStatus/Completed';


}