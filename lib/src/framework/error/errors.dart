/// アプリ共通の例外基底クラス。
abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// ネットワーク/API通信に関する例外。
class ApiException extends AppException {
  const ApiException(super.message, {this.statusCode});
  final int? statusCode;
}

/// 入力値や状態の検証に関する例外。
class ValidationException extends AppException {
  const ValidationException(super.message);
}
