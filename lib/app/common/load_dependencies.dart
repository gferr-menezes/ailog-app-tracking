import '../database/database_sqlite.dart';
import 'geolocation.dart';

class LoadDependencies {
  LoadDependencies._();

  static execute() {
    LoadDependencies._()._sqlite();
    LoadDependencies._()._geolocationPermission();
  }

  _sqlite() {
    DatabaseSQLite().openConnection();
  }

  _geolocationPermission() {
    Geolocation.requestPermission();
  }
}
