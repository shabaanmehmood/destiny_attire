
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
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
 addUser(BuildContext context) async{
    Map<String, dynamic> productInfo = Map();

    productInfo['cut_price'] = mobileCtl.text.trim().toString();
    productInfo['discount'] = '0';
    productInfo['is_available'] = '1';
    productInfo['is_featured'] = '0';
    productInfo['long_description'] = addressCtl.text.trim().toString();
    productInfo['product_name'] = fullNameCtl.text.trim().toString();
    productInfo['sale_price'] = emailCtl.text.trim().toString();
    productInfo['short_description'] = cityCtl.text.trim().toString();
    var collection = FirebaseFirestore.instance.collection('products');
    var docRef = await collection.add(productInfo);
    var documentId = docRef.id;
    GlobalWidgets.hideProgressLoader();
    successDialog(documentId,context);

  }
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
        'Product Added successfully',// \n Save or remember ID to Log In' ,
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
            SizedBox(
              height: 40,
            ),
            addProductButton(context),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }


  addProductButton(BuildContext context,){
    return GestureDetector(
      onTap: (){
        if(mobileCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Cut Price required", 'Please provide price before discount to show as cut prive');
        }
        else if(emailCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Sale price required", 'Please provide price to sale after discount');
        }
        else if(cityCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Short Description required", 'Please provide short description');
        }
        else if(addressCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Long Description required", 'Please provide long description');
        }
        else if(fullNameCtl.text.trim().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Product name required", 'Please provide product name');
        }
        else{
          GlobalWidgets.hideKeyboard(context);
          addUser(context);
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
        style: TextStyle(color: ColorsX.black.withOpacity(0.4)),
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