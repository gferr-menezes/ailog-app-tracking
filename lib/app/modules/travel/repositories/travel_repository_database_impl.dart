import '../../../database/database_sqlite.dart';
import '../models/address_model.dart';
import '../models/geolocation_model.dart';
import '../models/toll_model.dart';
import '../models/travel_model.dart';
import './travel_repository_database.dart';

class TravelRepositoryDatabaseImpl implements TravelRepositoryDatabase {
  @override
  Future<int> insertTravel(TravelModel travel) async {
    final db = await DatabaseSQLite().openConnection();

    final id = await db.transaction<int>((txn) async {
      final travelId = await txn.insert('travels', {
        'code': travel.code?.toLowerCase(),
        'travel_id_api': travel.travelIdApi,
        'estimated_departure': travel.estimatedDeparture?.toIso8601String(),
        'estimated_arrival': travel.estimatedArrival?.toIso8601String(),
        'vpo_emit_name': travel.vpoEmitName?.toLowerCase(),
        'value_total': travel.valueTotal,
        'plate': travel.plate?.toLowerCase(),
        'status': travel.status,
      });

      // addresses
      if (travel.addresses != null) {
        for (final address in travel.addresses!) {
          final addressId = await txn.insert('travel_addresses', {
            'travel_id': travelId,
            'travel_id_api': address.travelIdApi,
            'pass_order': address.passOrder,
            'type_operation': address.typeOperation?.toLowerCase(),
            'city': address.city.toLowerCase(),
            'state': address.state.toLowerCase(),
            'address': address.address?.toLowerCase(),
            'neighborhood': address.neighborhood?.toLowerCase(),
            'country': address.country?.toLowerCase(),
            'zip_code': address.zipCode?.toLowerCase(),
            'number': address.number?.toLowerCase(),
            'complement': address.complement?.toLowerCase(),
            'latitude': address.latitude,
            'longitude': address.longitude,
            'estimated_departure': address.estimatedDeparture?.toIso8601String(),
            'estimated_arrival': address.estimatedArrival?.toIso8601String(),
            'real_departure': address.realDeparture?.toIso8601String(),
            'real_arrival': address.realArrival?.toIso8601String(),
          });

          // client
          if (address.client != null) {
            await txn.insert('clients', {
              'address_id': addressId,
              'travel_id': travelId,
              'travel_id_api': address.travelIdApi,
              'name': address.client?.name.toLowerCase(),
              'type_document': address.client?.typeDocument?.toLowerCase(),
              'document_number': address.client?.documentNumber?.toLowerCase(),
              'document_number_without_mask': address.client?.documentNumberWithoutMask?.toLowerCase(),
              'cell_phone': address.client?.cellPhone?.toLowerCase(),
              'phone': address.client?.phone?.toLowerCase(),
            });
          }
        }
      }

      // tolls
      if (travel.tolls != null) {
        for (final toll in travel.tolls!) {
          await txn.insert('tolls', {
            'travel_id': travelId,
            'travel_id_api': toll.travelIdApi,
            'toll_name': toll.tollName.toLowerCase(),
            'pass_order': toll.passOrder,
            'quantity_axes': toll.quantityAxes,
            'ailog_id': toll.ailogId,
            'concessionaire': toll.concessionaire.toLowerCase(),
            'highway': toll.highway.toLowerCase(),
            'date_passage': toll.datePassage?.toIso8601String(),
            'value_tag': toll.valueTag,
            'value_manual': toll.valueManual,
            'accept_automatic_billing': toll.acceptAutomaticBilling,
            'accept_payment_proximity': toll.acceptPaymentProximity,
            'latitude': toll.latitude,
            'longitude': toll.longitude,
            'value_informed': toll.valueInformed,
          });
        }
      }

      return travelId;
    });

    return id;
  }

