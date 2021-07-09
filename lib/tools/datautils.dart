lengthCheck(String value) {
  if (value.length == 1) {
    value = '0' + value;
  }
  return value;
}

int timeCheck(int hour) {
  if (hour >= 0 && hour <= 8) {
    return 0;
  } else if (hour >= 9 && hour <= 13) {
    return 1;
  } else if (hour >= 14 && hour <= 18) {
    return 2;
  } else if (hour >= 19 && hour <= 0) {
    return 3;
  }
  return null;
}
