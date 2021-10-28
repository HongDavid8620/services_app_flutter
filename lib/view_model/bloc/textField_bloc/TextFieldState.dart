enum TextFieldError {Waiting, Nothing, Empty, Invalid, InvalidEmail, InvalidPasswd,
  InvalidOldPasswd, Validate, Changed, ApiRespone, Error}

class TextFieldState {
  final TextFieldError textFieldError;
  TextFieldState({this.textFieldError : TextFieldError.Nothing});
}
  