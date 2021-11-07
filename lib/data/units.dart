class Units {
  String getTempUnit(int unitId) {
    switch (unitId) {
      case 1:
        return ' K';
      case 2:
        return ' °F';
      default:
        return ' °C';
    }
  }

  String getWindSpeedUnit() {
    return " m/s";
  }

  String getHumidityUnit() {
    return _getPercentage();
  }

  String _getPercentage() {
    return '%';
  }
}
