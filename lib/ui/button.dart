import 'package:flutter/material.dart';
import 'package:todoapp/theme.dart';

class ButtonWidget extends StatelessWidget {
  final String btn_label;
  final Function()? btn_onTap;
  const ButtonWidget(
      {Key? key, required this.btn_label, required this.btn_onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: btn_onTap,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: primaryColor),
        child: Center(
          child: Text(
            btn_label,
            style: TextStyle(color: white),
          ),
        ),
      ),
    );
  }
}
