class CompareUtil{
  static String? compareStringValue(String? currentValue, String? newValue) {
    return currentValue == newValue ? null : newValue;
  }

  static int? compareIntValue(int? currentValue, int? newValue) {
    return currentValue == newValue ? null : newValue;
  }
}