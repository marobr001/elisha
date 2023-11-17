/*
Elisha iOS & Android App
Copyright (C) 2022 Carlton Aikins

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:elisha/src/config/exceptions.dart';
import 'package:elisha/src/models/book.dart';
import 'package:elisha/src/models/chapter.dart';
import 'package:elisha/src/models/verse.dart';
import 'package:elisha/src/providers/bible_chapters_provider.dart';
import 'package:elisha/src/providers/bible_translations_provider.dart';
import 'package:elisha/src/repositories/bible_repository.dart';

class BibleService {
  late Future<Map<String, dynamic>> _jsonData;
  late List<dynamic> _bibleText;

  BibleService() {
    _jsonData = _loadJsonData();
  }

  Future<Map<String, dynamic>> _loadJsonData() async {
    final text = await rootBundle.loadString('backend/$translationAbb.json');
    final map = json.decode(text) as Map<String, dynamic>;
    _bibleText = map['resultset']['row'] as List<dynamic>;
    return map;
  }

  Future<List<Book>> getBooks(String? bookID) async {
    try {
      List<dynamic> bookText;
      if (!['', null].contains(bookID)) {
        bookText = _bibleText.where((element) => element['field']![1].toString() == bookID).toList();
      } else {
        bookText = _bibleText;
      }

      final books = _extractBooks(bookText);
      return books;
    } on DioError catch (e) {
      throw Exceptions.fromDioError(e);
    }
  }

  Future<Chapter> getChapter(String bookID, String chapterID, String translationID) async {
    try {
      final books = await getBooks(bookID);

      final chapterText = _bibleText
          .where((element) => element['field']![1].toString() == bookID && element['field']![2].toString() == chapterID)
          .toList();

      final chapter = _extractChapter(chapterText, books[0]);
      return chapter;
    } on DioError catch (e) {
      throw Exceptions.fromDioError(e);
    }
  }

  Future<List<Chapter>> getChapters(String? bookID) async {
    try {
      final chaptersText = _bibleText.where((element) => element['field']![1].toString() == bookID).toList();
      final chapters = _extractChapters(chaptersText);
      return chapters;
    } on DioError catch (e) {
      throw Exceptions.fromDioError(e);
    }
  }

  Future<List<Verse>> getVerses(String bookID, String chapterID, String? verseID) async {
    try {
      if (!['', null].contains(verseID)) {
        final vId = _composeVerseId(bookID, chapterID, verseID!);
        final verseElement = _bibleText.firstWhere((element) => element['field']![0].toString() == vId)['field'] as List<dynamic>;
        final books = await getBooks(bookID);
        final verses = [_extractVerse(verseElement, books[0])];
        return verses;
      } else {
        final chapterText = _bibleText.where((element) => element['field']![1].toString() == bookID && element['field']![2].toString() == chapterID);
        final books = await getBooks(bookID);
        final verses = _extractVerses(chapterText, books[0]);
        return verses;
      }
    } on DioError catch (e) {
      throw Exceptions.fromDioError(e);
    }
  }

  List<Book> _extractBooks(List<dynamic> bookText) {
    final chapters = {
      for (var item in bookText) ChapterId(id: item['field']![2]),
    }.toList();

    final book = Book(
      id: bookText[0]['field']![1],
      name: BibleRepository().mapOfBibleBooks[int.parse(bookText[0]['field']![1].toString())],
      testament: bookText[0]['field']![1] >= 40 ? 'New' : 'Old',
      chapters: chapters,
    );

    return [book];
  }

  Chapter _extractChapter(List<dynamic> chapterText, Book book) {
    final verses = {
      for (var item in chapterText) Verse.fromList(item['field']).copyWith(book: book),
    }.toList();

    return Chapter(
      id: int.parse(chapterText[0]['field']![2].toString()),
      number: chapterText[0]['field']![2].toString(),
      translation: translationID,
      verses: verses,
      bookmarked: false,
    );
  }

  List<Chapter> _extractChapters(List<dynamic> chaptersText) {
    final verses = {
      for (var item in chaptersText) Verse.fromList(item['field']),
    }.toList();

    return [
      for (var item in chaptersText)
        Chapter(
          id: int.parse(item['field']![2].toString()),
          number: item['field']![2].toString(),
          translation: translationID,
          verses: verses.where((element) => element.chapterId == item['field']![2]).toList(),
          bookmarked: false,
        )
    ];
  }

  Verse _extractVerse(List<dynamic> verseElement, Book book) {
    return Verse.fromList(verseElement).copyWith(book: book);
  }

  List<Verse> _extractVerses(Iterable<dynamic> chapterText, Book book) {
    final verses = {
      for (var item in chapterText) Verse.fromList(item['field']).copyWith(book: book),
    }.toList();

    return verses;
  }

  String _composeVerseId(String bookID, String chapterID, String verseID) {
    return bookID +
        chapterID.padLeft(3, '0') +
        verseID.padLeft(3, '0');
  }
}
