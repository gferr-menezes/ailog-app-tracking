import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSQLite {
  Future<Database> openConnection() async {
    final databasePath = await getDatabasesPath();
    final databaseFinalPath = join(databasePath, 'ailog.db');

    return await openDatabase(
      databaseFinalPath,
      version: 10,
      onCreate: (Database db, int version) async {
        log('Criando banco de dados versão $version');

        final batch = db.batch();

        batch.execute('''
          CREATE TABLE IF NOT EXISTS travels (
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
            CREATE TABLE IF NOT EXISTS geolocations (
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
              value_informed FLOAT,
              accept_automatic_billing BOOLEAN DEFAULT 0,
              accept_payment_proximity BOOLEAN DEFAULT 0,
              latitude double,
              longitude double,
              url_voucher_image VARCHAR(255)
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

        batch.execute('''
            CREATE TABLE IF NOT EXISTS supplies (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              supply_id_api INTEGER,
              travel_id INTEGER NOT NULL,
              travel_id_api VARCHAR(255),
              value_liter FLOAT NOT NULL,
              liters FLOAT NOT NULL,
              odometer INTEGER NOT NULL,
              path_image_pump VARCHAR(255),
              url_image_pump VARCHAR(255),
              path_image_odometer VARCHAR(255),
              url_image_odometer VARCHAR(255),
              path_image_invoice VARCHAR(255),
              url_image_invoice VARCHAR(255),
              date_supply DATE_TIME default CURRENT_TIMESTAMP,
              status_send_api VARCHAR(100),
              date_send_api DATE_TIME,
              latitude double,
              longitude double,
              ocr_recibo TEXT
            )
          ''');

        batch.commit();
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < newVersion) {
          log('Atualizando banco de dados da versão $oldVersion para $newVersion');

          final batch = db.batch();

          batch.execute('''
          CREATE TABLE IF NOT EXISTS travels (
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
            CREATE TABLE IF NOT EXISTS geolocations (
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
              accept_payment_proximity BOOLEAN DEFAULT 0,
              latitude double,
              longitude double
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

          batch.execute('''
            CREATE TABLE IF NOT EXISTS supplies (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              supply_id_api INTEGER,
              travel_id INTEGER NOT NULL,
              travel_id_api VARCHAR(255),
              value_liter FLOAT NOT NULL,
              liters FLOAT NOT NULL,
              odometer INTEGER NOT NULL,
              path_image_pump VARCHAR(255),
              url_image_pump VARCHAR(255),
              path_image_odometer VARCHAR(255),
              url_image_odometer VARCHAR(255),
              path_image_invoice VARCHAR(255),
              url_image_invoice VARCHAR(255),
              date_supply DATE_TIME default CURRENT_TIMESTAMP,
              status_send_api VARCHAR(100),
              date_send_api DATE_TIME,
              latitude double,
              longitude double,
              ocr_recibo TEXT
            )
          ''');

          var checkColumnExists = await db.rawQuery('''
            SELECT * FROM pragma_table_info('tolls') WHERE name = 'latitude';
          ''');

          if (checkColumnExists.isEmpty) {
            batch.execute('''
              ALTER TABLE tolls ADD COLUMN latitude double;
            ''');
          }

          checkColumnExists = await db.rawQuery('''
            SELECT * FROM pragma_table_info('tolls') WHERE name = 'longitude';
          ''');

          if (checkColumnExists.isEmpty) {
            batch.execute('''
              ALTER TABLE tolls ADD COLUMN longitude double;
            ''');
          }

          checkColumnExists = await db.rawQuery('''
            SELECT * FROM pragma_table_info('tolls') WHERE name = 'value_informed';
          ''');

          if (checkColumnExists.isEmpty) {
            batch.execute('''
              ALTER TABLE tolls ADD COLUMN value_informed FLOAT;
            ''');
          }

          checkColumnExists = await db.rawQuery('''
            SELECT * FROM pragma_table_info('tolls') WHERE name = 'url_voucher_image';
          ''');

          if (checkColumnExists.isEmpty) {
            batch.execute('''
              ALTER TABLE tolls ADD COLUMN url_voucher_image VARCHAR(255);
            ''');
          }

          checkColumnExists = await db.rawQuery('''
            SELECT * FROM pragma_table_info('supplies') WHERE name = 'latitude';
          ''');

          if (checkColumnExists.isEmpty) {
            batch.execute('''
              ALTER TABLE supplies ADD COLUMN latitude double;
            ''');
          }

          checkColumnExists = await db.rawQuery('''
            SELECT * FROM pragma_table_info('supplies') WHERE name = 'longitude';
          ''');

          if (checkColumnExists.isEmpty) {
            batch.execute('''
              ALTER TABLE supplies ADD COLUMN longitude double;
            ''');
          }

          checkColumnExists = await db.rawQuery('''
            SELECT * FROM pragma_table_info('supplies') WHERE name = 'ocr_recibo';
          ''');

          if (checkColumnExists.isEmpty) {
            batch.execute('''
              ALTER TABLE supplies ADD COLUMN ocr_recibo TEXT;
            ''');
          }

          batch.commit();
        }
      },
    );
  }
}
