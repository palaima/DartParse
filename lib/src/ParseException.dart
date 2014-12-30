part of dart_parse;

class ParseException implements Exception {

  static final int OTHER_CAUSE = -1;
  static final int INTERNAL_SERVER_ERROR = 1;
  static final int CONNECTION_FAILED = 100;
  static final int OBJECT_NOT_FOUND = 101;
  static final int INVALID_QUERY = 102;
  static final int INVALID_CLASS_NAME = 103;
  static final int MISSING_OBJECT_ID = 104;
  static final int INVALID_KEY_NAME = 105;
  static final int INVALID_POINTER = 106;
  static final int INVALID_JSON = 107;
  static final int COMMAND_UNAVAILABLE = 108;
  static final int NOT_INITIALIZED = 109;
  static final int INCORRECT_TYPE = 111;
  static final int INVALID_CHANNEL_NAME = 112;
  static final int PUSH_MISCONFIGURED = 115;
  static final int OBJECT_TOO_LARGE = 116;
  static final int OPERATION_FORBIDDEN = 119;
  static final int CACHE_MISS = 120;
  static final int INVALID_NESTED_KEY = 121;
  static final int INVALID_FILE_NAME = 122;
  static final int INVALID_ACL = 123;
  static final int TIMEOUT = 124;
  static final int INVALID_EMAIL_ADDRESS = 125;
  static final int DUPLICATE_VALUE = 137;
  static final int INVALID_ROLE_NAME = 139;
  static final int EXCEEDED_QUOTA = 140;
  static final int CLOUD_ERROR = 141;
  static final int USERNAME_MISSING = 200;
  static final int PASSWORD_MISSING = 201;
  static final int USERNAME_TAKEN = 202;
  static final int EMAIL_TAKEN = 203;
  static final int EMAIL_MISSING = 204;
  static final int EMAIL_NOT_FOUND = 205;
  static final int SESSION_MISSING = 206;
  static final int MUST_CREATE_USER_THROUGH_SIGNUP = 207;
  static final int ACCOUNT_ALREADY_LINKED = 208;
  static final int LINKED_ID_MISSING = 250;
  static final int INVALID_LINKED_SESSION = 251;
  static final int UNSUPPORTED_SERVICE = 252;

  int code;
  String message;

  ParseException(this.code, this.message);

  String toString() {
    return "Code: ${code.toString()} Message: ${message}";
  }
}
