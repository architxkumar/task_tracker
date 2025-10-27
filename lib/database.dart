import 'package:drift/drift.dart';

part 'database.g.dart';

class TodoItems extends Table {
  late final Column<int> id = integer().autoIncrement()();
  late final Column<String> content = text()();
  late final Column<bool> completed = boolean().withDefault(
    const Constant(false),
  )();
}

@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
