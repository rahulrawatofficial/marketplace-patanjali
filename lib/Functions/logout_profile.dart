import 'package:shared_preferences/shared_preferences.dart';

Future logoutProfile() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  print("Loging out");

  await preferences.setString('userPhoneNum', null);
  await preferences.setString('userToken', null);
  await preferences.setString('userId', null);
  // await preferences.setString('userRole', null);
  await preferences.setString('userName', null);
  // await preferences.setString('userProfilePic', null);
}
