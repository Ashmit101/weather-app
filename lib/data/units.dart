class Units {
  String getTempUnit() {
    return ' °C';
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
