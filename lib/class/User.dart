class User {
  String _userId;
  String _userEmail;
  String _userName;
  String _userImage;
  String _userPhoneNumber;
  String _userAddres;

  User(this._userId, this._userName, this._userEmail,
      this._userImage, this._userPhoneNumber, this._userAddres);

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get userAddres => _userAddres;

  set userAddres(String value) {
    _userAddres = value;
  }

  String get userPhoneNumber => _userPhoneNumber;

  set userPhoneNumber(String value) {
    _userPhoneNumber = value;
  }

  String get userImage => _userImage;

  set userImage(String value) {
    _userImage = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get userEmail => _userEmail;

  set userEmail(String value) {
    _userEmail = value;
  }

  void setData(userId, userEmail, userName, userImage, userPhoneNumber, userAddres){
    _userId = userId;
    _userEmail = userEmail;
    _userName = userName;
    _userImage = userImage;
    _userPhoneNumber = userPhoneNumber;
    _userAddres = userAddres;
  }


}
