class DishCategory{
  String _idCategory;
  String _nameCategory;
  String _dishNumber;
  String _cateImage;


  DishCategory(
      this._idCategory, this._nameCategory, this._dishNumber, this._cateImage);

  String get dishNumber => _dishNumber;

  set dishNumber(String value) {
    _dishNumber = value;
  }

  String get nameCategory => _nameCategory;

  set nameCategory(String value) {
    _nameCategory = value;
  }

  String get idCategory => _idCategory;

  set idCategory(String value) {
    _idCategory = value;
  }

  String get cateImage => _cateImage;

  set cateImage(String value) {
    _cateImage = value;
  }
}