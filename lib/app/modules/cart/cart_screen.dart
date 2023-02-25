import 'package:cached_network_image/cached_network_image.dart';
import 'package:destiny_attire/app/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/app_pages.dart';
import '../../utils/cache_data.dart';
import '../../utils/colors.dart';
import '../../utils/global_widgets.dart';
import '../../utils/size_config.dart';
import '../../views/widget/drawer_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CacheData cacheData = CacheData();
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // loadCategories();
  // }
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
      child: Container(
        // height: SizeConfig.screenHeight,
        // width: SizeConfig.screenWidth,
        child: ListView(
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
                GlobalVariables.cartList.isEmpty ? Center(
                  child: globalWidgets.myText(context, 'No Item Added In Cart', ColorsX.black, 0, 15, 15, 0, FontWeight.w500, 20),
                ) : buildCartItems(context),
                GlobalVariables.cartList.isEmpty ? Container() : globalWidgets.myText(context, 'Total Amount To Be Paid', ColorsX.black, 20, 5, 5, 0, FontWeight.w700, 22),
                GlobalVariables.cartList.isEmpty ? Container() : showTotalAmount(context),
                SizedBox(height: 30,),
                GlobalVariables.cartList.isEmpty ? Container() : checkoutButton(context),
                SizedBox(height: 15,),
                GlobalVariables.cartList.isEmpty ? Container() : continueShopping(context),
                SizedBox(height: 15,),
                GlobalVariables.cartList.isEmpty ? Container() : ourLinks(context),
                SizedBox(height: 30,),
                // allCategories.isEmpty ? Container() :
                // showGridView(context),
                // allCategories.isEmpty ? Container() :ourLinks(context),
                // Container(
                //   margin: EdgeInsets.only(bottom: SizeConfig.screenHeight * .02),
                // ),
              ],
            ),
          ],
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

  continueShopping(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.back();
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

  buildCartItems(BuildContext context) {

      return ListView.builder(
        itemCount: GlobalVariables.cartList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
        return Container(
          height: SizeConfig.screenHeight * .20,
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.only(left: 5, right: 5),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 5,
            color: Colors.white,
            child: GestureDetector(
              onTap: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  showImageOfItem(index, context),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productName(index, context),
                      cutPrice(index, context),
                      salePrice(index, context),
                      counter(index, context),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            removeItem(index,context);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsX.red_danger,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          margin: EdgeInsets.only(left: SizeConfig.screenWidth * .10, right: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: globalWidgets.myText(context, 'Remove', ColorsX.white, 0, 5, 5, 0, FontWeight.w500, 15),

                          )),
                        ),
                      globalWidgets.myText(context, 'Amount Payable', ColorsX.greenish, SizeConfig.screenHeight * .05, 0, 5, 0, FontWeight.w500, 15),
                      amountPayableItem(index, context),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        }
      );

  }
  showImageOfItem(int index, BuildContext context) {

    Map <String, dynamic> myMap = GlobalVariables.cartList[index];
    debugPrint(myMap.toString());
    String imageUrl = myMap["image_url"];
    debugPrint(imageUrl);
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 3, right: 3, bottom: 10),
      child: GestureDetector(
        onTap: (){
          debugPrint(imageUrl);
          // GlobalVariables.imagesListOfSpecificProduct = documents?[index].get('images');
          // GlobalVariables.idOfProduct = "${documents?[index].reference.id}";
          // Get.toNamed(Routes.PRODUCTS_DETAIL);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: SizeConfig.screenHeight * .16,
            width: SizeConfig.screenWidth * .25,
            child: CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: imageUrl,
              placeholder: (context,url) => Container(
                child: Image.asset('assets/images/logo.png', height: 100, width: 100,),
              ),
              // progressIndicatorBuilder: (context, url, downloadProgress) =>
              //     CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  productName(int index, BuildContext context) {
    Map <String, dynamic> myMap = GlobalVariables.cartList[index];
    String name = myMap["product_name"];
    return Container(
      constraints: BoxConstraints(
          minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .38),
      child: globalWidgets.myTextCustom(context, "${name}", ColorsX.black, 10, 10, 5, 0, FontWeight.w600, 16),
    );
  }
  cutPrice(int index, BuildContext context) {
    Map <String, dynamic> myMap = GlobalVariables.cartList[index];
    String name = myMap["cut_price"].toString();
    return Container(
      constraints: BoxConstraints(
          minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .38),
      child: globalWidgets.cutText(context, "PKR${name}", ColorsX.red_danger, 0, 10, 5, 0, FontWeight.w600, 16),
    );
  }
  salePrice(int index, BuildContext context) {
    Map <String, dynamic> myMap = GlobalVariables.cartList[index];
    String name = myMap["sale_price"].toString();
    return Container(
      constraints: BoxConstraints(
          minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .38),
      child: globalWidgets.myTextCustom(context, "PKR${name}", ColorsX.blue_gradient_dark, 0, 10, 5, 0, FontWeight.w600, 16),
    );
  }

  amountPayableItem(int index, BuildContext context) {
    Map <String, dynamic> myMap = GlobalVariables.cartList[index];
    int amount_payable_for_item = myMap["sale_price"];
    int quantity = myMap["quantity"];
    amount_payable_for_item = quantity * amount_payable_for_item;
    myMap.update('amount_payable', (value) => amount_payable_for_item);
    debugPrint(amount_payable_for_item.toString());
    return Container(
      constraints: BoxConstraints(
          minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .38),
      child: globalWidgets.myTextCustom(context, "PKR${amount_payable_for_item}", ColorsX.greenish, 0, 0, 0, 0, FontWeight.w600, 16),
    );
  }

  counter(int index, BuildContext context) {
    Map <String, dynamic> myMap = GlobalVariables.cartList[index];
    int quantity = myMap["quantity"];
    int salePrice = myMap["sale_price"];
    return Container(
      margin: EdgeInsets.only(left: 10, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              if(quantity > 1) {
                setState(() {
                  quantity = quantity - 1;
                  myMap.update('quantity', (value) => quantity);
                  myMap.update('amount_payable', (value) => quantity * salePrice);
                });
                debugPrint(quantity.toString());
              }
            },
              child: Container(child: FaIcon(FontAwesomeIcons.minusCircle, color: ColorsX.black,))
          ),
          globalWidgets.myTextCustom(context, "${quantity}", ColorsX.blue_gradient_dark, 0, 12, 12, 0, FontWeight.w600, 16),
          GestureDetector(
            onTap: (){
              setState(() {
                quantity = quantity + 1;
                myMap.update('quantity', (value) => quantity);
                myMap.update('amount_payable', (value) => quantity * salePrice);
              });
              debugPrint(quantity.toString());
              },
              child: Container(
                  child: FaIcon(FontAwesomeIcons.plusCircle, color: ColorsX.black,)
              )
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
    return globalWidgets.myText(context, "PKR ${totalAmount}", ColorsX.black, 15, 0, 0, 0, FontWeight.w700, 20);;
  }

  void removeItem( int index, BuildContext context) {
    setState(() {
      GlobalVariables.cartList.removeAt(index);
    });
    debugPrint("new array" + GlobalVariables.cartList.toString());
  }

  checkoutButton(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routes.CHECKOUT_SCREEN);
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
            child: globalWidgets.myText(context, "Continue to Checkout", ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 17),
          ),
        ),
      ),
    );
  }

}
