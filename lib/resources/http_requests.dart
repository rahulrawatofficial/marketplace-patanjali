import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace_patanjali/Functions/error_handling.dart';
import 'dart:io';

import 'package:marketplace_patanjali/Functions/variables.dart';

class ApiBase {
  String scheme = "http";
  // String host = "13.232.97.197";
  String host = "13.234.192.202";
  // String host = "192.168.43.100";
  // String host = "192.168.43.33";

  int port = 8080;
  ErrorHandling _errorHandling = ErrorHandling();

  List serviceList = List();

  addServie() {
    serviceList.add("/api/getUserDetail");
    serviceList.add("/api/getRequestList");
    serviceList.add("/api/getProductCategoryMembers");
    serviceList.add("/api/addProductToSell");
    serviceList.add("/api/getRequestListByPartyId");
    serviceList.add("/api/createQuoteFromRequest");
    serviceList.add("/api/addCommentOnBid");
    serviceList.add("/api/getBidListByRequestId");
    serviceList.add("/api/acceptRejectBid");
    serviceList.add("/api/uploadProfilePicImage");
    serviceList.add("/api/addItemToWishList");
    serviceList.add("/api/deleteWishListByWishListId");
    serviceList.add("/api/getWishListByPartyId");
    serviceList.add("/api/getBidListByPartyId");
    serviceList.add("/api/createRazorPayOrder");
    serviceList.add("/api/storeRazorPayPaymentId");
    serviceList.add("/api/getUnitList");
    serviceList.add("/api/searchApi");
    serviceList.add("/api/deleteProductToSell");
    serviceList.add("/api/getPaymentListByPartyId");
    serviceList.add("/api/getHomeCategoryList");
    serviceList.add("/api/getBillingAccDetails");
    serviceList.add("/api/addBalanceByRazorPay");
    serviceList.add("/api/paymentByWallet");
    serviceList.add("/api/paymentByCash");
    serviceList.add("/api/getOrderListPartyId");
    serviceList.add("/api/getWeatherDetail");
    serviceList.add("/api/getBankAccountDetail");
    serviceList.add("/api/addAccountDetail");
    serviceList.add("/api/updateAccountDetail");
    serviceList.add("/api/getUserReportsByUserId");
    serviceList.add("/api/addItemToCart");
    serviceList.add("/api/getCartItemByPartyId");
    serviceList.add("/api/createWalletRazorPayOrder");
    serviceList.add("/api/getWalletHistoryByPartyId");
    serviceList.add("/api/dkdAdminLogin");
  }

  Map<String, String> authHeader = {
    "Content-Type": "application/json",
  };

  Future<dynamic> get(BuildContext context, String serviceName,
      Map<String, dynamic> params, String userTokenNew) async {
    addServie();
    var responseJson;
    print("$serviceName/$params");
    if (serviceList.contains(serviceName)) {
      authHeader.putIfAbsent("Authorization", () => "$userTokenNew");
      print(authHeader);
    }

    try {
      final response = await http.get(
        Uri(
          scheme: scheme,
          host: host,
          port: port,
          path: serviceName,
          queryParameters: params != null ? params : null,
        ),
        headers: authHeader,
      );
      responseJson = _returnResponse(context, response);
    } on SocketException {
      _errorHandling.showErrorDailog(
          context, "Network Error", "Check your internet connection");
    }
    return responseJson;
  }

  Future<dynamic> post(BuildContext context, String serviceName, var params,
      dynamic body, String userTokenNew) async {
    addServie();
    var responseJson;
    if (serviceList.contains(serviceName)) {
      authHeader.putIfAbsent("Authorization", () => "$userTokenNew");
      print(authHeader);
    }
    try {
      final response = await http.post(
        Uri(
          scheme: scheme,
          host: host,
          port: port,
          path: serviceName,
          // queryParameters: params != null ? params : null,
        ),
        body: json.encode(body),
        headers: authHeader,
      );
      print("###${json.encode(body)} $serviceName###");
      print(response.statusCode);
      print(response.body);
      responseJson = _returnResponse(context, response);
    } on SocketException {
      _errorHandling.showErrorDailog(
          context, "Network Error", "Check your internet connection");
      return responseJson;
    }
    return responseJson;
  }

  Future<dynamic> put(BuildContext context, String serviceName, Map params,
      dynamic body, String userTokenNew) async {
    addServie();
    print(body);
    var responseJson;
    print("###${json.encode(body)} $serviceName###");
    if (serviceList.contains(serviceName)) {
      authHeader.putIfAbsent("Authorization", () => "$userTokenNew");
    }
    try {
      final response = await http.post(
        Uri(
          scheme: scheme,
          host: host,
          port: port,
          path: serviceName,
          // queryParameters: params != null ? params : null,
        ),
        body: json.encode(body),
        headers: authHeader,
      );
      print(response.statusCode);
      print(response.body);
      responseJson = _returnResponse(context, response);
    } on SocketException {
      _errorHandling.showErrorDailog(
          context, "Network Error", "Check your internet connection");
      return responseJson;
    }
    return responseJson;
  }

  Future<dynamic> delete(
      BuildContext context, String serviceName, Map params) async {
    var responseJson;
    if (serviceList.contains(serviceName)) {
      authHeader.putIfAbsent("Authorization", () => "Bearer $userToken");
    }
    try {
      final response = await http.delete(
        Uri(
          scheme: scheme,
          host: host,
          port: port,
          path: serviceName,
          queryParameters: params != null ? params : null,
        ),
        headers: authHeader,
      );
      responseJson = _returnResponse(context, response);
    } on SocketException {
      _errorHandling.showErrorDailog(
          context, "Network Error", "Check your internet connection");
    }
    return responseJson;
  }

  http.Response _returnResponse(BuildContext context, http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        var d = json.decode(responseJson);
        if (d["responseMessage"] == "error")
          _errorHandling.showErrorDailog(context, "Error", d["errorMessage"]);
        print(responseJson);
        return response;
      case 400:
        _errorHandling.showErrorDailog(
            context, "Bad Request", "Data not found");
        return response;
      case 401:
        _errorHandling.showErrorDailog(
            context, "Unauthorized", "You are Unauthorized");
        return response;
      case 403:
        _errorHandling.showErrorDailog(
            context, "Unauthorized", "You are Unauthorized");
        return response;
      case 500:
      default:
        _errorHandling.showErrorDailog(
            context, "Connection", "No Connection found");
        return response;
    }
  }
}
