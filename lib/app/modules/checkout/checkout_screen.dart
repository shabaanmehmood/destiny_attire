import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destiny_attire/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/cache_data.dart';
import '../../utils/colors.dart';
import '../../utils/global_variables.dart';
import '../../utils/global_widgets.dart';
import '../../utils/size_config.dart';
import '../../views/widget/drawer_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CacheData cacheData = CacheData();
  TextEditingController addressCtl = new TextEditingController();
  TextEditingController cityCtl = new TextEditingController();
  TextEditingController phoneCtl = new TextEditingController();
  List<dynamic> orderStringList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: body(context),
      drawer: DrawerWidget(context),
      appBar: AppBar(
        backgroundColor: const Color(0xffEEEEEE).withOpacity(0.8),
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', height: 40, width: 50,),
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: ColorsX.black,),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(), //Scaffold.of(context).openDrawer(),
        ),
      ),
      // floatingActionButton: new FloatingActionButton(
      //   backgroundColor: ColorsX.black,
      //   onPressed: () => cartOpen(context),
      //   tooltip: 'Cart',
      //   child: FaIcon(FontAwesomeIcons.shoppingCart, color: ColorsX.white,),
      // ),
    );
  }

  body(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Stack(
        children: <Widget>[
          Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              // color:  const Color(0xff70b4ff).withOpacity(0.8),
              color:  const Color(0xffEEEEEE).withOpacity(0.8),
            ),
          ),
          listViewContent(context),
        ],
      ),
    );
  }

  listViewContent(BuildContext context){
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: Image.asset('assets/images/logo.png', height: 80, width: 80,)),
              ),
              SizedBox(height: 15,),
              globalWidgets.myText(context, 'Your city where you want us to deliver your order', ColorsX.black, 20, 15, 0, 0, FontWeight.w700, 15),
              globalWidgets.myTextField(TextInputType.text, cityCtl, false, "Your City" ),
              SizedBox(height: 15,),
              globalWidgets.myText(context, 'Your address where you want us to deliver your order', ColorsX.black, 20, 15, 0, 0, FontWeight.w700, 15),
              myTextField(TextInputType.multiline, addressCtl, false, "Address For Delivery" ),
              SizedBox(height: 15,),
              globalWidgets.myText(context, 'Your mobile number where we can contact you', ColorsX.black, 20, 15, 0, 0, FontWeight.w700, 15),
              globalWidgets.myTextField(TextInputType.phone, phoneCtl, false, "Phone Number" ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 40,
                      margin: EdgeInsets.only(left: 10, top: 5),
                      child: FaIcon(FontAwesomeIcons.book, color: ColorsX.greenish,)
                  ),
                  globalWidgets.myText(context, 'Order Details', ColorsX.greenish, 0, 15, 15, 0, FontWeight.w700, 20),
                ]
              ),
                  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  itemsWithQuantity(context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 40,
                      margin: EdgeInsets.only(left: 10, top: 13),
                      child: FaIcon(FontAwesomeIcons.cashRegister, color: ColorsX.greenish,)
                  ),
                  globalWidgets.myText(context, 'Payment Method', ColorsX.greenish, 10, 15, 15, 0, FontWeight.w700, 20),
                ],
              ),
              globalWidgets.myText(context, 'Cash on Delivery', ColorsX.black.withOpacity(0.8), 0, 15, 15, 0, FontWeight.w700, 17),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 40,
                      margin: EdgeInsets.only(left: 10, top: 13),
                      child: FaIcon(FontAwesomeIcons.truck, color: ColorsX.greenish,)
                  ),
                  globalWidgets.myText(context, 'Delivery Method', ColorsX.greenish, 10, 15, 15, 0, FontWeight.w700, 20),
                ],
              ),
              globalWidgets.myText(context, 'Delivery at your doorstep', ColorsX.black.withOpacity(0.8), 0, 15, 15, 0, FontWeight.w700, 17),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                      margin: EdgeInsets.only(left: 10, top: 13),
                      child: FaIcon(FontAwesomeIcons.bagShopping, color: ColorsX.greenish,)
                  ),
                  globalWidgets.myText(context, 'Delivery Charges', ColorsX.greenish, 10, 15, 15, 0, FontWeight.w700, 20),
                ],
              ),
              globalWidgets.myText(context, 'Delivery is Free Anywhere in Lahore. Whereas PKR250 will be charged for delivery charges other than Lahore  ', ColorsX.black.withOpacity(0.5), 0, 15, 15, 0, FontWeight.w700, 17),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                      margin: EdgeInsets.only(left: 10, top: 13),
                      child: FaIcon(FontAwesomeIcons.moneyBillTrendUp, color: ColorsX.greenish,)
                  ),
                  globalWidgets.myText(context, 'Amount Payable', ColorsX.greenish, 10, 15, 15, 0, FontWeight.w700, 20),
                ],
              ),
              showTotalAmount(context),
              SizedBox(height: 30,),
              placeOrder(context),
              SizedBox(height: 30,),
            ],
          ),
        ],
      ),
    );
  }

  showTotalAmount(BuildContext context) {
    int totalAmount = 0;
    for(int index = 0; index < GlobalVariables.cartList.length; index++){
      Map <String, dynamic> myMap = GlobalVariables.cartList[index];
      int amount_payable_for_item = myMap["amount_payable"];
      totalAmount = totalAmount + amount_payable_for_item;
      debugPrint("${totalAmount}");
    }
    debugPrint(totalAmount.toString());
    GlobalVariables.amountPayable = "${totalAmount}";
    return globalWidgets.myText(context, "PKR ${totalAmount}", ColorsX.black, 0, 15, 0, 0, FontWeight.w700, 20);
  }
  placeOrder(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(cityCtl.text.toString().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "City required", 'Please provide city for delivery');
        }
        else if(addressCtl.text.toString().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Address required", 'Please provide delivery address');
        }
        else if(phoneCtl.text.toString().isEmpty){
          GlobalWidgets.showErrorToast(
              context, "Mobile Number required", 'Please provide mobile number');
        }
        else{
          placeMyOrder(context);
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
            child: globalWidgets.myText(context, "Place My Order", ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 17),
          ),
        ),
      ),
    );
  }

  ourLinks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(),
          GestureDetector(
            onTap: (){},
            child: CircleAvatar(
              child: FaIcon(FontAwesomeIcons.facebookF, color: Colors.white,), // Icon widget changed with FaIcon
              radius: 20.0,
              // backgroundColor: Colors.cyan
            ),
          ),
          GestureDetector(
            onTap: (){},
            child: CircleAvatar(
              child: FaIcon(FontAwesomeIcons.instagram, color: Colors.white,), // Icon widget changed with FaIcon
              radius: 20.0,
              // backgroundColor: Colors.cyan
            ),
          ),
          GestureDetector(
            onTap: (){},
            child: CircleAvatar(
              child: FaIcon(FontAwesomeIcons.twitter, color: Colors.white,), // Icon widget changed with FaIcon
              radius: 20.0,
              // backgroundColor: Colors.cyan
            ),
          ),
          GestureDetector(
            onTap: (){},
            child: CircleAvatar(
              child: FaIcon(FontAwesomeIcons.linkedin, color: Colors.white,), // Icon widget changed with FaIcon
              radius: 20.0,
              // backgroundColor: Colors.cyan
            ),
          ),
          Container(),
        ],
      ),
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
        minLines: 1,
        maxLines: 5,
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

  itemsWithQuantity(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 40.0,
        minWidth: SizeConfig.screenWidth,
        maxHeight: SizeConfig.screenHeight,
        maxWidth: SizeConfig.screenWidth,
      ),
      child: ListView.builder(
        itemCount: GlobalVariables.cartList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return Container(
              height: SizeConfig.screenHeight * .05,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(left: 5, right: 5),
              child: GestureDetector(
                onTap: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    quantity(index, context),
                    productName(index, context),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  productName(int index, BuildContext context) {
    Map <String, dynamic> myMap = GlobalVariables.cartList[index];
    String name = myMap["product_name"];
    return Container(
      constraints: BoxConstraints(
          minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .88),
      child: globalWidgets.myTextCustom(context, "${name}", ColorsX.black.withOpacity(0.8), 10, 10, 5, 0, FontWeight.w600, 16),
    );
  }
  quantity(int index, BuildContext context) {
    Map <String, dynamic> myMap = GlobalVariables.cartList[index];
    int quantity = myMap["quantity"];
    return Container(
      constraints: BoxConstraints(
          minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .38),
      child: globalWidgets.myTextCustom(context, "${quantity} X ", ColorsX.black.withOpacity(0.8), 10, 10, 5, 0, FontWeight.w600, 16),
    );
  }
  placeMyOrder(BuildContext context) async {
    GlobalWidgets.hideKeyboard(context);
    orderStringList = [];
    Map <String, dynamic> myMap ;
    for(int index = 0; index < GlobalVariables.cartList.length; index ++){
      myMap = GlobalVariables.cartList[index];
      var orderString = "${myMap["quantity"]} X ${myMap["product_name"]} (${myMap['category']})";
      orderStringList.add(orderString);
    }
    debugPrint(orderStringList.toString());
    Map<String, dynamic> orderInfo = new Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    orderInfo["address"] = addressCtl.text.toString();
    orderInfo["amount_payable"] = GlobalVariables.amountPayable;
    orderInfo["city"] = cityCtl.text.toString();
    if(cityCtl.text.toString() == 'Lahore' || cityCtl.text.toString() == 'lahore') {
      orderInfo["delivery_charges"] = 0;
    }
    else {
      orderInfo["delivery_charges"] = 'PKR 250';
    }
    orderInfo["email"] = prefs.getString('email');
    orderInfo["full_name"] = prefs.getString('full_name');
    orderInfo["order_string"] = orderStringList;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM yy').format(now);
    orderInfo["date_time"] = formattedDate;
    GlobalWidgets.showProgressLoader('Please wait');
    var collection = FirebaseFirestore.instance.collection('orders');
    var docRef = await collection.add(orderInfo);
    var documentId = docRef.id;
    GlobalWidgets.hideProgressLoader();
    GlobalVariables.isOrderPlaced = true;
    setState(() {
      GlobalVariables.cartList = [];
    });
    Get.toNamed(Routes.SUCCESS_SCREEN);
  }
}
