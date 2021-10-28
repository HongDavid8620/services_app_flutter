enum TokenStatus { CheckExpiredInitial, TokenExpired, TokenActived }

class TokenState {
  final TokenStatus tokenState;
  TokenState(this.tokenState);
}
