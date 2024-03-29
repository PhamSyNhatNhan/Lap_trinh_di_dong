class DishImage{
  String _dishImage;
  String _dishImageStatus;

  DishImage(this._dishImage, this._dishImageStatus);

  String get dishImageStatus => _dishImageStatus;

  set dishImageStatus(String value) {
    _dishImageStatus = value;
  }

  String get dishImage => _dishImage;

  set dishImage(String value) {
    _dishImage = value;
  }
}
