import 'package:flutter/material.dart';
import 'package:artgen/constants.dart';

class MyInputTheme {
  TextStyle _builtTextStyle(Color color, {double size = 16.0}) {
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: color,
        width: 0.5,
      ),
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
        contentPadding: EdgeInsets.all(15),
        //isDense seems to do nothing if you pass padding in
        isDense: true,
        //"always" put the label at the top
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //This can be useful for putting TextFields in a row
        //However, it might be more desirable t o wrap with Flecible
        //to make them grow to the available width
        constraints: const BoxConstraints(
          maxWidth: 450,
          minWidth: 150,
        ),

        ///Borders
        //Enabled and not showing error
        enabledBorder: _buildBorder(kGrey),
        //Has error but not focus
        errorBorder: _buildBorder(kRed),
        //Has error and focus
        focusedErrorBorder: _buildBorder(kGreen),
        //Default vaule if border are null
        // border: _buildBorder(Color.yellow),
        //Enabled and focused
        focusedBorder: _buildBorder(kBlue),
        //DisabledBorder
        disabledBorder: _buildBorder(kGrey),

        ///TextStyles
        suffixStyle: _builtTextStyle(kBlack),
        counterStyle: _builtTextStyle(kGrey, size: 12.0),
        floatingLabelStyle: _builtTextStyle(kBlack, size: 12.0),
        //Make error and helper the same size, so that the field
        //does not grow in height when there is an error text
        errorStyle: _builtTextStyle(kRed, size: 12.0),
        helperStyle: _builtTextStyle(kRed, size: 12.0),
        hintStyle: _builtTextStyle(kGrey),
        labelStyle: _builtTextStyle(kBlack),
        prefixStyle: _builtTextStyle(kBlack),
      );
}
