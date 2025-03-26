class RegexUtil{
  static final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  static final mobileRegex = RegExp(r'^(010-?\d{4}-?\d{4})$');
}