import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destiny_attire/app/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../utils/cache_data.dart';
import '../../utils/colors.dart';
import '../../utils/global_widgets.dart';
import '../../utils/size_config.dart';
import '../../views/widget/drawer_widget.dart';

class ProductsOfCategory extends StatefulWidget {
  const ProductsOfCategory({Key? key}) : super(key: key);

  @override
  _ProductsOfCategoryState createState() => _ProductsOfCategoryState();
}

class _ProductsOfCategoryState extends State<ProductsOfCategory> {

  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CacheData cacheData = CacheData();
  List<DocumentSnapshot> allProducts = [];
  Map<String, dynamic>? fetchDoc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
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
      floatingActionButton: new FloatingActionButton(
        backgroundColor: ColorsX.black,
        onPressed: () => cartOpen(context),
        tooltip: 'Cart',
        child: FaIcon(FontAwesomeIcons.shoppingCart, color: ColorsX.white,),
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
      // height: SizeConfig.screenHeight,
      // width: SizeConfig.screenWidth,
      child: ListView(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: Image.asset('assets/images/logo.png', height: 80, width: 80,)),
              ),
              allProducts.isEmpty? Container() :
              Align(
                alignment: Alignment.center,
                child: globalWidgets.myTextCustom(context, GlobalVariables.categoryChosen, ColorsX.black, 10, 10, 5, 10, FontWeight.w700, 20),
              ),
              allProducts.isEmpty ? Container() :
              showGridView(context),
              allProducts.isEmpty ? Container() :ourLinks(context),
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

  void getProducts() async {
    GlobalWidgets.showProgressLoader("Please wait");

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: GlobalVariables.categoryChosen)
        .get();

    final List<DocumentSnapshot> firestoreResponseListProducts = querySnapshot.docs;

    if (firestoreResponseListProducts.isEmpty) {
      debugPrint('no products available');
    }

    else {
      setState(() {
        allProducts = querySnapshot.docs;
        // GlobalVariables.featuredModelLength = documentsByCastes.length ?? 0;
        // GlobalVariables.featuredModelLength = featuredModel?.serverResponse.length ?? 0;
        print('all products length' + allProducts.length.toString());
      });
      GlobalWidgets.hideProgressLoader();
    }
  }

  errorDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        title: "No Product Found",
        desc:
        'Please try again',
        btnOkOnPress: () {
          Get.back();
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }


  showImageOfItem(List<DocumentSnapshot<Object?>>? documents, int index, BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 3, right: 3, bottom: 3),
      child: GestureDetector(
        onTap: (){
          debugPrint(documents?[index].get('product_name'));
          GlobalVariables.imagesListOfSpecificProduct = documents?[index].get('images');
          GlobalVariables.idOfProduct = "${documents?[index].reference.id}";
          Get.toNamed(Routes.PRODUCTS_DETAIL);
        },
        child: Center(
          child: Container(
            height: SizeConfig.screenHeight * .25,
            width: SizeConfig.screenWidth * .36,
            child: CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: documents?[index].get('images')[0],
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


  outOfStock(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: globalWidgets.myText(context, "Out of Stock", ColorsX.red_danger, 0, 5, 5, 0, FontWeight.w700, 20),
      ),
    );
  }

  showGridView(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: SizeConfig.screenHeight * .43, // Set as you want or you can remove it also.
        maxHeight: double.infinity,
      ),
      child: Container(
        // height: SizeConfig.screenHeight,
        // width: SizeConfig.screenWidth,
        child: GridView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          itemCount: allProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            // crossAxisSpacing: SizeConfig.marginVerticalXsmall,
            // mainAxisSpacing: SizeConfig.marginVerticalXsmall,
            crossAxisCount: 2,
            childAspectRatio: 0.5,
          ),
          itemBuilder: (contxt, index) {
            return  buildItem(index, context);
          },
        ),
      ),
    );
    // return Container(
    //   height: SizeConfig.screenHeight,
    //   width: SizeConfig.screenWidth,
    //   child: GridView.custom(
    //     shrinkWrap: true,
    //     physics: ScrollPhysics(),
    //     gridDelegate: SliverWovenGridDelegate.count(
    //       crossAxisCount: 2,
    //       mainAxisSpacing: 2,
    //       crossAxisSpacing: 2,
    //       pattern: [
    //         WovenGridTile(0.6),
    //         WovenGridTile(
    //           5 / 9,
    //           crossAxisRatio: 0.9,
    //           alignment: AlignmentDirectional.centerEnd,
    //         ),
    //       ],
    //     ),
    //     childrenDelegate: SliverChildBuilderDelegate(
    //           (context, index) {
    //             return ClipRRect(
    //               borderRadius: BorderRadius.circular(8),
    //               child: buildItem(index, context)
    //             );
    //           },
    //       childCount: allProducts.length,
    //     ),
    //   ),
    // );
  }

  buildItem(int index, BuildContext context) {
    return Container(

      height: SizeConfig.screenHeight * .43,
      width: SizeConfig.screenWidth * .38,
      child: Padding(
        padding: EdgeInsets.only(left: 8 , right:  8),
        child: GestureDetector(
          onTap: (){
            debugPrint(allProducts?[index].get('product_name'));
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 5,
            color: Colors.white,
            child: GestureDetector(
              onTap: (){},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  showImageOfItem(allProducts,index, context),
                  GestureDetector(
                    onTap: (){
                      debugPrint(allProducts?[index].get('product_name'));
                      GlobalVariables.imagesListOfSpecificProduct = allProducts?[index].get('images');
                      GlobalVariables.idOfProduct = "${allProducts?[index].reference.id}";
                      Get.toNamed(Routes.PRODUCTS_DETAIL);
                    },
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .38),
                      child: globalWidgets.myTextCustom(context, "${allProducts?[index].get('product_name')}", ColorsX.black, 0, 10, 5, 0, FontWeight.w600, 15),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      debugPrint(allProducts?[index].get('product_name'));
                      GlobalVariables.imagesListOfSpecificProduct = allProducts?[index].get('images');
                      GlobalVariables.idOfProduct = "${allProducts?[index].reference.id}";
                      Get.toNamed(Routes.PRODUCTS_DETAIL);
                    },
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: 0, minWidth: 11, maxWidth: SizeConfig.screenWidth * .38),
                      child: globalWidgets.myTextCustom(context, "${allProducts?[index].get('short_description')}", ColorsX.black.withOpacity(0.4), 0, 10, 5, 0, FontWeight.w600, 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      debugPrint(allProducts?[index].get('product_name'));
                      GlobalVariables.imagesListOfSpecificProduct = allProducts?[index].get('images');
                      GlobalVariables.idOfProduct = "${allProducts?[index].reference.id}";
                      Get.toNamed(Routes.PRODUCTS_DETAIL);
                    },
                    child: globalWidgets.cutText(context, "PKR ${allProducts?[index].get('cut_price')}", ColorsX.red_danger, 0, 10, 5, 0, FontWeight.w300, 15),
                  ),
                  GestureDetector(
                    onTap: (){
                      debugPrint(allProducts?[index].get('product_name'));
                      GlobalVariables.imagesListOfSpecificProduct = allProducts?[index].get('images');
                      GlobalVariables.idOfProduct = "${allProducts?[index].reference.id}";
                      Get.toNamed(Routes.PRODUCTS_DETAIL);
                    },
                    child: globalWidgets.myText(context, "PKR ${allProducts?[index].get('sale_price')}", ColorsX.black, 0, 10, 5, 0, FontWeight.w600, 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
  cartOpen(BuildContext context) {
    Get.toNamed(Routes.CART);
  }
}