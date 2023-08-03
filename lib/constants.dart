class Regex {
  static const String email =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  static const String password = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
}
