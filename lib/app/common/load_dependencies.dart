import '../database/database_sqlite.dart';

class LoadDependencies {
  LoadDependencies._();

  static execute() {
    LoadDependencies._()._sqlite();
  }

  _sqlite() {
    DatabaseSQLite().openConnection();
  }
}
