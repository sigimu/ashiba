import '../../framework/error/result.dart';
import '../../model/home_summary.dart';

/// 学習ログ・タップ履歴・書類から集計した学習状況の取得。
abstract interface class LearningRepository {
  /// ホームに出すまとめを取得する。
  Future<Result<HomeSummary>> fetchHomeSummary({required String userId});
}
