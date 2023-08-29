class Regex {
  static const String email =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  static const String password = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
}

class JsonParams {
  static const String listsCollection = 'lists';

  static const String listId = 'id';
  static const String listName = 'name';
  static const String completedEntries = 'completedEntries';
  static const String listEntries = 'listEntries';

  static const String usersCollection = 'users';

  static const String ownLists = 'ownLists';
  static const String invitedLists = 'invitedLists';
  static const String isPaidAccount = 'isPaidAccount';
}
