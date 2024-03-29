class DishStep{
  String _dishStepNumber;
  String _dishStepImage;
  String _dishStepDecription;

  DishStep(this._dishStepNumber, this._dishStepImage, this._dishStepDecription);

  String get dishStepDecription => _dishStepDecription;

  set dishStepDecription(String value) {
    _dishStepDecription = value;
  }

  String get dishStepImage => _dishStepImage;

  set dishStepImage(String value) {
    _dishStepImage = value;
  }

  String get dishStepNumber => _dishStepNumber;

  set dishStepNumber(String value) {
    _dishStepNumber = value;
  }
}