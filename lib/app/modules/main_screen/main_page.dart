import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destiny_attire/app/views/widget/categories.dart';
import 'package:destiny_attire/app/views/widget/featured_item.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_pages.dart';
import '../../utils/cache_data.dart';
import '../../utils/colors.dart';
import '../../utils/global_variables.dart';
import '../../utils/global_widgets.dart';
import '../../utils/size_config.dart';
import '../../views/widget/drawer_widget.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CacheData cacheData = CacheData();
  String selectedCasteType = '';
  // FeaturedModel? featuredModel;
  List<DocumentSnapshot> documents = [];
  List<DocumentSnapshot> featuredProducts = [];
  List<DocumentSnapshot> allCategories = [];
  String? gender = '';
  SharedPreferences? prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFeaturedProducts();
  }
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
          // profession(context),
          // featuredModel == null ? Container() : FeaturedProposals(featuredModel: featuredModel),
          // documents.isEmpty ? Container() : FeaturedProposals(documents: documents,),
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                child: Image.asset('assets/images/logo.png', height: 80, width: 80,)),
          ),
          globalWidgets.myText(context, 'Featured', ColorsX.black, 20, 10, 0, 0, FontWeight.w700, 23),
          featuredProducts.isEmpty? Container() : ItemCardForFeatured(documents: featuredProducts,),
          globalWidgets.myText(context, 'Categories', ColorsX.black, 20, 10, 0, 0, FontWeight.w700, 23),
          featuredProducts.isEmpty? Container() : AllCategories(documents: allCategories,),
          // globalWidgets.myText(context, 'Matches available for theses professions', ColorsX.white, 0, 10, 0, 0, FontWeight.w400, 13),
          // // castes(context,),
          // peofessions(context,),
          // globalWidgets.myText(context, 'Castes', ColorsX.yellowColor, 20, 10, 0, 0, FontWeight.w700, 20),
          // globalWidgets.myText(context, 'Matches available for theses castes', ColorsX.white, 0, 10, 0, 0, FontWeight.w400, 13),
          // castes(context,),
        ],
      ),
    );
  }

  void loadFeaturedProducts() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();


    GlobalWidgets.showProgressLoader("Please wait");

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('is_featured', isEqualTo: '1')
        .where('is_available', isEqualTo: '1')
    // .limit(1)
        .get();
    final List<DocumentSnapshot> firestoreResponseList = querySnapshot.docs;

    final QuerySnapshot querySnapshotForCategories = await FirebaseFirestore.instance
        .collection('categories')
    // .limit(1)
        .get();
    final List<DocumentSnapshot> firestoreResponseListCategories = querySnapshotForCategories.docs;

    if(firestoreResponseList.isEmpty) {
      debugPrint('no featured and not available');
    }
    else {
      setState(() {
        featuredProducts = querySnapshot.docs;
        // GlobalVariables.featuredModelLength = documentsByCastes.length ?? 0;
        // GlobalVariables.featuredModelLength = featuredModel?.serverResponse.length ?? 0;
        print('featured length' + featuredProducts.length.toString());
      });
      // print(documents.first);
      //
      // String id = querySnapshot.docs[0].reference.id;
      // //parsing of data to save in shared preferences
      // for (var doc in querySnapshot.docs) {
      //   // Getting data directly
      //
      //   String religion = doc.get('religion');
      //   String caste = doc.get('caste');
      //   String subcaste = doc.get('subcaste');
      //   String sect = doc.get('sect');
      //   String account_created_at = doc.get('account_created_at');
      //   String mother_tongue = doc.get('mother_tongue');
      //   String phone = doc.get('primary_phone');
      //   String gender = doc.get('gender');
      //   saveDataInLocal(id,caste,religion,subcaste,sect,account_created_at,mother_tongue,phone,gender);
      //   debugPrint(id);
      //   // Getting data from map
      //   // Map<String, dynamic> data = doc.data();
      //   // int age = data['age'];
      // }
    }
    if(firestoreResponseListCategories.isEmpty) {
      debugPrint('no categories available');
    }

    else {
      setState(() {
        allCategories = querySnapshotForCategories.docs;
        // GlobalVariables.featuredModelLength = documentsByCastes.length ?? 0;
        // GlobalVariables.featuredModelLength = featuredModel?.serverResponse.length ?? 0;
        print('all categories length' + allCategories.length.toString());
      });
      // print(documents.first);
      //
      // String id = querySnapshot.docs[0].reference.id;
      // //parsing of data to save in shared preferences
      // for (var doc in querySnapshot.docs) {
      //   // Getting data directly
      //
      //   String religion = doc.get('religion');
      //   String caste = doc.get('caste');
      //   String subcaste = doc.get('subcaste');
      //   String sect = doc.get('sect');
      //   String account_created_at = doc.get('account_created_at');
      //   String mother_tongue = doc.get('mother_tongue');
      //   String phone = doc.get('primary_phone');
      //   String gender = doc.get('gender');
      //   saveDataInLocal(id,caste,religion,subcaste,sect,account_created_at,mother_tongue,phone,gender);
      //   debugPrint(id);
      //   // Getting data from map
      //   // Map<String, dynamic> data = doc.data();
      //   // int age = data['age'];
      // }
    }
    GlobalWidgets.hideProgressLoader();
