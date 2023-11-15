import 'package:test/test.dart';
import 'package:elisha/src/models/book.dart';
import 'package:elisha/src/models/chapter.dart';

void main() {
  group('Book', () {
    test('copyWith', () {
      final book = Book(
        id: 1,
        name: 'Genesis',
        testament: 'Old Testament',
        chapters: [ChapterId(id: 1)],
      );

      final copiedBook = book.copyWith(name: 'Exodus');

      expect(copiedBook, isNot(same(book))); // Ensure a new object is created
      expect(copiedBook.name, 'Exodus');
      expect(copiedBook.id, 1);
      expect(copiedBook.testament, 'Old Testament');
      expect(copiedBook.chapters, [ChapterId(id: 1)]);
    });

    test('toMap', () {
      final book = Book(
        id: 1,
        name: 'Genesis',
        testament: 'Old Testament',
        chapters: [
          ChapterId(id: 1)
        ],
      );

      final map = book.toMap();

      expect(map, {
        'id': 1,
        'name': 'Genesis',
        'testament': 'Old Testament',
        'chapters': [
          {'id': 1}
        ],
      });
    });

    test('fromMap', () {
      final map = {
        'id': 1,
        'name': 'Genesis',
        'testament': 'Old Testament',
        'chapters': [
          {'id': 1}
        ],
      };

      final book = Book.fromMap(map);

      expect(book.id, 1);
      expect(book.name, 'Genesis');
      expect(book.testament, 'Old Testament');
      expect(book.chapters, []);
    });

    test('toJson', () {
      final book = Book(
        id: 1,
        name: 'Genesis',
        testament: 'Old Testament',
        chapters: [ChapterId(id: 1)],
      );

      final json = book.toJson();

      expect(json, '{"id":1,"name":"Genesis","testament":"Old Testament","chapters":[{"id":1}]}');
    });

    test('fromJson', () {
      const json = '{"id":1,"name":"Genesis","testament":"Old Testament","chapters":[{"id":1,"verses":[]}]}';

      final book = Book.fromJson(json);

      expect(book.id, 1);
      expect(book.name, 'Genesis');
      expect(book.testament, 'Old Testament');
      expect(book.chapters, []);
    });

    // Add more tests for other methods and properties

  });
}
