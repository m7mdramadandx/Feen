class MenuList {
  var _name;
  var _isSelected;

  String get name => _name;

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  set name(String value) {
    _name = value;
  }

  MenuList(this._name, this._isSelected);
}
