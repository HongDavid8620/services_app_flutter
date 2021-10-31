import 'package:services_flutter/view/screen/forgotPassword/enterEmail.dart';
import 'package:services_flutter/view/widget/customButton.dart';
import 'package:services_flutter/view/widget/firstPageTopBackground.dart';
import 'package:services_flutter/view/widget/inputField/inputTextField.dart';
import 'package:services_flutter/view/widget/loadingPage.dart';
import 'package:services_flutter/view/widget/rememberMeCheckBox.dart';
import 'package:services_flutter/view/widget/textErrorMessage.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldEvent.dart';
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
  bool _checkBox  = false;
  bool textColor  = false; // true for change text color
  bool _checkEmailFocus = false;
  bool _checkPasswdFocus = false;
  bool _hasFocus = false;
  bool _keyboard = false;

  // use for focus each field
  FocusNode emailFocus = new FocusNode();
  FocusNode passwdFocus = new FocusNode();
  
  String? _passwd       ;  //if _passwd && _emailaddress is empty , process will work
  String? _emailaddress ;
  String? _errorMessage ;
  var _fromKey = GlobalKey<FormState>();
  //for animation

  TextFieldBloc? _emailValidateBloc;
  TextFieldBloc? _passwordValidateBloc;
  TextFieldBloc? _signInBlocListener;
  TextFieldBloc? _signInBloc;

  @override
  void initState() {
    this._emailValidateBloc = TextFieldBloc();
    this._passwordValidateBloc = TextFieldBloc();
    this._signInBlocListener = TextFieldBloc();    
    this._signInBloc = TextFieldBloc();    
    _getrememberInfo();

    super.initState();
  }

  @override
  void dispose() {
    _emailValidateBloc!.close();
    _passwordValidateBloc!.close();
    _signInBlocListener!.close();
    _signInBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var signInFunction = SignInFunction(checkBox: _checkBox, fromKey: _fromKey,passwordValidateBloc:  _passwordValidateBloc,emailaddress:  _emailaddress, passwd: _passwd, emailValidateBloc: _emailValidateBloc);
  
    return (_emailaddress == null)
        ? LoadingPage()
        : BlocBuilder<TextFieldBloc, TextFieldState>(
            bloc: _signInBloc,
            builder: (context, signInState) {
              return BlocBuilder<TextFieldBloc, TextFieldState>(
                  bloc: _emailValidateBloc,
                  builder: (context, emailState) {
                    //blocBuilder for password TextField
                    return BlocBuilder<TextFieldBloc, TextFieldState>(
                        bloc: _passwordValidateBloc,
                      builder : (context, passwdState) {
                        _errorMessage = signInFunction.validateErrorMessage(emailState, passwdState, signInState);
                        //bottom keyboard size
                        var size = MediaQuery.of(context).viewInsets.bottom;
          
                        // when move down keyboard with arror keyboard
                        if(size != 0){
                          _keyboard = true;
                        }
                        if (size == 0 && _keyboard) {
                          _keyboard = false;
                          if (_checkEmailFocus) {
                            signInFunction.emailChangeEvent(_emailaddress);
                          }
                          if (_checkPasswdFocus) {
                            signInFunction.passwdChangeEvent(_passwd);
                          }
                        }
          
                        return BlocListener(bloc: _signInBlocListener,
                          listener: (prestate,state){
                            signInFunction.pushNavigator(emailState, passwdState, context , signInBloc: _signInBloc);
                          },
                            child: GestureDetector(
                              onTap: () {
                              //if keyboard is show, when on tap will unfocus textfield and check if input email correctly
                              if (size != 0) {
                                FocusScope.of(context).requestFocus(new FocusNode());
                                _fromKey.currentState!.save();
                                _hasFocus = true;
                                if(_checkEmailFocus){
                                  signInFunction.emailChangeEvent(_emailaddress);
                                }
                                if(_checkPasswdFocus){                              
                                  signInFunction.passwdChangeEvent(_passwd);
                                }                            
                              } 
                            },
                              child: Scaffold(
                            body: SingleChildScrollView(
        
                              child: TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: Duration(milliseconds: 600),
                                builder: (context, double val, child) {
                                  return Opacity(opacity: val, child: child);
                                },
        
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: Form(
                                    key: _fromKey,
                                        child : Column(
                                          mainAxisAlignment : MainAxisAlignment.spaceBetween,
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
                                                        fontSize  : 35,
                                                        fontWeight: FontWeight.bold,
                                                        color     : Colors.indigo[800])),
                                              ),
                                            ),
                                                
                                            //Error Text Message
                                            TextErrorMessage(newMessage: '$_errorMessage'),
                                            
                                            //Text input Column
                                            Padding(
                                              padding : const EdgeInsets.symmetric(horizontal: 35),
                                              child   : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Focus(
                                                    onFocusChange: (hasFocus){
                                                      if (hasFocus) {
                                                        setState(() {
                                                          _checkEmailFocus = true;
                                                          _hasFocus = true;
                                                        });
                                                        if (_checkPasswdFocus) {
                                                          signInFunction.passwdChangeEvent(_passwd);
                                                        }
                                                      }
                                                    },
                                                    child: InputTextField(  
                                                      maxLength: 50,
                                                      focusNode: emailFocus,
                                                      validate  : validateEmail(emailState),
                                                      value     : _emailaddress ?? '',
                                                      onChanged : (value) {
                                                        setState(() {
                                                          _emailaddress = '$value';
                                                        });
                                                      },
                                                      text    : 'E-mail',
                                                      onSaved : (value) {
                                                        setState(() {
                                                          _emailaddress = '$value';
                                                        });
                                                      },
                                                      textColor: signInFunction.checkValidation(emailState)
                                                          ? Colors.black
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Focus(
                                                    onFocusChange: (hasFocus){
                                                      if (hasFocus) {
                                                        setState(() {
                                                          _checkPasswdFocus = true;
                                                          _hasFocus = true;
                                                        });
                                                        if (_checkEmailFocus) {
                                                          signInFunction.emailChangeEvent(_emailaddress);
                                                        }
                                                      }
                                                    },
                                                    child: InputTextField(
                                                      maxLength: 30,
                                                      focusNode: passwdFocus,
                                                      validate: validatePasswd(passwdState, emailState),
                                                      value   : _passwd ?? '',
                                                      icon    : Icon(
                                                        Icons.visibility,
                                                        color: Colors.black,
                                                      ),
                                                      text    : 'Password',
                                                      password: true,
                                                      onSaved : (value) {
                                                        setState(() {
                                                          _passwd = '$value';
                                                        });
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _passwd = '$value';
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                                
                                            //Remember me and forgot pw text
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding : const EdgeInsets.only(left: 25),
                                                  child   : RemeberMeCheckBox(
                                                    checkBox: _checkBox,
                                                    onTap   : () {
                                                      setState(() {
                                                        _checkBox = !_checkBox;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding : const EdgeInsets.only(right: 35),
                                                  child   : InkWell(
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
                                                    btText    : 'SIGN IN',
                                                    btHieght  : 50,
                                                    onPressed : () async {
                                                      await signInFunction.emailChangeEvent(_emailaddress);
                                          
                                                      if(_checkEmailFocus||_checkPasswdFocus)
                                                      await signInFunction.passwdChangeEvent(_passwd);                                              
                                                      
                                                      await Future.delayed(Duration(milliseconds: 100));
                                                      _signInBlocListener!.add(SubmitEvent(textFieldError: TextFieldError.Validate));
                                                      setState(() {
                                                        _hasFocus = false;
                                                      });
                                                      //Loading
                                                    })), // TextField
                                            //space
                                            Expanded(child: Container()),
                                            //Version text
                                            Center(
                                              child: Text('Version 1.0.0',
                                                  style: TextStyle(
                                                      fontSize  : 16,
                                                      fontWeight: FontWeight.w400,
                                                      color     : Colors.indigo[800])),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                      });
                  });
            });
  }

//get email and password when start the Widget
  _getrememberInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 300));
    if (prefs.getString('username') == null || prefs.getString('username') == '') {
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

  validateEmail(emailState) {
    if (!SignInFunction().checkValidation(emailState)) {
        if (!_hasFocus) {
        emailFocus.requestFocus();
      }
      return true;
      } else
      return false;
  }

  validatePasswd(passwdState,emailState){
    if(!SignInFunction().checkValidation(passwdState) && SignInFunction().checkValidation(emailState)){
      if (!_hasFocus) {
        passwdFocus.requestFocus();
      }
      return true;
    }else
      return false;
  }

}
