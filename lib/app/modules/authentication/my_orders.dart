import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/app_pages.dart';
import '../../utils/cache_data.dart';
import '../../utils/colors.dart';
import '../../utils/global_variables.dart';
import '../../utils/global_widgets.dart';
import '../../utils/size_config.dart';
import '../../views/widget/drawer_widget.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CacheData cacheData = CacheData();
  List<DocumentSnapshot> allOrders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orders();
  }

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
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: Image.asset('assets/images/logo.png', height: 80, width: 80,)),
              ),
              SizedBox(height: 15,),
              allOrders.isEmpty ? Center(
                child: Container(
                  child: globalWidgets.myText(context, 'You have not placed any order yet', ColorsX.black, 10, 10, 10, 0, FontWeight.w700, 25),
                ),
              ) : listOfOrders(context),
              allOrders.isEmpty ? Container() :ourLinks(context),
              Container(
                margin: EdgeInsets.only(bottom: SizeConfig.screenHeight * .02),
              ),
            ],
          ),
        ],
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
            onTap: () async {
              try{
                await launch(
                  'https://www.facebook.com/destinyattireonline',
                  universalLinksOnly: true,
                );
              }
              catch(e){
                print(e.toString());
              }
            },
            child: CircleAvatar(
              child: FaIcon(FontAwesomeIcons.facebookF, color: Colors.white,), // Icon widget changed with FaIcon
              radius: 20.0,
              // backgroundColor: Colors.cyan
            ),
          ),
          GestureDetector(
            onTap: () async {
              try{
                await launch(
                  'https://www.instagram.com/destiny.attire/',
                  universalLinksOnly: true,
                );
              }
              catch(e){
                print(e.toString());
              }
            },
            child: CircleAvatar(
              child: FaIcon(FontAwesomeIcons.instagram, color: Colors.white,), // Icon widget changed with FaIcon
              radius: 20.0,
              // backgroundColor: Colors.cyan
            ),
          ),
          // GestureDetector(
          //   onTap: (){},
          //   child: CircleAvatar(
          //       child: FaIcon(FontAwesomeIcons.twitter, color: Colors.white,), // Icon widget changed with FaIcon
          //       radius: 20.0,
          //       // backgroundColor: Colors.cyan
          //   ),
          // ),
          // GestureDetector(
          //   onTap: (){},
          //   child: CircleAvatar(
          //       child: FaIcon(FontAwesomeIcons.linkedin, color: Colors.white,), // Icon widget changed with FaIcon
          //       radius: 20.0,
          //       // backgroundColor: Colors.cyan
          //   ),
          // ),
          Container(),
        ],
      ),
    );
  }
  void orders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? email = preferences.getString('email');
    GlobalWidgets.showProgressLoader("Please wait");

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('email',isEqualTo: email)
        .get();
    final List<DocumentSnapshot> firestoreResponseList = querySnapshot.docs;

    if (firestoreResponseList.isEmpty) {
      debugPrint('no orders and not available');
      errorDialog(context);
    }
    else {
      setState(() {
        allOrders = querySnapshot.docs;
        // GlobalVariables.featuredModelLength = documentsByCastes.length ?? 0;
        // GlobalVariables.featuredModelLength = featuredModel?.serverResponse.length ?? 0;
        print('orders length' + allOrders.length.toString());
      });
    }
    GlobalWidgets.hideProgressLoader();
  }



  errorDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        title: "No Orders Found",
        desc:
        'You have not placed any order yet',
        btnOkOnPress: () {
          Get.back();
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }

  listOfOrders(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: allOrders.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return  buildItem(index, context);
          },
      ),
    );
  }
  buildItem(int index, BuildContext context) {
    debugPrint("data is ${allOrders?[index].get('date').toString()}");
    debugPrint("data is ${allOrders?[index].get('time').toString()}");
    return Container(
        height: SizeConfig.screenHeight * .10,
        width: SizeConfig.screenWidth * .38,
        child: Padding(
          padding: EdgeInsets.only(left: 8 , right:  8),
          child: GestureDetector(
            onTap: (){
              showDialogNow(context, index);
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              elevation: 5,
              color: Colors.white,
              child: GestureDetector(
                onTap: (){
                  showDialogNow(context, index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        // GlobalVariables.idOfOrder = "${allOrders?[index].reference.id}";
                        // Get.toNamed(Routes.PRODUCTS_DETAIL);
                        showDialogNow(context, index);

                      },
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .88),
                        child: globalWidgets.myTextCustom(context, "PKR ${allOrders?[index].get('amount_payable')}", ColorsX.black, 0, 10, 5, 0, FontWeight.w600, 25),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        // GlobalVariables.idOfOrder = "${allOrders?[index].reference.id}";
                        // Get.toNamed(Routes.PRODUCTS_DETAIL);
                        showDialogNow(context, index);

                      },
                      child: Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                minHeight: 0, minWidth: 100, maxWidth: SizeConfig.screenWidth * .28),
                            child: globalWidgets.myTextCustom(context, "${allOrders?[index].get('date').toString()}", ColorsX.black.withOpacity(0.4), 0, 10, 5, 0, FontWeight.w600, 15),
                          ),
                          Container(
                            constraints: BoxConstraints(
                                minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .28),
                            child: globalWidgets.myTextCustom(context, "${allOrders?[index].get('time').toString()}", ColorsX.black.withOpacity(0.4), 0, 10, 5, 0, FontWeight.w600, 15),
                          ),
                        ],
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //     GlobalVariables.idOfOrder = "${allOrders?[index].reference.id}";
                    //     Get.toNamed(Routes.PRODUCTS_DETAIL);
                    //   },
                    //   child: globalWidgets.cutText(context, "PKR ${allOrders?[index].get('cut_price')}", ColorsX.red_danger, 0, 10, 5, 0, FontWeight.w300, 15),
                    // ),
                    // GestureDetector(
                    //   onTap: (){
                    //     GlobalVariables.idOfOrder = "${allOrders?[index].reference.id}";
                    //     Get.toNamed(Routes.PRODUCTS_DETAIL);
                    //   },
                    //   child: globalWidgets.myText(context, "PKR ${allOrders?[index].get('sale_price')}", ColorsX.black, 0, 10, 5, 0, FontWeight.w600, 15),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
  showDialogNow(BuildContext context, int index){
    Get.defaultDialog(
      title: 'items',
      content: SizedBox(
        width: 300,
        child: Container(
          height: SizeConfig.screenHeight * .20,
          width: SizeConfig.screenWidth,
          child: ListView.builder(
              itemCount: allOrders[index].get('order_string').length,
              itemBuilder: (context, index1){
                return Container(
                  child: globalWidgets.myTextCustom(context, "${allOrders[index].get('order_string')[index1]}", ColorsX.black, 0, 10, 5, 0, FontWeight.w600, 18),
                );
              }
          ),
        ),
      ),
    );
    // return new Dialog(
    //   child: Container(
    //     height: SizeConfig.screenHeight * .20,
    //     width: SizeConfig.screenWidth,
    //     child: ListView.builder(
    //         itemCount: allOrders[index].get('order_string').length,
    //         itemBuilder: (context, index1){
    //           return Container(
    //             child: globalWidgets.myTextCustom(context, "PKR ${allOrders[index].get('order_string')[index1]}", ColorsX.black, 0, 10, 5, 0, FontWeight.w600, 18),
    //           );
    //         }
    //         ),
    //   ),
    // );
  }
}
