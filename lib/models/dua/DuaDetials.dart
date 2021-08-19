import 'Dua.dart';

class DuaDetails extends Dua {
  String? translation;
  String? transliteration;
  String reference;
  String notes;

  DuaDetails(
      {required int id,
      required String title,
      required String arabic,
      required bool isFavourite,
      required this.translation,
      required this.transliteration,
      required this.reference,
      required this.notes})
      : super(id, title, arabic, isFavourite);

  @override
  String toString() {
    return 'DuaDetails{translation: $translation, transliteration: $transliteration, reference: $reference, notes: $notes}';
  }
}
