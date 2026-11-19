/// 成功/失敗を表す汎用の結果型。
///
/// 例外を throw する代わりに Result を返すことで、
/// 呼び出し側に成功・失敗の両方を扱うことを強制する。
sealed class Result<T> {
  const Result();

  /// 成功値。失敗時は null。
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Failure<T>() => null,
      };
}

/// 成功。
class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

/// 失敗。
class Failure<T> extends Result<T> {
  const Failure(this.error, [this.stackTrace]);
  final Object error;
  final StackTrace? stackTrace;
}
