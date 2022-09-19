import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/cache_data.dart';
import '../../utils/colors.dart';
import '../../utils/global_widgets.dart';
import '../../utils/size_config.dart';
import '../../views/widget/drawer_widget.dart';
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

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
                    margin: EdgeInsets.only(top: SizeConfig.screenHeight * .12),
                    child: Image.asset('assets/images/logo.png', height: 200, width: 200,)),
              ),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.center,
                child: FaIcon(FontAwesomeIcons.firstOrder, color: ColorsX.greenish,),
              ),
              Align(
                alignment: Alignment.center,
                child: globalWidgets.myText(context, 'Order Placed Successfully', ColorsX.greenish, 20, 15, 0, 0, FontWeight.w600, 23),
              ),
              Align(
                alignment: Alignment.center,
                child: globalWidgets.myText(context, 'Thank you for placing order !', ColorsX.black, 20, 15, 0, 0, FontWeight.w600, 18),
              ),
              Align(
                alignment: Alignment.center,
                child: globalWidgets.myText(context, 'We will contact you in a few minutes', ColorsX.black, 20, 15, 0, 0, FontWeight.w600, 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