//     var _apiService = ApiService();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     Map<String, dynamic> userInfo = Map();
//
//     userInfo['caste'] = GlobalVariables.valueChosen;
//     userInfo['gender'] = prefs.getString('gender');
//
//     GlobalWidgets.showProgressLoader("Please Wait");
//     GlobalWidgets.hideKeyboard(context);
//     final res = await _apiService.byCaste(apiParams: userInfo);
//     GlobalWidgets.hideProgressLoader();
//     if (res is ByCasteProposalsModel) {
//       setState(() {
//         byCasteProposalsModel = res;
//       });
//       print('hurrah');
//       // Get.toNamed(Routes.ALL_CASTES_MAIN_PAGE);
// //show success dialog
// //        successDialog(GlobalVariables.signUpResponse);
//     }
    // else {
    //   errorDialog(context);
    // }
  }

  featuredItem(BuildContext context){
    // int length = byCasteProposalsModel?.serverResponse.length ?? 0;
    int length = featuredProducts.length ?? 0;
    return ListView.separated(
        itemCount: length,
        separatorBuilder: (context, index) =>Divider(height: 1, color: ColorsX.light_orange),
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              // GlobalVariables.idOfProposal = "${byCasteProposalsModel?.serverResponse[index].basicDetails.id}";
              GlobalVariables.idOfProposal = "${featuredProducts[index].reference.id}";
              print(GlobalVariables.idOfProposal);
              GlobalVariables.isMyProfile = false;
              Get.toNamed(Routes.PROPOSALS_DETAIL);
            },
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 8.0,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            backgroundColor: ColorsX.yellowColor,
                            // child: globalWidgets.myText(context, (index+1).toString(), ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 12),
                            child: FaIcon(FontAwesomeIcons.handshake, color: ColorsX.black,)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.0,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // globalWidgets.myText(context, "${byCasteProposalsModel?.serverResponse[index].basicDetails.caste}", ColorsX.yellowColor, 5, 0, 0, 0, FontWeight.w900, 14),
                      globalWidgets.myText(context, "${featuredProducts[index].get('caste')}", ColorsX.yellowColor, 5, 0, 0, 0, FontWeight.w900, 14),
                      // globalWidgets.myText(context, ageCalculate("${byCasteProposalsModel?.serverResponse[index].basicDetails.dob}") + " | " +
                      //     heightCalculate("${byCasteProposalsModel?.serverResponse[index].basicDetails.height}"), ColorsX.white, 5, 0, 0, 0, FontWeight.w400, 12),
                      Container(
                        width: SizeConfig.screenWidth* .55,
                        // child: globalWidgets.myTextCustom(context, "${byCasteProposalsModel?.serverResponse[index].basicDetails.occupation} | ${byCasteProposalsModel?.serverResponse[index].basicDetails.qualification}",
                        //     ColorsX.white, 5, 0, 0, 0, FontWeight.w400, 12),
                        child: globalWidgets.myTextCustom(context, "${featuredProducts[index].get('occupation')} | ${featuredProducts[index].get('qualification')}",
                            ColorsX.white, 5, 0, 0, 0, FontWeight.w400, 12),
                      ),
                      // globalWidgets.myText(context, "${byCasteProposalsModel?.serverResponse[index].basicDetails.area}", ColorsX.white, 5, 0, 0, 5, FontWeight.w400, 12),
                      globalWidgets.myText(context, "${featuredProducts[index].get('area')}", ColorsX.white, 5, 0, 0, 5, FontWeight.w400, 12),

                    ],
                  ),
                  SizedBox(width: 8.0,),
                ],
              ),
              // child: ListTile(
              //
              //   leading: CircleAvatar(
              //     backgroundColor: ColorsX.yellowColor,
              //     child: globalWidgets.myText(context, (index+1).toString(), ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 12),
              //   ),
              //   title: globalWidgets.myText(context, index%2==0 ? "Siddiqui" : "Hashmi Qureshi", ColorsX.yellowColor, 0, 0, 0, 0, FontWeight.w900, 14),
              //   subtitle: globalWidgets.myText(context, "32 yrs | 5\u00276 \nEngineer | Software Engineer\n"
              //       "DHA Lahore", ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 13),
              //   trailing: globalWidgets.myText(context, "16 days ago", ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 13),
              // ),
            ),
          );
        }
    );
  }
  peofessions(BuildContext context) {

    return ListView.separated(
      itemCount: GlobalWidgets.professionsList.length,
        separatorBuilder: (context, index) =>Divider(height: 1, color: ColorsX.light_orange),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              GlobalVariables.isCaste = false;
              print(GlobalWidgets.professionsList[index]);
              GlobalVariables.valueChosen = GlobalWidgets.professionsList[index];
              Get.toNamed(Routes.PROPOSALS_LIST);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: ColorsX.yellowColor,
                child: globalWidgets.myText(context, (index+1).toString(), ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 12),
              ),
              title: globalWidgets.myText(context, GlobalWidgets.professionsList[index], ColorsX.white, 0, 0, 0, 0, FontWeight.w700, 15),
              subtitle: globalWidgets.myText(context, "Find best matches", ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 13),
              trailing: GestureDetector(
                onTap: (){
                  GlobalVariables.isCaste = false;
                  print(GlobalWidgets.professionsList[index]);
                  GlobalVariables.valueChosen = GlobalWidgets.professionsList[index];
                  Get.toNamed(Routes.PROPOSALS_LIST);
                },
                child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset(gender == 'Male' ? 'assets/images/woman.png' : 'assets/images/man.png', fit: BoxFit.contain, ),
                ),
              ),
            ),
          );
        });

  }

  castes(BuildContext context){
    return ListView.separated(
      itemCount: GlobalWidgets.casteList.length,
        separatorBuilder: (context, index) =>Divider(height: 1, color: ColorsX.light_orange),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              GlobalVariables.isCaste = true;
              print(GlobalWidgets.casteList[index]);
              GlobalVariables.valueChosen = GlobalWidgets.casteList[index];
              print(GlobalVariables.valueChosen);
              Get.toNamed(Routes.PROPOSALS_LIST);
            },
            child: index == 0 ? Container():ListTile(
              leading: CircleAvatar(
                backgroundColor: ColorsX.yellowColor,
                child: globalWidgets.myText(context, (index+1).toString(), ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 12),
              ),
              title: globalWidgets.myText(context, GlobalWidgets.casteList[index], ColorsX.white, 0, 0, 0, 0, FontWeight.w700, 15),
              subtitle: globalWidgets.myText(context, "Find best matches", ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 13),
              trailing: GestureDetector(
                onTap: (){
                  GlobalVariables.isCaste = true;
                  print(GlobalWidgets.casteList[index]);
                  GlobalVariables.valueChosen = GlobalWidgets.casteList[index];
                  Get.toNamed(Routes.PROPOSALS_LIST);
                },
                child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset(gender == 'Male' ? 'assets/images/woman.png' : 'assets/images/man.png', fit: BoxFit.contain, ),
                ),
              ),
            ),
          );
        });

  }

  Widget categoryType(BuildContext context, String type) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: GestureDetector(
            onTap: (){
              setState(() {
                selectedCasteType = type;
              });
            },
            child: Container(
              height: 120,
              width: SizeConfig.screenWidth * .30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 2,color: ColorsX.white),
                color: selectedCasteType == type ? ColorsX.light_orange : Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: FaIcon(gender == "Male" ? FontAwesomeIcons.female : FontAwesomeIcons.male, color: ColorsX.black,),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: Container(
                        child: globalWidgets.myText(context, type, ColorsX.black, 10, 5, 5, 0, FontWeight.w400, 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void getValues() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      gender = prefs?.getString('gender');
      print(gender);
    });
  }

  void getFeaturedProposals() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gender = prefs.getString('gender');
    // if(gender.toString() == 'Male'){
    //   gender == 'Female';
    // }else{
    //   gender == 'Male';
    // }

    GlobalWidgets.showProgressLoader("Please wait");

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('candidates')
        .where('is_featured', isEqualTo: '1')
        .where('gender', isNotEqualTo: gender)
        .where('is_active_account', isEqualTo: '1')
        // .limit(1)
        .get();
    final List<DocumentSnapshot> firestoreResponseList = querySnapshot.docs;
    if(firestoreResponseList.isEmpty) {
      print("No featured Proposals");
    }
    else {
      setState(() {
        documents = querySnapshot.docs;
        GlobalVariables.featuredModelLength = documents.length ?? 0;
        // GlobalVariables.featuredModelLength = featuredModel?.serverResponse.length ?? 0;
        print('featured length' + GlobalVariables.featuredModelLength.toString());
      });
      // print(documents.first);
      //
      // String id = querySnapshot.docs[0].reference.id;
      // //parsing of data to save in shared preferences
      // for (var doc in querySnapshot.docs) {
      //   // Getting data directly
      //
      //   String religion = doc.get('religion');
      //   String caste = doc.get('caste');
      //   String subcaste = doc.get('subcaste');
      //   String sect = doc.get('sect');
      //   String account_created_at = doc.get('account_created_at');
      //   String mother_tongue = doc.get('mother_tongue');
      //   String phone = doc.get('primary_phone');
      //   String gender = doc.get('gender');
      //   saveDataInLocal(id,caste,religion,subcaste,sect,account_created_at,mother_tongue,phone,gender);
      //   debugPrint(id);
      //   // Getting data from map
      //   // Map<String, dynamic> data = doc.data();
      //   // int age = data['age'];
      // }
    }
    GlobalWidgets.hideProgressLoader();
    // var _apiService = ApiService();
    //
    // Map<String, dynamic> userInfo = Map();
    //
    // userInfo['is_featured'] = '1';
    // userInfo['gender'] = prefs.getString('gender');
    //
    // GlobalWidgets.showProgressLoader("Please Wait");
    // GlobalWidgets.hideKeyboard(context);
    // final res = await _apiService.getFeaturedProposals(apiParams: userInfo);
    // GlobalWidgets.hideProgressLoader();
    // if (res is FeaturedModel) {
    //   setState(() {
    //     featuredModel = res;
    //     GlobalVariables.featuredModelLength = featuredModel?.serverResponse.length ?? 0;
    //     print('featured length' + GlobalVariables.featuredModelLength.toString());
    //   });
    // }
    // else {
    //   print("No featured Proposals");
    //   // errorDialog(context);
    // }
  }

  heightCalculate(String height) {
    String newHeight = height;
    if(height.contains('@')){
      newHeight = height.replaceAll("@", "\u0027");
    }
    return newHeight;
  }

  accountCreated(String dateTime) {
    int days = 0;
    DateTime today = DateTime.now();
    DateTime incoming = DateTime.parse(dateTime);
    days = today.difference(incoming).inDays;
    if(days < 1){
      days = today.difference(incoming).inHours;
      return days.toString()+ ' hours ago';
    }else{
      return days.toString() + ' days ago';
    }
  }
  errorDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        title: "No proposal Found",
        desc:
        'Please try again',
        btnOkOnPress: () {
          Get.back();
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }
}
