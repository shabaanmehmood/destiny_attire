
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';
import '../../utils/colors.dart';
import '../../utils/global_widgets.dart';
import '../../utils/size_config.dart';

class RegisterNow extends StatefulWidget {
  RegisterNow({Key? key}) : super(key: key);

  @override
  RegisterNowState createState() => RegisterNowState();
}

class RegisterNowState extends State<RegisterNow> {

  TextEditingController fullNameCtl = new TextEditingController();
  TextEditingController cityCtl = new TextEditingController();
  TextEditingController addressCtl = new TextEditingController();
  TextEditingController mobileCtl = new TextEditingController();
  TextEditingController emailCtl = new TextEditingController();
  TextEditingController passwordCtl = new TextEditingController();
  successDialog(String signUpResponse, BuildContext context) {
    // String id = '';
    // if(signUpResponse.toString().contains('Data Submitted')){
    //   id = signUpResponse.toString().split(".")[1];
    //   // saveIdInLocal(id);
    // }
    // else{
    //   print('no id found');
    // }
    return AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        closeIcon: Container(),
        // closeIcon: IconButton(icon : Icon(Icons.close, color: ColorsX.light_orange,),onPressed: () {
        //   Get.back();
        //   // Get.toNamed(Routes.LOGIN_SCREEN);
        // },),
        showCloseIcon: true,
        title: '${signUpResponse} \n Product ID',
        desc:
        'Account Created successfully',// \n Save or remember ID to Log In' ,
        btnOkOnPress: () {
          debugPrint('OnClcik');
          Get.back();
          // Get.toNamed(Routes.ALL_CASTES_MAIN_PAGE);
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  errorDialog(BuildContext context, String title, String msg) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        title: title,
        desc: msg,
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        color:  const Color(0xffEEEEEE).withOpacity(0.8),
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight * .10),
                  child: Image.asset('assets/images/logo.png', height: 80, width: 80,)),
            ),
            myText(context, 'Full Name', ColorsX.black, 20, 10, 0, 0, FontWeight.w700, 20),
            myTextField(TextInputType.text, fullNameCtl, false, "Full Name" ),
            myText(context, 'City', ColorsX.black, 20, 10, 0, 0, FontWeight.w700, 20),
            myTextField(TextInputType.text, cityCtl, false, "Your City" ),
            myText(context, 'Address', ColorsX.black, 20, 10, 0, 0, FontWeight.w700, 20),
            myTextField(TextInputType.text, addressCtl, false, "Your Address" ),
            myText(context, 'Mobile Number', ColorsX.black, 20, 10, 0, 0, FontWeight.w700, 20),
            myTextField(TextInputType.number, mobileCtl, false, "Your Mobile Number" ),
            myText(context, 'Email', ColorsX.black, 20, 10, 0, 0, FontWeight.w700, 20),
            myTextField(TextInputType.emailAddress, emailCtl, false, "Your Email" ),
            myText(context, 'Password', ColorsX.black, 20, 10, 0, 0, FontWeight.w700, 20),
            myTextField(TextInputType.text, passwordCtl, true, "Your Password" ),
            SizedBox(height: 40,),
            addUserButton(context),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }


  addUserButton(BuildContext context,){
    return GestureDetector(
      onTap: () async {
        if(mobileCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Mobile Number required", 'Please provide mobile number');
        }
        else if(mobileCtl.text.length<11){
          GlobalWidgets.showErrorToast(
              context, "Mobile Number Not valid", 'Please provide valid mobile number');
        }
        else if(emailCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Email required", 'Please provide your email address');
        }
        else if(cityCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "City required", 'Please provide your city');
        }
        else if(addressCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Address required", 'Please provide address');
        }
        else if(fullNameCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Full name required", 'Please provide full name');
        }
        else if(passwordCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Password required", 'Please provide password');
        }
        else{
          GlobalWidgets.hideKeyboard(context);
          SharedPreferences prefs = await SharedPreferences.getInstance();

          Map<String, dynamic> userInfo = Map();
          userInfo['token'] = prefs.getString('token');
          userInfo['address'] = addressCtl.text.trim().toString();
          userInfo['city'] = cityCtl.text.trim().toString();
          userInfo['email'] = emailCtl.text.trim().toString();
          userInfo['password'] = passwordCtl.text.trim().toString();
          userInfo['full_name'] = fullNameCtl.text.trim().toString();
          userInfo['mobile'] = mobileCtl.text.trim().toString();
          print(userInfo);
          checkIfEmailExists(emailCtl.text.trim().toString(), userInfo, context);
        }
      },
      child: Container(
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: ColorsX.black,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: myText(context, "Register Now", ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 17),
          ),
        ),
      ),
    );
  }

  Future<String> checkIfEmailExists(String email, Map<String, dynamic> userInfo, BuildContext context) async {
    // Get docs from collection reference
    String response = '';
    GlobalWidgets.showProgressLoader("Validating Data");

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
    // .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if(documents.isEmpty) {
      response = 'ok';

      // final res = await _apiService.userSignUp(apiParams: userInfo);
      var collection = FirebaseFirestore.instance.collection('users');
      var docRef = await collection.add(userInfo);
      var documentId = docRef.id;
      GlobalWidgets.hideProgressLoader();
      print('created');
      Get.toNamed(Routes.MAIN_SCREEN);
    }
    else {
      print(documents.first);
      response = 'no';
      GlobalWidgets.hideProgressLoader();
      errorDialog(context, 'Failed', 'Something went wrong please try again.');
    }
    return response;
  }
  myText(BuildContext context, String text, Color colorsX, double top, double left, double right, double bottom,
      FontWeight fontWeight, double fontSize){
    return Container(
      margin: EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(text, style: GoogleFonts.mukta(textStyle: TextStyle( color: colorsX, fontWeight: fontWeight,
          fontSize: fontSize)),),
    );
  }


  myTextField(TextInputType inputType, TextEditingController ctl, bool obscureText, String hint){
    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: ColorsX.black.withOpacity(0.4), width: 1.25)
      ),
      child: TextFormField(
        keyboardType: inputType,
        controller: ctl,
        obscureText: obscureText,
        style: TextStyle(color: ColorsX.black),
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hint, hintStyle: TextStyle(color: ColorsX.black.withOpacity(0.4))
        ),
      ),
    );
  }



}