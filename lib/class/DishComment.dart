class DishComment{
  String _dishCommentId;
  String _userId;
  String _userName;
  String _userImage;
  String _dishComment;
  String _dishCommentDay;
  String _dishCommentUp;
  String _dishCommentDown;
  String _ownerStatus;


  DishComment(
      this._dishCommentId,
      this._userId,
      this._userName,
      this._userImage,
      this._dishComment,
      this._dishCommentDay,
      this._dishCommentUp,
      this._dishCommentDown,
      this._ownerStatus);

  String get dishCommentDown => _dishCommentDown;

  set dishCommentDown(String value) {
    _dishCommentDown = value;
  }

  String get dishCommentUp => _dishCommentUp;

  set dishCommentUp(String value) {
    _dishCommentUp = value;
  }

  String get dishCommentDay => _dishCommentDay;

  set dishCommentDay(String value) {
    _dishCommentDay = value;
  }

  String get dishComment => _dishComment;

  set dishComment(String value) {
    _dishComment = value;
  }

  String get userImage => _userImage;

  set userImage(String value) {
    _userImage = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get dishCommentId => _dishCommentId;

  set dishCommentId(String value) {
    _dishCommentId = value;
  }

  String get ownerStatus => _ownerStatus;

  set ownerStatus(String value) {
    _ownerStatus = value;
  }
}