import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destiny_attire/app/utils/colors.dart';
import 'package:destiny_attire/app/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../utils/global_widgets.dart';
class AllCategories extends StatelessWidget {
  final List<DocumentSnapshot>? documents;
  AllCategories({this.documents});
  GlobalWidgets globalWidgets = GlobalWidgets();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * .35,
      width: SizeConfig.screenWidth * .35,
      child: ListView.builder(
          itemCount: documents?.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 8 : 2, right: index == documents?.length ? 8 : 0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                elevation: 5,
                color: Colors.white,
                child: GestureDetector(
                  onTap: (){},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showImageOfItem(documents,index, context),
                      Container(
                        width: SizeConfig.screenWidth * .35,
                        child: globalWidgets.myTextCustom(context, "${documents?[index].get('name')}", ColorsX.black, 0, 10, 5, 0, FontWeight.w600, 15),
                      ),
                      Container(
                        width: SizeConfig.screenWidth * .35,
                        child: globalWidgets.myTextCustom(context, "${documents?[index].get('any_text')}", ColorsX.black.withOpacity(0.4), 0, 10, 5, 0, FontWeight.w600, 12),
                      ),
                    ],
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
          imageUrl: documents?[index].get('cat_image'),
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
