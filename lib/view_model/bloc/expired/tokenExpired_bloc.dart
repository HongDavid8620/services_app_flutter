import 'dart:async';
import 'package:cotafer_server_status/view_model/bloc/expired/tokenExpired_event.dart';
import 'package:cotafer_server_status/view_model/bloc/expired/tokenExpired_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpiredTokenBloc extends Bloc<ExpiredEvent, TokenState> {
  ExpiredTokenBloc() : super(TokenState(TokenStatus.TokenActived));

  late StreamSubscription _subscription;

  @override
  Stream<TokenState> mapEventToState(ExpiredEvent event) async* {
    if (event is ListenExpiredEvent) {
      _subscription = StreamExpired().checkExpired(10).listen((status) {
        // print('isExpired : $status');
        add(TokenStatusEvent(!status ? TokenState(TokenStatus.TokenActived) : TokenState(TokenStatus.TokenExpired)));
      });
    }
    if (event is TokenStatusEvent) yield event.tokenState;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

class StreamExpired {
  Stream<bool> checkExpired(int expiredDate) async* {
    final now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? time = prefs.getInt('expired_date');
    if (time != null) {
      var datetime = DateTime.fromMillisecondsSinceEpoch(time);
      while (true) {
        final bool isExpired = datetime.isBefore(now);
        final duration = datetime.difference(now).inMinutes;
        yield isExpired;

        await Future.delayed(Duration(minutes: duration > 1 ? 1 : duration));
        if (isExpired) break;
      }
    } else
      yield true;
  }
}
