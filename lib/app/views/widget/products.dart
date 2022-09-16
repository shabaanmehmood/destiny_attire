import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destiny_attire/app/utils/colors.dart';
import 'package:destiny_attire/app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../utils/global_variables.dart';
import '../../utils/global_widgets.dart';
class Products extends StatelessWidget {
  final List<DocumentSnapshot>? documents;
  Products({this.documents});
  GlobalWidgets globalWidgets = GlobalWidgets();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * .43,
      width: SizeConfig.screenWidth * .35,
      child: ListView.builder(
          itemCount: documents?.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 8 : 2, right: index == documents!.length-1 ? 8 : 0),
              child: GestureDetector(
                onTap: (){
                  GlobalVariables.idOfProduct = "${documents?[index].reference.id}";
                  Get.toNamed(Routes.PRODUCTS_DETAIL);
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  elevation: 5,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: (){
                      GlobalVariables.idOfProduct = "${documents?[index].reference.id}";
                      Get.toNamed(Routes.PRODUCTS_DETAIL);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showImageOfItem(documents,index, context),
                        Container(
                          width: SizeConfig.screenWidth * .35,
                          child: globalWidgets.myTextCustom(context, "${documents?[index].get('product_name')}", ColorsX.black, 0, 10, 5, 0, FontWeight.w600, 15),
                        ),
                        Container(
                          width: SizeConfig.screenWidth * .35,
                          child: globalWidgets.myTextCustom(context, "${documents?[index].get('short_description')}", ColorsX.black.withOpacity(0.4), 0, 10, 5, 0, FontWeight.w600, 12),
                        ),

                        globalWidgets.cutText(context, "PKR ${documents?[index].get('cut_price')}", ColorsX.red_danger, 0, 10, 5, 0, FontWeight.w300, 15),
                        globalWidgets.myText(context, "PKR ${documents?[index].get('sale_price')}", ColorsX.black, 0, 10, 5, 0, FontWeight.w600, 15),

                      ],
                    ),
                  ),
                ),
              ),
            );

          }
      ),
    );
  }

  showImageOfItem(List<DocumentSnapshot<Object?>>? documents, int index, BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 3, right: 3, bottom: 3),
      child: Container(
        height: SizeConfig.screenHeight * .25,
        width: SizeConfig.screenWidth * .36,
        child: CachedNetworkImage(
          fit: BoxFit.scaleDown,
          imageUrl: documents?[index].get('images')[0],
          placeholder: (context,url) => Container(
            child: Image.asset('assets/images/logo.png', height: 100, width: 100,),
          ),
          // progressIndicatorBuilder: (context, url, downloadProgress) =>
          //     CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

}
