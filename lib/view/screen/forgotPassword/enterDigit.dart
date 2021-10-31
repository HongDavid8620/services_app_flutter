import 'package:services_flutter/view/screen/dashboard/dashboard.dart';
import 'package:services_flutter/view/widget/customButton.dart';
import 'package:services_flutter/view/widget/firstPageTopBackground.dart';
import 'package:services_flutter/view/widget/showLoadingDialog.dart';
import 'package:services_flutter/view_model/bloc/debouncer/debouncer.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldEvent.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/textField_bloc.dart';
import 'package:services_flutter/view_model/service/password/submitNewPasswordService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterDigit extends StatefulWidget {
  const EnterDigit({
    Key? key,
  }) : super(key: key);

  @override
  _EnterDigitState createState() => _EnterDigitState();
}

class _EnterDigitState extends State<EnterDigit> {
  
  TextFieldBloc? _pinValidateBloc;
  @override
  void initState() {
    this._pinValidateBloc = TextFieldBloc();
    super.initState();
  }
  @override
  void deactivate() {
    _pinValidateBloc!.close();
    super.deactivate();
  }


  final _debouncer = Debouncer(milliseconds: 1000);
  
  // true for change text color
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return BlocListener(
      bloc: _pinValidateBloc,
      listener: (preState,TextFieldState state) async{
        if(state.textFieldError == TextFieldError.Validate){
          await loading();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashBoardPage()));
        }else{
          var _errorMessage='Verification failed. Please double check your code.';
          final snackBar = SnackBar(
            content: Text('$_errorMessage'),
            backgroundColor: Colors.redAccent,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
    },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Wellcome Text
                TopBackground(),
                Padding(
                  padding : const EdgeInsets.symmetric(horizontal: 35),
                  child   : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Body text
                      Padding(
                        padding : const EdgeInsets.only(top: 30, bottom: 10),
                        child   : Text('Enter 6-digit code',
                            style: TextStyle(fontSize: 30, color: Colors.black)),
                      ),
                      Padding(
                        padding : const EdgeInsets.only(bottom: 30),
                        child   : Text('Your code was sent to uxer@cotafer.com'),
                      ),
            
                      // pin code Text Feild
                      PinCodeTextField(
                        animationType: AnimationType.none,
                        keyboardType : TextInputType.number,
                        appContext   : context,
                        length       : 6,
                        onChanged    : (value) {
                          if(value.length == 6)
                          {
                            var respone = SubmitNewPasswordService.submitNewPassword();
                            if(respone != 'error')
                            _debouncer.run(() {
                              _pinValidateBloc!.add(PinCheckEvent(field: value));
                            });
                          }
                        },
                        pinTheme     : PinTheme(
                          activeColor  : Colors.indigo,
                          selectedColor: Colors.indigo,
                          inactiveColor: Colors.black45,
                        ),
                        enableActiveFill: false,
                      ),
            
                      //button resend code
                      Padding(
                        padding :  const EdgeInsets.symmetric(vertical: 30),
                        child   : CustomButton(
                            btText    : 'Resend code',
                            btWidth   : 110,
                            btTextSize: 15,
                            onPressed : () {
                              print('resended code');
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loading() async {
    ShowLoadingDialog(context).showLoaderDialog();
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.pop(context);
  }
}
