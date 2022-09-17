import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../theme.dart';

class InputFieldWidget extends StatelessWidget {
  final String inputFiledLabel, hint;
  final TextEditingController? textEditingController;
  final Widget? widget;
  const InputFieldWidget(
      {Key? key,
      required this.inputFiledLabel,
      required this.hint,
      this.textEditingController,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              inputFiledLabel,
              style: titleStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: darkGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor:
                        Get.isDarkMode ? Colors.black : Colors.grey[400],
                    controller: textEditingController,
                    style: inputSubitleStyle,
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subitleStyle,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: context.theme.backgroundColor, width: 0),
                        )),
                  )),
                  widget == null
                      ? Container()
                      : Container(
                          child: widget,
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
