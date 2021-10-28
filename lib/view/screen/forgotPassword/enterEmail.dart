import 'package:cotafer_server_status/view/screen/forgotPassword/enterDigit.dart';
import 'package:cotafer_server_status/view/widget/firstPageTopBackground.dart';
import 'package:cotafer_server_status/view/widget/inputField/inputTextField.dart';
import 'package:cotafer_server_status/view/widget/customButton.dart';
import 'package:cotafer_server_status/view/widget/showLoadingDialog.dart';
import 'package:cotafer_server_status/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:cotafer_server_status/view_model/bloc/textField_bloc/textField_bloc.dart';
import 'package:cotafer_server_status/view_model/service/password/requestSendCodeService.dart';
import 'package:cotafer_server_status/view_model/validate/validateFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterEmail extends StatefulWidget {
  const EnterEmail({
    Key? key,
  }) : super(key: key);

  @override
  _EnterEmailState createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  // true for change text color
  TextFieldBloc? _emailValidateBloc;
  String? _emailaddress = '';
  String? _errorMessage = '';

  @override
  void initState() {
    this._emailValidateBloc = TextFieldBloc();
    super.initState();
  }

  @override
  void dispose() {
    _emailValidateBloc!.close();
    super.dispose();
  }

  var _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size    = MediaQuery.of(context).viewInsets.bottom;  //keyboard's size
    var height  = MediaQuery.of(context).size.height;

    return BlocProvider<TextFieldBloc>(
      create: (BuildContext context) => TextFieldBloc(),
      child : GestureDetector(
        onTap: () {
          if (size != 0) {
            FocusScope.of(context).requestFocus(new FocusNode());
            _fromKey.currentState!.save();
            SignInFunction(emailValidateBloc: _emailValidateBloc)
                .emailChangeEvent(_emailaddress);
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: height,
              child : BlocBuilder<TextFieldBloc, TextFieldState>(
                  bloc    : _emailValidateBloc,
                  builder : (context, state) {
                    _errorMessage = SignInFunction().emailErrorMessage(state);
                    // _errorMessage = 'respone';
                    if (_errorMessage == 'respone')
                      _errorMessage = 'We does not have this e-mail address in our record';
                    if (state.textFieldError == TextFieldError.Nothing)
                      _errorMessage = 'Please input the e-mail address';
                    final snackBar = SnackBar(
                      content: Text('$_errorMessage'),
                      backgroundColor: Colors.redAccent,
                    );

                    return Form(
                      key  : _fromKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Wellcome Text
                          TopBackground(),
                          Padding(
                            padding : const EdgeInsets.symmetric(horizontal: 35),
                            child   : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding : const EdgeInsets.only(top: 30, bottom: 10),
                                  child   : Text('Enter email address',
                                      style:
                                          TextStyle(fontSize: 30, color: Colors.black)),
                                ),
                                Padding(
                                  padding : const EdgeInsets.only(bottom: 30),
                                  child   : Text(
                                      "We'll email you a code to reset your password."),
                                ),

                                InputTextField(
                                  validate: false,
                                  text    : 'E-mail',
                                  onSaved : (value) {
                                    setState(() {
                                      _emailaddress = value;
                                    });
                                  },
                                ),

                                //Send Button
                                Padding(
                                  padding : const EdgeInsets.symmetric(vertical: 30),
                                  child   : CustomButton(
                                      btText   : 'Send code',
                                      btHieght : 50,
                                      onPressed: () async {
                                        if (_errorMessage == '') {
                                          await loading();
                                          var respone = await SendCodeService.sendRequestCode();  //request send code to api
                                          if(respone != 'error' )
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EnterDigit()));
                                        } else {
                                          await loading();
                                          if (_errorMessage == 'respone') {
                                            await loading();
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      }),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  loading() async {
    ShowLoadingDialog(context).showLoaderDialog();
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.pop(context);
  }
}
