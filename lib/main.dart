import 'package:services_flutter/view/screen/dashboard/dashboard.dart';
import 'package:services_flutter/view/screen/signIn/signWrapper.dart';
import 'package:services_flutter/view_model/bloc/expired/tokenExpired_bloc.dart';
import 'package:services_flutter/view_model/bloc/expired/tokenExpired_event.dart';
import 'package:services_flutter/view_model/bloc/network/network_bloc.dart';
import 'package:services_flutter/view_model/bloc/network/network_event.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/textField_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
          providers: [
              BlocProvider<TextFieldBloc>(
                create: (BuildContext context) => TextFieldBloc(),
              ),
              BlocProvider<NetworkBloc>(
                create: (context) => NetworkBloc()..add(ListenConnection()),
              ),
              BlocProvider<ExpiredTokenBloc>(
                create: (context) => ExpiredTokenBloc()..add(ListenExpiredEvent()),
              ),
            ],
            child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.white,
            ),
            home: SignInWrapper()));
    
  }
}

