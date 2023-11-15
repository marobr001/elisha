import 'package:elisha/src/repositories/bible_repository.dart';
import 'package:test/test.dart';

void main() {
  group("Bible Repository", () {
    test('bookId() returns correct ID', () {
      final bibleRepository = BibleRepository();

      expect(bibleRepository.getBookId("Genesis 4"), 1);
      expect(bibleRepository.getBookId("Joel 1"), 29);
      expect(bibleRepository.getBookId("Matthew 12"), 40);
      expect(bibleRepository.getBookId("Revelation 3"), 66);
      expect(bibleRepository.getBookId("3 Matthew 4"), 0);
    });

    test('formatChapterTitle() returns correct title', () {
      final bibleRepository = BibleRepository();

      expect(bibleRepository.formatChapterTitle("Genesis 4"), "Genesis");
      expect(bibleRepository.formatChapterTitle("Joel 1"), "Joel");
      expect(bibleRepository.formatChapterTitle("Matthew 12"), "Matthew");
      expect(bibleRepository.formatChapterTitle("Revelation 3"), "Revelation");
      expect(bibleRepository.formatChapterTitle("1 John 4"), "1 John");
    });
  });
}