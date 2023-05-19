import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSQLite {
  Future<Database> openConnection() async {
    final databasePath = await getDatabasesPath();
    final databaseFinalPath = join(databasePath, 'ailog.db');

    return await openDatabase(
      databaseFinalPath,
      version: 1,
      onCreate: (Database db, int version) async {
        log('Criando banco de dados versão $version');

        final batch = db.batch();
        batch.execute('''
          CREATE TABLE travels (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code VARCHAR(255),
            travel_id_api VARCHAR(255) NOT NULL,
            estimated_departure DATE_TIME,
            estimated_arrival DATE_TIME,
            vpo_emit_name VARCHAR(255),
            value_total FLOAT,
            plate VARCHAR(50) NOT NULL,
            status VARCHAR(100) NOT NULL
          )
        ''');

        batch.execute('''
            CREATE TABLE geolocations (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              travel_id INTEGER
              travel_id_api VARCHAR NOT NULL,
              latitude double NOT NULL,
              longitude double NOT NULL,
              collection_date DATE_TIME NOT NULL,
              status_send_api VARCHAR(100),
              date_send_api DATE_TIME
            )
          ''');

        batch.execute('''
            CREATE TABLE IF NOT EXISTS tolls (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              travel_id INTEGER NOT NULL,
              travel_id_api VARCHAR,
              toll_name VARCHAR(100) NOT NULL,
              pass_order INTEGER NOT NULL,
              quantity_axes INTEGER NOT NULL,
              ailog_id INTEGER NOT NULL,
              concessionaire VARCHAR(255) NOT NULL,
              highway VARCHAR(255) NOT NULL,
              date_passage DATE_TIME,
              value_tag FLOAT NOT NULL,
              value_manual FLOAT NOT NULL,
              accept_automatic_billing BOOLEAN DEFAULT 0,
              accept_payment_proximity BOOLEAN DEFAULT 0
            )
          ''');

        batch.execute('''
            CREATE TABLE IF NOT EXISTS travel_addresses (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              travel_id INTEGER,
              travel_id_api VARCHAR(255),
              pass_order INTEGER NOT NULL,
              type_operation VARCHAR(255),
              city VARCHAR(255),
              state VARCHAR(255),
              address VARCHAR(255),
              neighborhood VARCHAR(255),
              country VARCHAR(255) DEFAULT 'Brasil',
              zip_code VARCHAR(255),
              number VARCHAR(255),
              complement VARCHAR(255),
              latitude double,
              longitude double,
              estimated_departure DATE_TIME,
              estimated_arrival DATE_TIME,
              real_departure DATE_TIME,
              real_arrival DATE_TIME
            )
          ''');

        batch.execute('''
            CREATE TABLE IF NOT EXISTS clients (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              address_id INTEGER NOT NULL,
              travel_id INTEGER,
              travel_id_api VARCHAR(255),
              name VARCHAR(255) NOT NULL,
              type_document VARCHAR(255),
              document_number VARCHAR(255),
              document_number_without_mask VARCHAR(255),
              cell_phone VARCHAR(255),
              phone VARCHAR(255)
            )
          ''');

        batch.commit();
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {},
    );
  }
}
