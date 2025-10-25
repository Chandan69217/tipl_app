import 'package:flutter/material.dart';


void navigateWithAnimation(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

void navigatePushReplacementWithAnimation(BuildContext context, Widget screen){
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
        pageBuilder: (context,animation,secondaryAnimation) => screen,
      transitionsBuilder: (context,animation,secondaryAnimation,child){
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
    )
  );
}

void navigatePushAndRemoveUntilWithAnimation(BuildContext context, Widget screen){
  Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
          pageBuilder: (context,animation,secondaryAnimation) => screen,
          transitionsBuilder: (context,animation,secondaryAnimation,child){
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            final tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          }
      ),
      (route)=>false
  );
}




