import 'package:services_flutter/view/screen/forgotPassword/enterEmail.dart';
import 'package:services_flutter/view/widget/customButton.dart';
import 'package:services_flutter/view/widget/firstPageTopBackground.dart';
import 'package:services_flutter/view/widget/inputField/inputTextField.dart';
import 'package:services_flutter/view/widget/loadingPage.dart';
import 'package:services_flutter/view/widget/rememberMeCheckBox.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/textField_bloc.dart';
import 'package:services_flutter/view_model/validate/validateFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    Key? key,
  }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _checkBox = false;
  bool textColor = false; // true for change text color
  String? _passwd = 'null';
  String? _emailaddress = 'null';
  String? _errorMessage;
  var _fromKey = GlobalKey<FormState>();
  //for animation
  double _opacity = 0;

  TextFieldBloc? _emailValidateBloc;
  TextFieldBloc? _passwordValidateBloc;

  @override
  void initState() {
    this._emailValidateBloc = TextFieldBloc();
    this._passwordValidateBloc = TextFieldBloc();
    _getrememberInfo();
    super.initState();
  }

  @override
  void dispose() {
    _emailValidateBloc!.close();
    _passwordValidateBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hieght = MediaQuery.of(context).size.height;
    var signInFunction = SignInFunction(checkBox: _checkBox, fromKey: _fromKey,passwordValidateBloc:  _passwordValidateBloc,emailaddress:  _emailaddress, passwd: _passwd, emailValidateBloc: _emailValidateBloc);

    return _emailaddress == 'null'
        ? LoadingPage()
        : BlocBuilder<TextFieldBloc, TextFieldState>(
            bloc: _emailValidateBloc,
            builder: (context, emailState) {
              return BlocBuilder<TextFieldBloc, TextFieldState>(
                  bloc: _passwordValidateBloc,
                  builder: (context, passwdState) {
                    // print('${passwdState.textFieldError} ${emailState.textFieldError}');
                    _errorMessage = signInFunction.validateErrorMessage(emailState, passwdState);
                    
                    var size = MediaQuery.of(context).viewInsets.bottom;
                    return GestureDetector(
                      onTap: () {
                        if (size != 0) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _fromKey.currentState!.save();
                          signInFunction.emailChangeEvent(_emailaddress);
                        }
                      },
                      child: Scaffold(
                        body: SingleChildScrollView(
                          child: Container(
                            child: Form(
                              key: _fromKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Wellcome Text
                                  TopBackground(),
                                  //Sign In text
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('SIGN IN',
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo[800])),
                                    ),
                                  ),

                                  //Validate text
                                  AnimatedOpacity(
                                    opacity: _opacity,
                                    duration: Duration(milliseconds: 1000),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 35, bottom: 10),
                                      child: Text(
                                        '$_errorMessage',
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                  ),

                                  //Text input Column
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 35),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InputTextField(
                                          validate: !signInFunction.checkValidation(emailState),
                                          value: _emailaddress ?? '',
                                          onChanged: (value) {
                                            setState(() {
                                              _opacity = 1;
                                            });
                                          },
                                          text: 'E-mail',
                                          onSaved: (value) {
                                            setState(() {
                                              _emailaddress = '$value';
                                            });
                                          },
                                          textColor: signInFunction.checkValidation(emailState)
                                              ? Colors.black
                                              : Colors.red,
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        InputTextField(
                                          validate: !signInFunction.checkValidation(passwdState),
                                          value: _passwd ?? '',
                                          icon: Icon(
                                            Icons.visibility,
                                            color: Colors.black,
                                          ),
                                          text: 'Password',
                                          password: true,
                                          onSaved: (value) {
                                            setState(() {
                                              _passwd = '$value';
                                            });
                                          },
                                          onChanged: (value) {
                                            signInFunction.passwdChangeEvent(value);
                                            setState(() {
                                              if (signInFunction.checkValidation(passwdState))
                                                _opacity = 1;
                                              else
                                                _opacity = 0;
                                            });
                                            // _passwdChangeEvent(value);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  //Remember me and forgot pw text
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 25),
                                        child: RemeberMeCheckBox(
                                          checkBox: _checkBox,
                                          onTap: () {
                                            setState(() {
                                              _checkBox = !_checkBox;
                                            });
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 35),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (container) =>
                                                        EnterEmail()));
                                          },
                                          child: Text(
                                            'Forgot password',
                                            style: TextStyle(color: Colors.indigo[400]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //Sign In button
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 35, vertical: 10),
                                      child: CustomButton(
                                          btText: 'SIGN IN',
                                          btHieght: 50,
                                          onPressed: () async {
                                            setState(() {
                                              _opacity = 1;
                                            });
                                            signInFunction.pushNavigator(emailState, passwdState,context);
                                            //Loading
                                          })), // TextField
                                  //space
                                  SizedBox(
                                    height: hieght * 0.1,
                                  ),
                                  //Version text
                                  Center(
                                    child: Text('Version 1.0.0',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.indigo[800])),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            });
  }

  _getrememberInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 300));
    if (prefs.getString('username') == null || prefs.getString('username') == 'null') {
      setState(() {
        _emailaddress = '';
        _passwd = '';
        _checkBox = false;
      });
    } else {
      setState(() {
        _emailaddress = (prefs.getString('username'));
        _passwd = (prefs.getString('password'));
        _checkBox = true;
      });
    }
  }
}
