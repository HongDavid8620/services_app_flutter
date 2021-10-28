import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  const InputTextField({
    Key? key,
    this.icon,
    required this.text,
    this.password,
    this.textColor  : Colors.black, 
    this.value      : '', 
    this.numberType : false,
    this.validate   : false,
    this.onChanged, 
    this.onFieldSubmitted, 
    this.onSaved, this.focusNode, this.maxLength:50, 
  }) : super(key: key);

  final Icon? icon;
  final String text;
  final bool? password;
  final Color? textColor;
  final String value;
  final bool numberType;
  final bool validate;
  final int maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FocusNode? focusNode;

  validationBorder(){
    if(validate) { 
      return BorderSide(color: Colors.red, width: 1);
    }else
      return BorderSide(color: Colors.white, width: 0);
  }

  @override
  _InputTextFieldState createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  var obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation   : 2.0, // Set here what you wish!
      shadowColor : Colors.grey[50],
      borderRadius: BorderRadius.all(Radius.circular(10.0)),

      child: Row(
        children: [
          //textfiels
          Expanded(
            child: SizedBox(
              height: 63,
              child : Theme(
                data: ThemeData(
                  primaryColor: Colors.redAccent,
                  primaryColorDark: Colors.red,
                ),
                child: TextFormField(           
                  focusNode: widget.focusNode,     
                  style: TextStyle(
                      color   : widget.textColor,
                      fontSize: 20),
                  initialValue    : widget.value,
                  maxLength: widget.maxLength,

                  onChanged       : widget.onChanged,
                  onSaved         : widget.onSaved,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  keyboardType    : widget.numberType?TextInputType.number:null,
                  decoration      : InputDecoration(
                    //boarder
                    focusedBorder: OutlineInputBorder(
                        borderSide: widget.validationBorder(),
                        ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: widget.validationBorder(),
                        ),
                    
                    counterText: "",
                    hintText    : '${widget.text}',
                    hintStyle: TextStyle(color: Color.fromRGBO(169, 169, 169, 0.7),letterSpacing: 0.1),
                    // errorBorder : InputBorder.none,
                  ),
                  obscureText: (widget.password == true && obscureText == true)
                      ? true
                      : false,
                ),
              ),
            ),
          ),

          //suffix Icon
          if (widget.password != null)
            Padding(
              padding : const EdgeInsets.symmetric(horizontal: 10),
              child   : InkWell(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: obscureText
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility)),
            )
          else if (widget.icon != null)
            Padding(
              padding : const EdgeInsets.symmetric(horizontal: 10),
              child   : widget.icon,
            )
          else
            SizedBox()
        ],
      ),
    );
  }
}
