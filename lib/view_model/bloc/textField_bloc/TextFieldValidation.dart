class TextFieldValidation {
  bool isFieldEmpty(field) => field?.isEmpty ?? true;

  bool nameValidate(field) {
    if (field == null) {
      return false;
    }
    return RegExp(r"^[a-zA-Z]+[a-zA-Z]?[a-zA-Z]*$").hasMatch(field);
  }

  bool numberValidate(field) {
    if (field == null) {
      return false;
    }
    return RegExp(r"^[+]+([\d\ ]{13,18})$").hasMatch(field);  
  }

  bool pinValidate(field) {
    if (field == null) {
      return false;
    }
    return RegExp(r"^([\d]{6,6})$").hasMatch(field);
  }

  bool emailValidate(field) {
    if (field == null) {
      return false;
    }
    if (field.length > 50){
      return false;
    }

    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[a-z]{2,4}$').hasMatch(field);
  }

  bool validateWithSpecialChar(field) {
    if (field == null) {
      return false;
    }
    if (field.length > 30){
      return false;
    }
    return RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&-_]{8,}$')
        .hasMatch(field);
  }
}
