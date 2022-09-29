import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app_urls.dart';


class ApiService {
  static final ApiService _singleton = ApiService._internal();
  factory ApiService() {
    return _singleton;
  }
  ApiService._internal();

  Future<dynamic> sendNotification({required Map<dynamic, dynamic> apiParams}) async {
    var res = true;
    var id = apiParams["id"];
    var order_id = apiParams["order_id"];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http
          .post(Uri.parse('${AppUrls.SEND_NOTIFICATION}'),
        // body: jsonEncode(apiParams),
        body: {
        'id' : id,
        'order_id' : order_id,
        },
      )
          .timeout(Duration(seconds: 25));
      // print('Notification response: ${response.body}');
      print('Notification response: ${response}');
      // if (response.body.contains('Data Submitted')) {
      //   // fetchId
      //   GlobalVariables.signUpResponse = response.body;
      //   print('Notifications Response');
      //   res = true;
      // } else {
      //   res = false;
      //   // res = errorResponseFromJson(response.body);
      // }
      return res;
    } on TimeoutException catch (e) {
      return false;
    } on SocketException catch (e) {
      return false;
    } on Error catch (e) {
      print('Error : $e');
      return false;
    }
  }
  formattedDate(){
    DateTime dateTime = DateTime.now();
    return dateTime.toString();
  }
  // Future<dynamic> otpVerificationResponse(String otp, String phone) async {
  //   var res;
  //   int timeout = 40 ;
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${Constants.BASE_URL}/otpverification'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         "mobile_number": phone,
  //         "otp": otp
  //       }),
  //     ).timeout(Duration(seconds: timeout));
  //     // 1458
  //     print('OTP response: ${response.statusCode}');
  //     print('OTP response: ${response.body}');
  //     if (response.statusCode == 200) {
  //       print(response.body.toString());
  //       res = otpVerificationResponseFromJson(response.body);
  //     } else{
  //       res = errorMessageFromJson(response.body);
  //     }
  //
  //     print("this is url ${Constants.BASE_URL}/otpverification");
  //     return res;
  //   } on TimeoutException catch (e) {
  //     return ('Slow Internet try again');
  //   } on SocketException catch (e) {
  //     return ('No internet');
  //   } on Error catch (e) {
  //     return ('$e');
  //   }
  // }
  // Future<dynamic> userLogin({required Map<String, dynamic> apiParams}) async {
  //   var res;
  //   int timeout = 40;
  //   try {
  //     final response = await http
  //         .post(
  //       Uri.parse('${AppUrls.BASE_URL}/signin'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(apiParams),
  //     )
  //         .timeout(Duration(seconds: timeout));
  //     // 1458
  //     print('LOGIN response: ${response.statusCode}');
  //     print('LOGIN response: ${response.body}');
  //     if (response.statusCode == 200) {
  //       print(response.body.toString());
  //       res = loginResponseFromJson(response.body);
  //     } else{
  //       res = errorResponseFromJson(response.body);
  //     }
  //
  //     print("this is url ${AppUrls.BASE_URL}/signin");
  //     return res;
  //   } on TimeoutException catch (e) {
  //     print(e);
  //     return ('Slow Internet try again');
  //   } on SocketException catch (e) {
  //     print(e);
  //     return ('No internet');
  //   } on Error catch (e) {
  //     print(e);
  //     return ('$e');
  //   }
  // }
  // Future<dynamic> staffLogin({required Map<String, dynamic> apiParams}) async {
  //   var res;
  //   int timeout = 40;
  //   try {
  //     final response = await http
  //         .post(
  //       Uri.parse('${AppUrls.BASE_URL}/staffsignin'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(apiParams),
  //     )
  //         .timeout(Duration(seconds: timeout));
  //     // 1458
  //     print('staffsignin response: ${response.statusCode}');
  //     print('staffsignin response: ${response.body}');
  //     if (response.statusCode == 200) {
  //       print(response.body.toString());
  //       res = staffLoginResFromJson(response.body);
  //     } else{
  //       res = errorResponseFromJson(response.body);
  //     }
  //
  //     print("this is url ${AppUrls.BASE_URL}/staffsignin");
  //     return res;
  //   } on TimeoutException catch (e) {
  //     print(e);
  //     return ('Slow Internet try again');
  //   } on SocketException catch (e) {
  //     print(e);
  //     return ('No internet');
  //   } on Error catch (e) {
  //     print(e);
  //     return ('$e');
  //   }
  // }
  // Future<dynamic> otpVerifyFirstTime({required Map<String, dynamic> apiParams}) async {
  //   var res;
  //   int timeout = 40 ;
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${AppUrls.BASE_URL}/otpverification'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(apiParams),
  //     ).timeout(Duration(seconds: timeout));
  //     // 1458
  //     print('otpverification response: ${response.statusCode}');
  //     print('otpverification response: ${response.body}');
  //     if (response.statusCode == 200) {
  //       print(response.body.toString());
  //       res = otpVerificationResponseFromJson(response.body);
  //     } else{
  //       res = errorResponseFromJson(response.body);
  //     }
  //
  //     print("this is url ${AppUrls.BASE_URL}/otpverification");
  //     return res;
  //   } on TimeoutException catch (e) {
  //     print(e);
  //     return ('Slow Internet try again');
  //   } on SocketException catch (e) {
  //     print(e);
  //     return ('No internet');
  //   } on Error catch (e) {
  //     print(e);
  //     return ('$e');
  //   }
  // }
  // Future<dynamic> resendOtp({required Map<String, dynamic> apiParams}) async {
  //   var res;
  //   int timeout = 40 ;
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${AppUrls.BASE_URL}/resendotpmobile'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(apiParams),
  //     ).timeout(Duration(seconds: timeout));
  //     // 1458
  //     print('RESEND OTP response: ${response.statusCode}');
  //     print('RESEND OTP response: ${response.body}');
  //     if (response.statusCode == 200) {
  //       print(response.body.toString());
  //       res = errorResponseFromJson(response.body);
  //     } else{
  //       res = errorResponseFromJson(response.body);
  //     }
  //
  //     print("this is url ${AppUrls.BASE_URL}/resendotpmobile");
  //     return res;
  //   } on TimeoutException catch (e) {
  //     print(e);
  //     return ('Slow Internet try again');
  //   } on SocketException catch (e) {
  //     print(e);
  //     return ('No internet');
  //   } on Error catch (e) {
  //     print(e);
  //     return ('$e');
  //   }
  // }
// Future<dynamic> forgotPassword(String phone) async {
//   var res;
//   int timeout = 40 ;
//   try {
//     final response = await http.post(
//       Uri.parse('${Constants.BASE_URL}/forgotpassword'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         "mobile_number": phone,
//       }),
//     ).timeout(Duration(seconds: timeout));
//     // 1458
//     print('FORGOT PASSWORD response: ${response.statusCode}');
//     print('FORGOT PASSWORD response: ${response.body}');
//     if (response.statusCode == 200) {
//       print(response.body.toString());
//       res = errorMessageFromJson(response.body);
//     } else{
//       print(response.body.toString());
//       res = errorMessageFromJson(response.body);
//     }
//
//     print("this is url ${Constants.BASE_URL}/forgotpassword");
//     return res;
//   } on TimeoutException catch (e) {
//     return ('Slow Internet try again');
//   } on SocketException catch (e) {
//     return ('No internet');
//   } on Error catch (e) {
//     return ('$e');
//   }
// }
}