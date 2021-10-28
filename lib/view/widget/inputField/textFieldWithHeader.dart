import 'package:cotafer_server_status/view/widget/inputField/inputTextField.dart';
import 'package:flutter/material.dart';

class TextfieldWithHeader extends StatelessWidget {
  const TextfieldWithHeader({
    Key? key,
    this.headText   : '',
    this.valueText  : '',
    this.numberType : false,
    this.validate   : false,
    this.onChanged, this.textColor, 
  }) : super(key: key);

  final headText;
  final valueText;
  final numberType;
  final bool validate;
  final Color? textColor;
  final ValueChanged<String>? onChanged;

  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding : const EdgeInsets.only(bottom: 5),
            child   : Text('$headText',
                style: TextStyle(
                    fontSize  : 18.0, 
                    fontWeight: FontWeight.w500, 
                    color     : Colors.indigo)),
          ),
          InputTextField(
            validate  : validate,
            textColor : textColor,
            onChanged : onChanged,
            text      : '$headText', 
            value     : valueText, 
            numberType: numberType)
        ],
      ),
    );
  }
}
