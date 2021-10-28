

import 'package:cotafer_server_status/view_model/bloc/expired/tokenExpired_state.dart';

abstract class ExpiredEvent {}

class ListenExpiredEvent extends ExpiredEvent {}

class TokenStatusEvent extends ExpiredEvent {
  TokenState tokenState;
  TokenStatusEvent(this.tokenState);
}
