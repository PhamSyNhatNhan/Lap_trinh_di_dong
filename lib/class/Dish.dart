import 'DishImage.dart';

class Dish {
  String _dishId;
  String _dishName;
  String _dishDecription;
  String _dishDay;
  String _dishTimeCook;
  String _dishTimePrepare;
  String _dishUp;
  String _dishDown;
  List<DishImage> _dishImages;


  Dish(
      this._dishId,
      this._dishName,
      this._dishDecription,
      this._dishDay,
      this._dishTimeCook,
      this._dishTimePrepare,
      this._dishUp,
      this._dishDown,
      this._dishImages);

  String get dishDown => _dishDown;

  set dishDown(String value) {
    _dishDown = value;
  }

  String get dishUp => _dishUp;

  set dishUp(String value) {
    _dishUp = value;
  }

  String get dishTimePrepare => _dishTimePrepare;

  set dishTimePrepare(String value) {
    _dishTimePrepare = value;
  }

  String get dishTimeCook => _dishTimeCook;

  set dishTimeCook(String value) {
    _dishTimeCook = value;
  }

  String get dishDay => _dishDay;

  set dishDay(String value) {
    _dishDay = value;
  }

  String get dishDecription => _dishDecription;

  set dishDecription(String value) {
    _dishDecription = value;
  }

  String get dishName => _dishName;

  set dishName(String value) {
    _dishName = value;
  }

  String get dishId => _dishId;

  set dishId(String value) {
    _dishId = value;
  }

  List<DishImage> get dishImages => _dishImages;

  set dishImages(List<DishImage> value) {
    _dishImages = value;
  }
}
