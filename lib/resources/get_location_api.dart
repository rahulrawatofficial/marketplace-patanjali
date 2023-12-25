// import 'package:flutter/material.dart';
// import 'package:marketplace_patanjali/resources/http_requests.dart';
// import 'package:marketplace_patanjali/Models/LocationModel/state_model.dart';

// class GetLocation {
//   ApiBase _apiBase = ApiBase();

//   Future<List<StateModel>> getStates(BuildContext context) async {
//     List<StateModel> stateData = [];
//     _apiBase.get(context, "/api/getStates", null).then((val) {
//       stateData = stateModelFromJson(val.body);
//       return stateData;
//     });
//   }
// }
