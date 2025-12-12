import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: CustColors.white,
    textTheme: GoogleFonts.montserratTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(fontSize: 18,color: Colors.black),
    ),
    cardTheme: CardThemeData(
      color: CustColors.white
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      position: PopupMenuPosition.under,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(CustColors.white),
      fillColor: WidgetStateProperty.resolveWith<Color?>((state){
        if(state.contains(WidgetState.selected)){
          return Colors.deepOrange;
        }
        return null;
      }),
      overlayColor: WidgetStatePropertyAll(Colors.deepOrangeAccent.withValues(alpha: 0.2)),
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.5,color: CustColors.grey,),
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor:
        CustColors.blue_shade100, // Gradient start
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBackgroundColor: Colors.grey.shade400,
        disabledForegroundColor: Colors.white70,
        disabledIconColor: Colors.white70
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: CustColors.blue,
          backgroundColor: CustColors.grey.withValues(alpha: 0.1),
          padding: EdgeInsets.symmetric(horizontal: 18,vertical: 0),
          textStyle: TextStyle(fontSize: 14,fontWeight:FontWeight.w700)
      ),
    )
  );
}
