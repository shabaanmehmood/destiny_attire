import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../utils/colors.dart';
import '../../utils/global_variables.dart';
class AnimatedFloatingButton extends StatefulWidget {
  const AnimatedFloatingButton({Key? key}) : super(key: key);

  @override
  _AnimatedFloatingButtonState createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton> with SingleTickerProviderStateMixin{
  AnimationController? _animationController;
  Animation? animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = ColorTween(begin: Colors.red, end: Colors.amber)
        .animate(_animationController!);
    _animationController?.repeat();
    _animationController?.addListener(() {
      setState(() {});
    });
  }
  // @override
  // void dispose() {
  //   super.dispose();
  //
  //   controller.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
      backgroundColor: GlobalVariables.cartList.isEmpty ? ColorsX.black : animation?.value,
      onPressed: () => cartOpen(context),
      tooltip: 'Cart',
      child: FaIcon(FontAwesomeIcons.shoppingCart, color: ColorsX.white,),
    );
  }
  cartOpen(BuildContext context) {
    Get.toNamed(Routes.CART);
  }
}
