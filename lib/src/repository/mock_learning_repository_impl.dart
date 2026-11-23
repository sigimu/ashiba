import '../framework/error/result.dart';
import '../model/document_summary.dart';
import '../model/home_summary.dart';
import '../model/tapped_word.dart';
import 'interface/learning_repository.dart';

/// サーバー実装までの仮データ。
class MockLearningRepositoryImpl implements LearningRepository {
  const MockLearningRepositoryImpl({
    this.delay = const Duration(milliseconds: 400),
  });

  final Duration delay;

  @override
  Future<Result<HomeSummary>> fetchHomeSummary({required String userId}) async {
    await Future<void>.delayed(delay);
    return Success(
      HomeSummary(
        unansweredCount: 8,
        accuracyRate: 0.72,
        streakDays: 5,
        newDocuments: [
          DocumentSummary(
            id: 'd003',
            title: 'フォークリフト作業の安全手順',
            category: '安全',
            publishedAt: DateTime(2026, 11, 20),
          ),
          DocumentSummary(
            id: 'd002',
            title: '朝礼で使うことば',
            category: '基本',
            publishedAt: DateTime(2026, 11, 18),
          ),
        ],
        topTappedWords: const [
          TappedWord(word: '確認', reading: 'かくにん', tapCount: 14),
          TappedWord(word: '報告', reading: 'ほうこく', tapCount: 11),
          TappedWord(word: '至急', reading: 'しきゅう', tapCount: 7),
        ],
      ),
    );
  }
}
