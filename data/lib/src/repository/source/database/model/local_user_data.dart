import 'package:drift/drift.dart';

class LocalUsers extends Table {
  TextColumn get userId => text()()..customConstraint('PRIMARY KEY');
  TextColumn get name => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get avatar => text().nullable()();
  TextColumn get currencyPreference => text().nullable()();
  TextColumn get languagePreference => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}