  @override
  Future<List<TravelModel>?> getTravels({String? plate, String? status, int? id}) async {
    final db = await DatabaseSQLite().openConnection();
    final List<TravelModel> travels = [];
    final List<AddressModel> addresses = [];
    final List<TollModel> tolls = [];

    final where = <String>[];

    if (plate != null) {
      where.add('plate = ?');
    }

    if (status != null) {
      where.add('status = ?');
    }

    if (id != null) {
      where.add('id = ?');
    }

    final whereString = where.join(' AND ');

    final whereArgs = <dynamic>[];

    if (plate != null) {
      whereArgs.add(plate.toLowerCase());
    }

    if (status != null) {
      whereArgs.add(status);
    }

    if (id != null) {
      whereArgs.add(id);
    }

    final travelsData = await db.query('travels', where: whereString, whereArgs: whereArgs);

    if (travelsData.isNotEmpty) {
      for (var travel in travelsData) {
        // get addresses
        final addressesData = await db.query('travel_addresses', where: 'travel_id = ?', whereArgs: [travel['id']]);
        if (addressesData.isNotEmpty) {
          for (var address in addressesData) {
            final newAddress = {...address};
            // get client
            final client = await db.query('clients', where: 'address_id = ?', whereArgs: [newAddress['id']]);
            if (client.isNotEmpty && client.first['name'] != null) {
              var clientData = client.first;
              newAddress['client'] = clientData;
            }

            addresses.add(AddressModel.fromJson(newAddress));
          }
        }

        // get tolls
        final tollsData = await db.query('tolls', where: 'travel_id = ?', whereArgs: [travel['id']]);
        if (tollsData.isNotEmpty) {
          for (var toll in tollsData) {
            tolls.add(TollModel.fromJson(toll));
          }
        }

        travels.add(
          TravelModel(
            id: travel['id'] as int,
            plate: travel['plate'] != null ? travel['plate'] as String : null,
            code: travel['code'] != null ? travel['code'] as String : null,
            travelIdApi: travel['travel_id_api'] as String,
            estimatedDeparture:
                travel['estimated_departure'] != null ? DateTime.parse(travel['estimated_departure'] as String) : null,
            estimatedArrival:
                travel['estimated_arrival'] != null ? DateTime.parse(travel['estimated_arrival'] as String) : null,
            vpoEmitName: travel['vpo_emit_name'] != null ? travel['vpo_emit_name'] as String : null,
            valueTotal: travel['value_total'] != null ? travel['value_total'] as double : null,
            status: travel['status'] != null ? travel['status'] as String : null,
            addresses: addresses,
            tolls: tolls,
          ),
        );
      }
    }

    return travelsData.isEmpty ? null : travels;
  }

  @override
  Future<List<AddressModel>?> getAddresses({required int travelId}) async {
    final db = await DatabaseSQLite().openConnection();
    final addresses = <AddressModel>[];
    final addressesData = await db.query('travel_addresses', where: 'travel_id = ?', whereArgs: [travelId]);

    if (addressesData.isNotEmpty) {
      for (var address in addressesData) {
        final newAddress = {...address};
        final client = await db.query('clients', where: 'address_id = ?', whereArgs: [newAddress['id']]);
        if (client.isNotEmpty) {
          newAddress['client'] = client.first;
        }

        addresses.add(AddressModel.fromJson(newAddress));
      }
    }

    return addressesData.isEmpty ? null : addresses;
  }

  @override
  Future<List<TollModel>?> getTolls({required int travelId}) async {
    final db = await DatabaseSQLite().openConnection();
    final tolls = <TollModel>[];
    final tollsData = await db.query('tolls', where: 'travel_id = ?', whereArgs: [travelId]);

    if (tollsData.isNotEmpty) {
      for (var toll in tollsData) {
        tolls.add(TollModel.fromJson(toll));
      }
    }

    return tollsData.isEmpty ? null : tolls;
  }

  @override
  Future<void> insertGeolocations({required List<GeolocationModel> geolocations}) async {
    try {
      final db = await DatabaseSQLite().openConnection();

      for (final geolocation in geolocations) {
        await db.insert('geolocations', {
          'latitude': geolocation.latitude,
          'longitude': geolocation.longitude,
          'collection_date': geolocation.collectionDate.toIso8601String(),
          'travel_id': geolocation.travelId,
          'status_send_api': geolocation.statusSendApi,
          'date_send_api': geolocation.dateSendApi?.toIso8601String(),
        });
      }
      print('insertGeolocations success');
    } catch (e) {
      print('insertGeolocations error');
      throw Exception(e);
    }
  }

  @override
  Future<List<GeolocationModel>?> getGeolocations({int? travelId, String? statusSendApi}) async {
    final db = await DatabaseSQLite().openConnection();
    final geolocations = <GeolocationModel>[];
    List<Map<String, Object?>> geolocationsData;

    if (travelId != null) {
      geolocationsData = await db.query('geolocations', where: 'travel_id = ?', whereArgs: [travelId]);
    } else {
      geolocationsData = await db.query('geolocations', where: 'status_send_api = ?', whereArgs: [statusSendApi]);
    }

    if (geolocationsData.isNotEmpty) {
      for (var geolocation in geolocationsData) {
        geolocations.add(GeolocationModel.fromJson(geolocation));
      }
    }
    return geolocationsData.isEmpty ? null : geolocations;
  }

  @override
  Future<void> updateGeolocations({required List<GeolocationModel> geolocations}) async {
    final db = await DatabaseSQLite().openConnection();
    await db.transaction<void>((txn) async {
      for (final geolocation in geolocations) {
        await txn.update(
          'geolocations',
          {
            'status_send_api': geolocation.statusSendApi,
            'date_send_api': geolocation.dateSendApi?.toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [geolocation.id],
        );
      }
    });
  }

  @override
  Future<void> updateTravel({required TravelModel travel}) async {
    final db = await DatabaseSQLite().openConnection();

    await db.update(
      'travels',
      {
        'status': travel.status,
      },
      where: 'id = ?',
      whereArgs: [travel.id],
    );
  }

  @override
  Future<void> updateToll({required TollModel toll}) async {
    final db = await DatabaseSQLite().openConnection();

    await db.update(
      'tolls',
      {
        'value_informed': toll.valueInformed,
      },
      where: 'id = ?',
      whereArgs: [toll.id],
    );
  }
}
