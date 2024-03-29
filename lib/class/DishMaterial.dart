class DishMaterial{
  String _dishMaterialName;
  String _dishMaterialMass;
  String _dishMaterialCalories;

  DishMaterial(this._dishMaterialName, this._dishMaterialMass,
      this._dishMaterialCalories);

  String get dishMaterialCalories => _dishMaterialCalories;

  set dishMaterialCalories(String value) {
    _dishMaterialCalories = value;
  }

  String get dishMaterialMass => _dishMaterialMass;

  set dishMaterialMass(String value) {
    _dishMaterialMass = value;
  }

  String get dishMaterialName => _dishMaterialName;

  set dishMaterialName(String value) {
    _dishMaterialName = value;
  }
}