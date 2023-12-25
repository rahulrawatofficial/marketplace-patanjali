import 'package:marketplace_patanjali/Models/user_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future saveCurrentLogin(UserResponseModel userInfo, String phoneNum) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var userPhoneNum = "";
  var userToken = "";
  var userId = "";
  // var userRole = "";
  var userName = "";
  // var userProfilePic = "";

  if ((userInfo != null)) {
    print("Saving current Login");
    userPhoneNum = phoneNum;
    userToken = userInfo.basicAuth;
    userId = userInfo.partyDetail.partyId;
    // userRole = userInfo.roles[0].roleName;
    userName = userInfo.partyDetail.firstName;
    // userProfilePic = userInfo.profileImage;
  }

  await preferences.setString('userPhoneNum',
      (userPhoneNum != null && userPhoneNum.length > 0) ? userPhoneNum : "");
  await preferences.setString('userToken',
      (userToken != null && userToken.length > 0) ? userToken : "");
  await preferences.setString(
      'userId', (userId != null && userId.length > 0) ? userId : "");
  // await preferences.setString(
  //     'userRole', (userRole != null && userRole.length > 0) ? userRole : "");
  await preferences.setString(
      'userName', (userName != null && userName.length > 0) ? userName : "");
  // await preferences.setString(
  //     'userProfilePic',
  //     (userProfilePic != null && userProfilePic.length > 0)
  //         ? userProfilePic
  //         : "");
}
