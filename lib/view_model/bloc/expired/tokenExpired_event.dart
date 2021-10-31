

import 'package:services_flutter/view_model/bloc/expired/tokenExpired_state.dart';

abstract class ExpiredEvent {}

class ListenExpiredEvent extends ExpiredEvent {}

class TokenStatusEvent extends ExpiredEvent {
  TokenState tokenState;
  TokenStatusEvent(this.tokenState);
}
