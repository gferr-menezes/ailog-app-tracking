import 'dart:developer';

import 'package:ailog_app_tracking/app/modules/travel/models/lat_long_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/rotogram_model.dart';

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
            'url_voucher_image': toll.urlVoucherImage,
          });
        }
      }

      // rotograms
      if (travel.rotograms != null) {
        for (final rotogram in travel.rotograms!) {
          await txn.insert('rotograms_data', {
            'travel_id': travelId,
            'travel_id_api': travel.travelIdApi,
            'description': rotogram.description?.toLowerCase(),
            'url_icon': rotogram.urlIcon,
            'distance_traveled_km': rotogram.distanceTraveledKm,
            'distance_traveled_formatted': rotogram.distanceTraveledFormatted,
            'travel_time_seconds': rotogram.travelTimeSeconds,
            'information_id': rotogram.informationPoint?.informationId,
            'pass_order': rotogram.informationPoint?.orderPassage,
            'value': rotogram.informationPoint?.value,
            'value_discount': rotogram.informationPoint?.valueDiscount,
            'change_value': rotogram.informationPoint?.weekend?.changeValue,
            'day_start': rotogram.informationPoint?.weekend?.dayStart,
            'hour_start': rotogram.informationPoint?.weekend?.hourStart,
            'day_end': rotogram.informationPoint?.weekend?.dayEnd,
            'hour_end': rotogram.informationPoint?.weekend?.hourEnd,
            'value_weekend': rotogram.informationPoint?.weekend?.value,
            'value_tag_weekend': rotogram.informationPoint?.weekend?.valueTag,
            'category_vehicle': rotogram.informationPoint?.categoryVehicle,
            'direction_route': rotogram.directionRoute?.name,
            'latitude': rotogram.latLng?.latitude,
            'longitude': rotogram.latLng?.longitude,
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
        'url_voucher_image': toll.urlVoucherImage,
      },
      where: 'id = ?',
      whereArgs: [toll.id],
    );
  }

  @override
  Future<void> registerArrivalClient({required AddressModel address}) async {
    try {
      final db = await DatabaseSQLite().openConnection();

      final addressData = await db.query('travel_addresses', where: 'id = ?', whereArgs: [address.id]);

      if (addressData.isNotEmpty) {
        await db.update(
          'travel_addresses',
          {
            'real_arrival': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [address.id],
        );
      }
    } catch (e) {
      log('registerArrivalClient error: $e');
      throw Exception(e);
    }
  }

  @override
  Future<void> registerDepartureClient({required AddressModel address}) async {
    try {
      final db = await DatabaseSQLite().openConnection();

      final addressData = await db.query('travel_addresses', where: 'id = ?', whereArgs: [address.id]);

      if (addressData.isNotEmpty) {
        await db.update(
          'travel_addresses',
          {
            'real_departure': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [address.id],
        );
      }
    } catch (e) {
      log('registerDepartureClient error: $e');
      throw Exception(e);
    }
  }

  @override
  Future<List<RotogramModel>?> getRotograms({required int travelId}) async {
    try {
      final db = await DatabaseSQLite().openConnection();
      final rotograms = <RotogramModel>[];
      final rotogramsData = await db.query('rotograms_data', where: 'travel_id = ?', whereArgs: [travelId]);

      if (rotogramsData.isNotEmpty) {
        for (var rotogram in rotogramsData) {
          rotograms.add(
            RotogramModel(
              description: rotogram['description'] != null ? rotogram['description'] as String : null,
              urlIcon: rotogram['url_icon'] != null ? rotogram['url_icon'] as String : null,
              distanceTraveledKm:
                  rotogram['distance_traveled_km'] != null ? rotogram['distance_traveled_km'] as double : null,
              travelTimeSeconds:
                  rotogram['travel_time_seconds'] != null ? rotogram['travel_time_seconds'] as int : null,
              distanceTraveledFormatted: rotogram['distance_traveled_formatted'] != null
                  ? rotogram['distance_traveled_formatted'] as String
                  : null,
              directionRoute: rotogram['direction_route'] != null
                  ? DirectionRoute.values.firstWhere((e) => e.name == rotogram['direction_route'])
                  : null,
              id: rotogram['id'] != null ? rotogram['id'] as int : null,
              informationPoint: rotogram['information_id'] != null
                  ? InformationPointRotogramModel(
                      informationId: rotogram['information_id'] as int,
                      orderPassage: rotogram['pass_order'] as int,
                      value: rotogram['value'] as double,
                      valueDiscount: rotogram['value_discount'] as double,
                      weekend: ValueTollWeekModel(
                        changeValue: rotogram['change_value'] == 0 ? false : true,
                        dayStart: rotogram['day_start'] as String?,
                        hourStart: rotogram['hour_start'] as String?,
                        dayEnd: rotogram['day_end'] as String?,
                        hourEnd: rotogram['hour_end'] as String?,
                        value: rotogram['value_weekend'] as double,
                        valueTag: rotogram['value_tag_weekend'] as double?,
                      ),
                      categoryVehicle: rotogram['category_vehicle'] as String?,
                    )
                  : null,
              travelId: rotogram['travel_id'] as int?,
              travelIdApi: rotogram['travel_id_api'] as String?,
              latLng: rotogram['latitude'] != null && rotogram['longitude'] != null
                  ? LatLongModel(
                      latitude: rotogram['latitude'] as double,
                      longitude: rotogram['longitude'] as double,
                    )
                  : null,
            ),
          );
        }
      }

      return rotogramsData.isEmpty ? null : rotograms;
    } catch (e) {
      log('getRotograms error: $e');
      throw Exception(e);
    }
  }
}
