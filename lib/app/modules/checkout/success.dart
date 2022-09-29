import 'package:destiny_attire/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../utils/cache_data.dart';
import '../../utils/colors.dart';
import '../../utils/global_widgets.dart';
import '../../utils/size_config.dart';
import '../../views/widget/drawer_widget.dart';
class SuccessScreen extends StatefulWidget {
  final String orderId;
  final String city;
  final String address;
  final String actualDate;
  final String actualTime;
  SuccessScreen(this.orderId, this.city, this.address, this.actualDate, this.actualTime);
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CacheData cacheData = CacheData();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: body(context),
        // drawer: DrawerWidget(context),
        appBar: AppBar(
          backgroundColor: const Color(0xffEEEEEE).withOpacity(0.8),
          centerTitle: true,
          title: Image.asset('assets/images/logo.png', height: 40, width: 50,),
          // leading: IconButton(
          //   icon: Icon(Icons.menu_rounded, color: ColorsX.black,),
          //   onPressed: () => _scaffoldKey.currentState?.openDrawer(), //Scaffold.of(context).openDrawer(),
          // ),
        ),
        // floatingActionButton: new FloatingActionButton(
        //   backgroundColor: ColorsX.black,
        //   onPressed: () => cartOpen(context),
        //   tooltip: 'Cart',
        //   child: FaIcon(FontAwesomeIcons.shoppingCart, color: ColorsX.white,),
        // ),
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
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.screenHeight * .10),
                    child: Image.asset('assets/images/logo.png', height: 140, width: 140,)),
              ),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.center,
                child: Icon(Icons.done, color: ColorsX.greenish, size: 30,),
              ),
              Align(
                alignment: Alignment.center,
                child: globalWidgets.myText(context, 'Order Placed Successfully', ColorsX.black, 20, 15, 0, 0, FontWeight.w600, 23),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: globalWidgets.myText(context, 'Order Id:', ColorsX.black.withOpacity(0.6), 8, 15, 0, 0, FontWeight.w600, 15),),
                  Expanded(child: globalWidgets.myText(context, '${widget.orderId}', ColorsX.black.withOpacity(0.6), 8, 15, 20, 0, FontWeight.w600, 15),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: globalWidgets.myText(context, 'City:', ColorsX.black.withOpacity(0.6), 8, 15, 0, 0, FontWeight.w600, 15),),
                  Expanded(child: globalWidgets.myText(context, '${widget.city}', ColorsX.black.withOpacity(0.6), 8, 15, 20, 0, FontWeight.w600, 15),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: globalWidgets.myText(context, 'Address:', ColorsX.black.withOpacity(0.6), 8, 15, 0, 0, FontWeight.w600, 15),),
                  Expanded(child: globalWidgets.myText(context, '${widget.address}', ColorsX.black.withOpacity(0.6), 8, 15, 20, 0, FontWeight.w600, 15),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: globalWidgets.myText(context, 'Date:', ColorsX.black.withOpacity(0.6), 8, 15, 0, 0, FontWeight.w600, 15),
                  ),
                  Expanded(
                      child: globalWidgets.myText(context, '${widget.actualDate}', ColorsX.black.withOpacity(0.6), 8, 15, 20, 0, FontWeight.w600, 15),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: globalWidgets.myText(context, 'Time:', ColorsX.black.withOpacity(0.6), 8, 15, 0, 0, FontWeight.w600, 15),
                  ),
                  Expanded(
                    child: globalWidgets.myText(context, '${widget.actualTime}', ColorsX.black.withOpacity(0.6), 8, 15, 20, 0, FontWeight.w600, 15),
                  ),
                      ],
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: globalWidgets.myText(context, 'Order Id: ${widget.orderId}', ColorsX.black.withOpacity(0.6), 20, 15, 0, 0, FontWeight.w600, 15),
              // ),
              Align(
                alignment: Alignment.center,
                child: globalWidgets.myText(context, 'Thank you for placing order !', ColorsX.black, 20, 15, 0, 0, FontWeight.w600, 18),
              ),
              Align(
                alignment: Alignment.center,
                child: globalWidgets.myText(context, 'We will contact you in a few minutes', ColorsX.black, 20, 15, 0, 0, FontWeight.w600, 18),
              ),
              SizedBox(height: 25,),
              continueShopping(context),
              SizedBox(height: 25,),
            ],
          ),
        ],
      ),
    );
  }
  continueShopping(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routes.MAIN_SCREEN);
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
            child: globalWidgets.myText(context, "Continue Shopping", ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 17),
          ),
        ),
      ),
    );
  }
}
