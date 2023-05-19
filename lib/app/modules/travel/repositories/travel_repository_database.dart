import '../models/address_model.dart';
import '../models/toll_model.dart';
import '../models/travel_model.dart';

abstract class TravelRepositoryDatabase {
  Future<int> insertTravel(TravelModel travel);
  Future<List<TravelModel>?> getTravels({String? plate, String? status, String? id});
  Future<List<AddressModel>?> getAddresses({required int travelId});
  Future<List<TollModel>?> getTolls({required int travelId});
}
