import 'package:shared_preferences/shared_preferences.dart';

Future<Map> getUserSavedInfo() async {
  String userToken;
  String userId;
  String userPhoneNum;
  // String userRole;
  String userName;
  // String userProfilePic;
  // bool newApp;

  SharedPreferences preferences = await SharedPreferences.getInstance();
  userToken = preferences.getString('userToken');
  userId = preferences.getString('userId');
  userPhoneNum = preferences.getString('userPhoneNum');
  userName = preferences.getString('userName');
  // userProfilePic = preferences.getString('userProfilePic');
  // userToken = preferences.getString('userToken');

  Map data = {
    "userToken": userToken,
    "userId": userId,
    "userPhoneNum": userPhoneNum,
    "userName": userName,
    // "userProfilePic": userProfilePic,
  };

  return data;
}
